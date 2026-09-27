classdef SpatialFilter < Enhancement
    % SpatialFilter  Image filtering with masking: linear convolution or median.

    properties
        Mode char = 'linear'   % 'linear' | 'median'
        Kernel double = ones(3) / 9
        WindowSize double = 3
    end

    methods
        function obj = SpatialFilter(mode)
            obj.Name = 'Spatial Filter';
            if nargin >= 1, obj.Mode = mode; end
        end

        function out = apply(obj, request)
            arguments
                obj
                request (1, 1) EnhancementRequest
            end
            % TODO: implement
            % out = img;
            out = EnhancementResult;
            % out.Image = ...
        end
    end
end
