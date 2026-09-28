classdef (Abstract) Enhancement
    % Enhancement  Common base class for every image enhancement technique.

    properties
        Name char = ''
    end

    methods (Abstract)
        out = apply(obj, request)
    end

    methods (Static, Access = protected)
        function out = applyPerChannel(img, channelFn)
            out = img;
            numChannels = size(img, 3);

            for k = 1:numChannels
                out(:, :, k) = channelFn(img(:, :, k));
            end
        end
    end
end
