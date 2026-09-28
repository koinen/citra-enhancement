classdef IntensityTransformation < Enhancement
    % IntensityTransformation  Point-wise intensity mapping (negative, log, gamma, stretch).

    properties
        Method char = 'gamma'   
        Gamma double = 1.0      
    end

    methods
        function obj = IntensityTransformation(method, gamma)
            obj.Name = 'Intensity Transformation';

            if nargin >= 1
                obj.Method = method;
            end

            if nargin >= 2
                obj.Gamma = gamma;
            end
        end

        function out = apply(obj, img)
            out = obj.applyPerChannel(img, @(channel) obj.transformChannel(channel));
        end
    end

    methods (Access = private)
        function out = transformChannel(obj, channel)
            % Work with intensities normalised to [0, 1], so every formula
            % below maps [0, 1] onto [0, 1].
            r = (0:255) / 255;

            switch obj.Method
                case 'negative'
                    s = 1 - r;

                case 'log'
                    % s = c * log(1 + r), with c chosen so that r = 1 gives s = 1.
                    % Dark values are stretched, bright values are compressed.
                    s = log(1 + 255 * r) / log(256);

                case 'gamma'
                    s = r .^ obj.Gamma;

                case 'stretch'
                    % Linear contrast stretching: the darkest pixel of the
                    % channel becomes 0 and the brightest becomes 1.
                    low = double(min(channel(:))) / 255;
                    high = double(max(channel(:))) / 255;

                    if high > low
                        s = (r - low) / (high - low);
                    else
                        s = r;   % flat channel, nothing to stretch
                    end

                otherwise
                    error('IntensityTransformation:unknownMethod', ...
                        'Unknown method "%s". Use negative, log, gamma or stretch.', obj.Method);
            end

            % Build a 256-entry lookup table and read every pixel from it.
            % min/max clip values that the stretch pushes outside [0, 1].
            lookup = uint8(round(255 * min(max(s, 0), 1)));
            pixelIndex = double(channel) + 1;
            out = lookup(pixelIndex);
        end
    end
end
