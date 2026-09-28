classdef HistogramEqualization < Enhancement
    % HistogramEqualization  Spread the intensities so the histogram becomes roughly flat.


    methods
        function obj = HistogramEqualization()
            obj.Name = 'Histogram Equalization';
        end

        function out = apply(~, img)
            out = applyToBrightness(img, @equalizeChannel);
        end
    end
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


function out = equalizeChannel(channel)
    cdf = Histogram.cdf(channel);
    lookup = uint8(round(255 * cdf));
    pixelIndex = double(channel) + 1;
    out = lookup(pixelIndex);
end
