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

        function out = apply(obj, img)
            if isempty(obj.Reference)
                error('HistogramMatching:noReference', ...
                    'Set a reference image before applying histogram matching.');
            end

            refBrightness = brightnessOf(obj.Reference);
            out = applyToBrightness(img, @(channel) matchChannel(channel, refBrightness));
        end
    end
end


function brightness = brightnessOf(img)
    % V of HSV is simply the largest of R, G and B, so no conversion is needed.
    brightness = max(img, [], 3);
end


function out = applyToBrightness(img, channelFn)
    % Run channelFn on the brightness only. A grayscale image is its own
    % brightness. An RGB image is converted to HSV and only V is changed,
    % so hue and saturation stay the same.
    if size(img, 3) == 1
        out = channelFn(img);
        return
    end

    hsv = rgb2hsv(img);

    % V is in [0, 1]; bring it to 0..255 so it can be used as a uint8 channel.
    brightness = uint8(round(hsv(:, :, 3) * 255));
    hsv(:, :, 3) = double(channelFn(brightness)) / 255;

    out = uint8(round(hsv2rgb(hsv) * 255));
end


function out = matchChannel(channel, refChannel)
    inputCdf = Histogram.cdf(channel);
    refCdf = Histogram.cdf(refChannel);

    % For every input level r, pick the reference level z whose CDF value
    % is closest to the CDF of r. Both images then share (roughly) the
    % same cumulative distribution, so the histograms look alike.
    lookup = zeros(1, 256, 'uint8');
    for r = 1:256
        [~, z] = min(abs(refCdf - inputCdf(r)));
        lookup(r) = z - 1;
    end

    pixelIndex = double(channel) + 1;
    out = lookup(pixelIndex);
end
