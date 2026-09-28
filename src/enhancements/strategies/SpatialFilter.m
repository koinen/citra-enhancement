classdef SpatialFilter < Enhancement
    % SpatialFilter  Image filtering with masking: linear convolution or median.

    properties
        Mode char = 'linear'          % 'linear' or 'median'
        Kernel double = ones(3) / 9   % convolution mask for 'linear'
        WindowSize double = 3         % odd neighbourhood size for 'median'
    end

    methods
        function obj = SpatialFilter(mode, param)
            % SpatialFilter('linear', kernel) or SpatialFilter('median', windowSize)
            obj.Name = 'Spatial Filter';

            if nargin >= 1
                obj.Mode = mode;
            end

            if nargin >= 2
                if strcmp(obj.Mode, 'median')
                    obj.WindowSize = param;
                else
                    obj.Kernel = param;
                end
            end
        end

        function out = apply(obj, request)
            arguments
                obj
                request (1, 1) EnhancementRequest
            end

            out = EnhancementResult;
            out.MethodName = sprintf('%s (%s)', obj.Name, obj.Mode);

            switch obj.Mode
                case 'linear'
                    out.Image = obj.applyPerChannel(request.Image, @(channel) convolve(channel, obj.Kernel));
                    out.ParamsUsed = struct('Mode', obj.Mode, 'Kernel', obj.Kernel);
                case 'median'
                    out.Image = obj.applyPerChannel(request.Image, @(channel) medianFilter(channel, obj.WindowSize));
                    out.ParamsUsed = struct('Mode', obj.Mode, 'WindowSize', obj.WindowSize);
                otherwise
                    error('SpatialFilter:unknownMode', ...
                        'Unknown mode "%s". Use linear or median.', obj.Mode);
            end
        end
    end

    methods (Static)
        function kernel = makeKernel(type, windowSize, sigma)
            % makeKernel('Mean' | 'Box' | 'Gaussian' | 'Laplacian', windowSize, sigma)
            %   sigma is only used by 'Gaussian'. 'Laplacian' is always 3x3.
            switch lower(type)
                case {'mean', 'box'}
                    kernel = ones(windowSize) / windowSize ^ 2;

                case 'gaussian'
                    half = floor(windowSize / 2);
                    [x, y] = meshgrid(-half:half);
                    kernel = exp(-(x .^ 2 + y .^ 2) / (2 * sigma ^ 2));
                    kernel = kernel / sum(kernel(:));   % weights sum to 1, brightness is kept

                case 'laplacian'
                    % Image minus its Laplacian: sharpens edges, unlike the
                    % plain Laplacian which only returns the edges.
                    kernel = [0 -1 0; -1 5 -1; 0 -1 0];

                otherwise
                    error('SpatialFilter:unknownKernel', ...
                        'Unknown kernel "%s". Use Mean, Box, Gaussian or Laplacian.', type);
            end
        end
    end
end


function out = convolve(channel, kernel)
    [height, width] = size(channel);
    [kernelHeight, kernelWidth] = size(kernel);

    % Convolution is correlation with the mask rotated by 180 degrees.
    kernel = rot90(kernel, 2);
    padded = double(padReplicate(channel, floor(kernelHeight / 2), floor(kernelWidth / 2)));

    % Add a weighted, shifted copy of the image for every mask position.
    total = zeros(height, width);
    for i = 1:kernelHeight
        for j = 1:kernelWidth
            total = total + kernel(i, j) * padded(i:i + height - 1, j:j + width - 1);
        end
    end

    % uint8() rounds and clips to 0..255 (sharpening can overshoot).
    out = uint8(total);
end


function out = medianFilter(channel, windowSize)
    [height, width] = size(channel);
    radius = floor(windowSize / 2);
    padded = padReplicate(channel, radius, radius);

    % Stack the neighbours of every pixel along the 3rd dimension.
    neighbours = zeros(height, width, windowSize ^ 2, 'uint8');
    n = 0;
    for i = 1:windowSize
        for j = 1:windowSize
            n = n + 1;
            neighbours(:, :, n) = padded(i:i + height - 1, j:j + width - 1);
        end
    end

    out = median(neighbours, 3);
end


function padded = padReplicate(channel, padRows, padCols)
    % Repeat the outermost rows and columns so edge pixels have neighbours.
    [height, width] = size(channel);
    rows = [ones(1, padRows), 1:height, height * ones(1, padRows)];
    cols = [ones(1, padCols), 1:width, width * ones(1, padCols)];
    padded = channel(rows, cols);
end
