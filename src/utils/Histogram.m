classdef Histogram


    properties (Constant)
        Levels = 256  
    end

    methods (Static)
        function counts = compute(channel)
            Histogram.checkChannel(channel);

            counts = zeros(1, Histogram.Levels);

            for intensity = 0:Histogram.Levels - 1
                isThisIntensity = (channel == intensity);
                counts(intensity + 1) = nnz(isThisIntensity);
            end
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
