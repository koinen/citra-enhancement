classdef HistogramEqualization < Enhancement
    % HistogramEqualization  Global histogram equalization.

    methods
        function obj = HistogramEqualization()
            obj.Name = 'Histogram Equalization';
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
