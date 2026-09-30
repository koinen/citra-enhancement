classdef Histogram


    properties (Constant)
        Levels = 256  
    end

    methods (Static)
        function isSame = matchesImhist(img)
            isSame = true;
            for c = 1:size(img, 3)
                diyCounts = Histogram.compute(img(:, :, c));
                builtinCounts = imhist(img(:, :, c), Histogram.Levels);
                if ~isequal(diyCounts(:), builtinCounts(:))
                    isSame = false;
                    return
                end
            end
        end

        function counts = compute(channel)
            Histogram.checkChannel(channel);

            counts = zeros(1, Histogram.Levels);

            for intensity = 0:Histogram.Levels - 1
                isThisIntensity = (channel == intensity);
                counts(intensity + 1) = nnz(isThisIntensity);
            end
        end

        function histograms = forImage(img)
            Histogram.checkImage(img);

            if size(img, 3) == 1
                valueChannel = img;
                histograms = struct('value', Histogram.compute(valueChannel));
                return
            end

            hsv = rgb2hsv(img);
            valueChannel = uint8(round(255 * hsv(:, :, 3)));

            histograms = struct( ...
                'red', Histogram.compute(img(:, :, 1)), ...
                'green', Histogram.compute(img(:, :, 2)), ...
                'blue', Histogram.compute(img(:, :, 3)), ...
                'value', Histogram.compute(valueChannel));
        end

        function probability = pdf(channel)
            counts = Histogram.compute(channel);
            totalPixels = numel(channel);

            probability = counts / totalPixels;
        end

        function cumulative = cdf(channel)
            probability = Histogram.pdf(channel);

            cumulative = cumsum(probability);
        end
    end

    methods (Static, Access = private)
        function checkImage(img)
            if ~isa(img, 'uint8')
                error('Histogram:notUint8Image', ...
                    'Expected a uint8 image, but got %s.', class(img));
            end

            isGrayscale = ismatrix(img);
            isRgb = ndims(img) == 3 && size(img, 3) == 3;
            if ~isGrayscale && ~isRgb
                error('Histogram:notGrayscaleOrRgb', ...
                    'Expected a grayscale or RGB image.');
            end
        end

        function checkChannel(channel)
            if ~isa(channel, 'uint8')
                error('Histogram:notUint8', ...
                    'Expected a uint8 channel (values 0..255), but got %s.', ...
                    class(channel));
            end

            if ~ismatrix(channel)
                error('Histogram:notSingleChannel', ...
                    ['Expected a single channel (2-D matrix). ' ...
                     'Split RGB images into their R, G and B channels first.']);
            end
        end
    end
end
