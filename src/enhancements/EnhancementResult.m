classdef EnhancementResult
    %ENHANCEMENTRESPONSE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        Image           % output matrix, same colorspace as input
        MethodName      % e.g. "Gamma Correction", "Median Filter 5x5"
        ParamsUsed      % echoed back for GUI display / report
        Success = true
        Error = []
    end
end