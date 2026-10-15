# FutoThemeStudio (General Theme Studio)

Flutter/Dart Android app for creating, previewing, importing, and exporting advanced FUTO Keyboard themes.

## Current project contents

- Arabic/English keyboard preview with live theme colors, shapes, and selected font family.
- Apply-target chooser for all keys, writing keys, top/bottom rows, functional keys, individual common keys, custom selectors, and background targets.
- 50 bundled illustrated wallpaper images plus gradient/solid backgrounds.
- Import a background from the device, browse real Picsum image results, or download from a direct image URL.
- Bundled fonts that actually exist in `assets/fonts/` (DejaVu Sans, DejaVu Sans Mono, FreeSans, FreeSerif), with local font import and an online Google Fonts catalog when reachable.
- Theme library persistence and auto-save.
- ZIP export with generated key assets, `theme.txt`, a PNG background, and selected font bytes when available.
- ZIP import reads nested `[options.font]` and `[options.background]` sections and extracts included background/font files for later editing.
- GitHub Actions workflow to generate the Android project and build an installable release APK artifact.

## Build from GitHub on a phone

1. Upload/push the contents of this repository to GitHub.
2. Open **Actions** and run **Build General Theme Studio APK**, or push to `main`/`master`.
3. Open the completed workflow run and download the `general-theme-studio-apk` artifact.

The workflow produces an installable APK artifact for device testing. It is not configured with your private Google Play release key; publishing to Google Play requires configuring your own release keystore and signing secrets.

## FUTO compatibility note

The exporter follows the documented advanced-theme structure, including `# Format version: 1.0`, `[options.font]`, and `[options.background]`. Advanced themes require FUTO Keyboard v0.1.30 or later according to the official documentation. Always import-test exported ZIPs in the target FUTO Keyboard version before distributing them; this repository has not yet been validated against every FUTO release or every possible TOML asset rule.

## Network notes

Online browsing/download features require internet access. Bundled backgrounds and bundled fonts work offline. The online font catalog can fall back to the bundled list if its remote catalog is unreachable. Downloaded font files must be TTF/OTF for Flutter preview support.

## License

The application source is MIT. Bundled font licenses/attributions are documented in `assets/fonts/LICENSES.txt`. Wallpaper assets are generated for this project.
