# What changed in app.mlapp

- **Chaining:** each Enhance now works on the previous result, not the original image. Analyze starts over from the loaded image.
- **One result window for all 4 panels:** Equalization, Matching and Filtering used to call a bare `imshow`. The window title shows the chain (e.g. `Median 3 > Gamma 1.2`). It has two buttons:
  - **Save Image** saves the result at full resolution.
  - **Start Over** goes back to the loaded image.
- **Grayscale fix:** Analyze no longer fails with `Unrecognized field name "red"` on 1-channel images. The Value tab is shown and the R/G/B tabs stay empty.

## In the code (private functions section)

- `applyStep(app, preset, request, stepName)`: new Enhance buttons should end with this. Don't call `imshow` directly.
- `showResult`, `saveResult`, `startOver`: the result window and its buttons.
- New properties: `CurrentImage`, `Steps`, `ResultFigure`.

No components were added in the designer. Pull before you edit `app.mlapp`, because git can't merge it.
