# To-do

## Git
- [ ] Conclude the merge with `git commit` (all conflicts are resolved and staged), then push.
- [ ] Rename either `src/app/app.mlapp` or its class `app1`: MATLAB requires the file name and class name to match.
- [ ] Only one person edits `app.mlapp` at a time, because git cannot merge it (binary zip).

## GUI (`src/app/app.mlapp`)
The layout exists, but there are no callbacks yet.

### Must have (spec)
- [ ] **Add `'Median'` to the Kernel Type dropdown.** The spec requires non-linear filtering, and Kasus 4 needs it. Code: `SpatialFilter('median', windowSize)`.
- [ ] Show the input image **and** the result, each with its own histogram and stats (spec A.5). There is currently one image slot and one set of histogram tabs.
- [ ] Show the method name and parameters used: `result.MethodName`, `result.ParamsUsed`.
- [ ] Draw every histogram with `Histogram.compute`, never `imhist`/`hist` (spec B.2, B.4).
- [ ] The R/G/B tabs are for colour images. Decide what they show for a grayscale image (e.g. only the Value tab).

### Callbacks
- [ ] Load Image: `imread`, show it, fill the histograms and stats.
- [ ] Enhancement Strategy dropdown: show the matching panel, hide the others.
- [ ] Enhance: build the strategy from the panel's controls, then
      `request = EnhancementRequest; request.Image = img; result = strategy.apply(request);`
- [ ] Histogram Matching panel: Load Image sets `request.ReferenceImage` and shows it in the preview.
- [ ] Reset: go back to the loaded image.

### Mapping controls to code
| Control | Code |
|---|---|
| Method: Negative / Log Transform / Power-Law (Gamma) / Contrast Stretching | `IntensityTransformation('negative' / 'log' / 'gamma' / 'stretch')` |
| Gamma (γ) | `.Gamma` |
| c constant | `.C` (1 = full range) |
| Low / High sliders | `.InputRange = [low high]` (empty = automatic min/max) |
| Kernel Type + Kernel/Window Size + Sigma | `SpatialFilter('linear', SpatialFilter.makeKernel(type, size, sigma))` |
| Median + Window Size | `SpatialFilter('median', size)` |
| Stats table (Max, Min, Mean, Std, Entropy) | `app.UITable.Data = imageStats(img)` (one row per channel) |
| Value tab | `Histogram.compute(max(img, [], 3))` (V of HSV) |

- [ ] **Ask your partner:** what are the two range sliders "Low" and "High" meant to be? The code assumes an input range `[low high]` that is stretched to 0..255. If they meant the two control points of a piecewise stretch, the code must change.
- [ ] Mean and Box are the same kernel. Consider removing one from the dropdown.
- [ ] Enable the Sigma field only for Gaussian, and the Gamma / c fields only for their method.
- [ ] Use odd window sizes only (3, 5, 7, …).

## Interface (decide with your partner)
- [ ] `request.Params` is not used: parameters come from the strategy's properties. Either remove `Params`, or make it override the properties. Recommended: remove it.
- [ ] `HistogramMatching` accepts a reference from `request.ReferenceImage` **or** its `Reference` property. Recommended: keep only `request.ReferenceImage`.
- [ ] `EnhancementResult.Success` / `.Error` are never set. Either catch errors in the GUI's Enhance callback, or remove the fields.

## Analysis and deliverables
- [ ] For every image in Kasus 1–4, pick the method and parameters and give the reasons (spec C, E).
- [ ] Validate the histogram on the "Histogram Citra" folder in the GUI or report. It matches `imhist` exactly.
- [ ] README: name and description, dependencies (MATLAB + Image Processing Toolbox), how to run.
- [ ] Report PDF `NIM1_NIM2_Tugas1_IF4073.pdf` (see the spec's "Laporan" section).
- [ ] Add comments to `Histogram.m` explaining the function (bonus, spec A.8). It is the one the report has to explain.
- [ ] Optional: bring back automated tests (`tests/`). They were removed from the repo.

## Known limitations (for the report)
- Histogram equalization uses the textbook `s = 255 · CDF(r)`. It is a few levels brighter than `histeq`, which rounds differently.
- Equalization and matching change only the brightness (V of HSV), so colours are kept. On washed-out photos (Kasus 3 `image_03`) the result stays low in saturation. Per-channel stretch restores colour better there.
- Automatic stretch uses min/max, so salt-and-pepper noise blocks it. Use a median filter first, or set `InputRange`.
