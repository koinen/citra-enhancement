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

        function out = apply(obj, request)
            arguments
                obj
                request (1, 1) EnhancementRequest
            end
            % TODO: implement
            out = EnhancementResult;

        end
    end
end
