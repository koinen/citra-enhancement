classdef IntensityTransformation < Enhancement
    % IntensityTransformation  Point-wise intensity mapping (negative, log, gamma, stretch).

    properties
        Method char = 'gamma'
        Gamma double = 1.0
        C double = 1.0             % log constant; 1 maps 255 to 255
        InputRange double = []     % [low high] in 0..255 for 'stretch'; empty = channel min/max
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

        function out = apply(obj, request)
            arguments
                obj
                request (1, 1) EnhancementRequest
            end

            out = EnhancementResult;
            out.Image = obj.applyPerChannel(request.Image, @(channel) obj.transformChannel(channel));
            out.MethodName = sprintf('%s (%s)', obj.Name, obj.Method);
            out.ParamsUsed = struct('Method', obj.Method, 'Gamma', obj.Gamma, ...
                'C', obj.C, 'InputRange', obj.InputRange);
        end
    end

    methods (Access = private)
        function out = transformChannel(obj, channel)
            % Every formula maps r in [0, 1] to s in [0, 1].
            r = (0:255) / 255;

            switch obj.Method
                case 'negative'
                    s = 1 - r;

                case 'log'
                    % s = c * log(1 + r), scaled so that c = 1 maps r = 1 to s = 1.
                    s = obj.C * log(1 + 255 * r) / log(256);

                case 'gamma'
                    s = r .^ obj.Gamma;

                case 'stretch'
                    % Map [low, high] linearly onto [0, 1]. By default low and
                    % high are the darkest and brightest pixel of the channel.
                    if isempty(obj.InputRange)
                        low = double(min(channel(:))) / 255;
                        high = double(max(channel(:))) / 255;
                    else
                        low = obj.InputRange(1) / 255;
                        high = obj.InputRange(2) / 255;
                    end

                    if high > low
                        s = (r - low) / (high - low);
                    else
                        s = r;
                    end

                otherwise
                    error('IntensityTransformation:unknownMethod', ...
                        'Unknown method "%s". Use negative, log, gamma or stretch.', obj.Method);
            end

            % Clip to [0, 1] and apply as a 256-entry lookup table.
            lookup = uint8(round(255 * min(max(s, 0), 1)));
            pixelIndex = double(channel) + 1;
            out = lookup(pixelIndex);
        end
    end
end
