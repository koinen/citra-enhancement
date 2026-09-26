classdef HistogramEqualization < Enhancement
    % HistogramEqualization  Global histogram equalization.

    methods
        function obj = HistogramEqualization()
            obj.Name = 'Histogram Equalization';
        end

        function out = apply(obj, img)
            % TODO: implement using histogram256
            out = img;
        end
    end
end
