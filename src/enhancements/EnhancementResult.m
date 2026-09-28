classdef EnhancementResult
    % EnhancementResult  Output of Enhancement.apply.

    properties
        Image           % output matrix, same colorspace as input
        MethodName      % e.g. "Gamma Correction", "Median Filter 5x5"
        ParamsUsed      % echoed back for GUI display / report
        Success = true
        Error = []
    end
end
