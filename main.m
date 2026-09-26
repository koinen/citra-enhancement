function main(imgPath, refPath)
% MAIN  Apply every enhancement preset to one image and show the results.
%   main('data/Kasus 1/img.png')
%   main('data/Kasus 1/img.png', 'data/ref.png')   % reference for matching

addpath(genpath(fullfile(fileparts(mfilename('fullpath')), 'src')));

img = imread(imgPath);
if nargin < 2
    ref = img;
else
    ref = imread(refPath);
end

presets = {
    IntensityTransformation('gamma', 1.0)
    HistogramEqualization()
    HistogramMatching(ref)
    SpatialFilter('linear')
};

figure('Name', 'Enhancement Presets');
subplot(1, numel(presets) + 1, 1);
imshow(img);
title('Input');

for i = 1:numel(presets)
    subplot(1, numel(presets) + 1, i + 1);
    imshow(presets{i}.apply(img));
    title(presets{i}.Name);
end
end
