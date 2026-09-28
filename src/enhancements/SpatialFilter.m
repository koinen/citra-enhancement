classdef SpatialFilter < Enhancement
    % SpatialFilter  Image filtering with a mask (neighbourhood operation).

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

        function out = apply(obj, img)
            switch obj.Mode
                case 'linear'
                    out = obj.applyPerChannel(img, @(channel) convolve(channel, obj.Kernel));
                case 'median'
                    out = obj.applyPerChannel(img, @(channel) medianFilter(channel, obj.WindowSize));
                otherwise
                    error('SpatialFilter:unknownMode', ...
                        'Unknown mode "%s". Use linear or median.', obj.Mode);
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

    % Instead of visiting every pixel, visit every mask position once:
    % shift the whole image by that offset and add it with the mask weight.
    total = zeros(height, width);
    for i = 1:kernelHeight
        for j = 1:kernelWidth
            total = total + kernel(i, j) * padded(i:i + height - 1, j:j + width - 1);
        end
    end

    % uint8() rounds and clips anything outside 0..255 (e.g. from sharpening).
    out = uint8(total);
end


function out = medianFilter(channel, windowSize)
    [height, width] = size(channel);
    radius = floor(windowSize / 2);
    padded = padReplicate(channel, radius, radius);

    % Stack every neighbour of every pixel along the 3rd dimension,
    % then take the median along that dimension.
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
    % Add a border by repeating the outermost rows and columns, so the mask
    % also has neighbours to look at on the image edges.
    [height, width] = size(channel);
    rows = [ones(1, padRows), 1:height, height * ones(1, padRows)];
    cols = [ones(1, padCols), 1:width, width * ones(1, padCols)];
    padded = channel(rows, cols);
end
