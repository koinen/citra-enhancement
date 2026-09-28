function main(imgPath, refPath)
% MAIN  Apply every enhancement preset to one image and show the results.
%   main('data/2. Kasus 1/image_01.png')
%   main('data/2. Kasus 1/image_01.png', 'data/5. Kasus 4/image_01.png')   % reference for matching

addpath(genpath(fullfile(fileparts(mfilename('fullpath')), 'src')));

request = EnhancementRequest;
request.Image = imread(imgPath);
if nargin < 2
    request.ReferenceImage = request.Image;
else
    request.ReferenceImage = imread(refPath);
end

presets = {
    IntensityTransformation('gamma', 1.0)
    HistogramEqualization()
    HistogramMatching()
    SpatialFilter('linear')
};

figure('Name', 'Enhancement Presets');
subplot(1, numel(presets) + 1, 1);
imshow(request.Image);
title('Input');

for i = 1:numel(presets)
    result = presets{i}.apply(request);
    subplot(1, numel(presets) + 1, i + 1);
    imshow(result.Image);
    title(result.MethodName);
end
end
