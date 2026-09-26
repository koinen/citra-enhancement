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

        function out = apply(obj, img)
            % TODO: implement
            out = img;
        end
    end
end
