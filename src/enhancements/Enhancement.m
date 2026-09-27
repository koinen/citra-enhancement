classdef (Abstract) Enhancement
    % Enhancement  Base interface for all image enhancement techniques.

    properties
        Name char = ''
    end

    methods (Abstract)
        % Returns the enhanced image. Output must keep the input's color type.
        out = apply(obj, request)
    end
end
