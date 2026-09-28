classdef HistogramEqualization < Enhancement
    % HistogramEqualization  Spread the intensities so the histogram becomes roughly flat.

    methods
        function obj = HistogramEqualization()
            obj.Name = 'Histogram Equalization';
        end

        function out = apply(obj, request)
            arguments
                obj
                request (1, 1) EnhancementRequest
            end

            out = EnhancementResult;
            out.Image = applyToBrightness(request.Image, @equalizeChannel);
            out.MethodName = obj.Name;
            out.ParamsUsed = struct();
        end
    end
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


function out = equalizeChannel(channel)
    % s = 255 * CDF(r), applied through a 256-entry lookup table.
    cdf = Histogram.cdf(channel);
    lookup = uint8(round(255 * cdf));
    pixelIndex = double(channel) + 1;
    out = lookup(pixelIndex);
end
