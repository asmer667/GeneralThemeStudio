# Implementation status — FutoThemeStudio

This is the first source-code implementation pass based on the uploaded `GeneralThemeStudio.zip` and the new requirements.

## Implemented in this pass

- Corrected FUTO TOML color conversion between `RRGGBBAA` and Flutter's internal `AARRGGBB` representation.
- Updated export structure to use the documented `[options.font]` and `[options.background]` tables and to export a real `background.png` for solid/gradient/image backgrounds.
- Added handling of nested options tables and extraction of background/font files during theme ZIP import.
- Added 50 unique bundled wallpaper images with actual previews and export support.
- Replaced missing bundled-font catalog entries with four real bundled font files that support Arabic and Latin glyphs.
- Connected font selection to preview and export; corrected Google Fonts catalog parsing and removed fabricated fallback download URLs.
- Added direct image-URL downloads and validation that downloaded files decode as images.
- Improved apply-target behavior for row selectors, individual key selectors, custom selectors, gradients, shapes, and key-background image textures.
- Marked project edits as unsaved when replacing the active project after applying a choice.
- Added an Android GitHub Actions workflow step for the Internet permission required by online browsing/downloading.

## Not yet complete or verified

- The existing shape renderer currently exposes **327 shape enum entries**, not 527 or 5,000. More distinct shape families and custom SVG/image shape workflows still need to be added and tested; duplicates should not be used to inflate the count.
- Four bundled fonts are present now, not 20 or 40. Online font browsing is intended to expand the catalog when the network is available.
- A persistent bottom-navigation shell across every screen still needs implementation.
- No Flutter SDK is installed in the editing workspace, so `flutter pub get`, `flutter analyze`, APK compilation, device testing, and import-testing in a real FUTO Keyboard installation have not been run here.
- FUTO advanced themes require FUTO Keyboard v0.1.30 or later according to the official docs; every exported asset/match-rule combination still needs runtime validation in the target FUTO version.

Do not treat this status as a claim that the entire product specification is complete. It records the actual state of this iteration.
