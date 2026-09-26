classdef HistogramMatching < Enhancement
    % HistogramMatching  Histogram specification against a reference image.

    properties
        Reference = []
    end

    methods
        function obj = HistogramMatching(reference)
            obj.Name = 'Histogram Matching';
            if nargin >= 1, obj.Reference = reference; end
        end

        function out = apply(obj, img)
            % TODO: implement using histogram256
            out = img;
        end
    end
end
