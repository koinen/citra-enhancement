classdef IntensityTransformation < Enhancement
    % IntensityTransformation  Point-wise intensity mapping (e.g. negative, log, gamma).

    properties
        Method char = 'gamma'
        Gamma double = 1.0
    end

    methods
        function obj = IntensityTransformation(method, gamma)
            obj.Name = 'Intensity Transformation';
            if nargin >= 1, obj.Method = method; end
            if nargin >= 2, obj.Gamma = gamma; end
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
