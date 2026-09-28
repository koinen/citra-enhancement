classdef HistogramMatching < Enhancement
    % HistogramMatching  Reshape the histogram of an image to look like the one of a reference image.

    properties
        Reference = []
    end

    methods
        function obj = HistogramMatching(reference)
            obj.Name = 'Histogram Matching';

            if nargin >= 1
                obj.Reference = reference;
            end
        end

        function out = apply(obj, request)
            arguments
                obj
                request (1, 1) EnhancementRequest
            end

            reference = request.ReferenceImage;
            if isempty(reference)
                reference = obj.Reference;
            end

            if isempty(reference)
                error('HistogramMatching:noReference', ...
                    'Set a reference image before applying histogram matching.');
            end

            refBrightness = brightnessOf(reference);

            out = EnhancementResult;
            out.Image = applyToBrightness(request.Image, @(channel) matchChannel(channel, refBrightness));
            out.MethodName = obj.Name;
            out.ParamsUsed = struct();
        end
    end
end


function brightness = brightnessOf(img)
    % V of HSV is the largest of R, G and B.
    brightness = max(img, [], 3);
end


function out = applyToBrightness(img, channelFn)
    % Only V of HSV is changed, so hue and saturation (the colours) stay the same.
    if size(img, 3) == 1
        out = channelFn(img);
        return
    end

    hsv = rgb2hsv(img);
    brightness = uint8(round(hsv(:, :, 3) * 255));
    hsv(:, :, 3) = double(channelFn(brightness)) / 255;

    out = uint8(round(hsv2rgb(hsv) * 255));
end


function out = matchChannel(channel, refChannel)
    inputCdf = Histogram.cdf(channel);
    refCdf = Histogram.cdf(refChannel);

    % Map every input level r to the reference level z whose CDF is closest
    % to CDF(r), so both images end up with (roughly) the same CDF.
    lookup = zeros(1, 256, 'uint8');
    for r = 1:256
        [~, z] = min(abs(refCdf - inputCdf(r)));
        lookup(r) = z - 1;
    end

    pixelIndex = double(channel) + 1;
    out = lookup(pixelIndex);
end
