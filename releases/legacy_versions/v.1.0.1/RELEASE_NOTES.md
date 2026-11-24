# HCP Nexus — Release Notes (v.1.0.1)

**Release Date:** November 24, 2026  
**Version:** v.1.0.1 (Build 2 / `1.0.1+2`)  
**App Name:** `HCP Nexus`  
**Target Environment:** Staging UAT (`https://staging.pmii-marketing.com`)  
**Android Package Name (`applicationId` / `namespace`):** `com.pims.hcpnexus`  
**Android SDK:** `minSdk = 24`, `targetSdk = 36`, `compileSdk = 36`

## Binary Packages
- **Play Store Unsigned AAB (for Upload Keystore Signing):** [`pims-hcpnexus-rel-1.0.1_unsigned.aab`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/legacy_versions/v.1.0.1/pims-hcpnexus-rel-1.0.1_unsigned.aab) (`59,636,813` bytes, SHA-256: `6e9ebac6b9957b7ae9233c048725e7ccae3c84fb16908cbe6787058afa3d4c1e`)
- **Play Store Release Folder Copy:** [`pims-hcpnexus-rel-1.0.1_unsigned.aab`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/PlayStore_Release_v1.0.1/pims-hcpnexus-rel-1.0.1_unsigned.aab)
- **Root AAB Copy (Unsigned):** [`HCP_Profiling_Release.aab`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/HCP_Profiling_Release.aab)
- **Staging Release APK:** [`HCP_Profiling_V.1.0.1.apk`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/legacy_versions/v.1.0.1/HCP_Profiling_V.1.0.1.apk) (`61,909,400` bytes, SHA-256: `a0513012454082dbe40abf3354abaa25037265dca3651ac3a679382be6124021`)
- **Root Release APK Copy:** [`HCP_Profiling_Release.apk`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/HCP_Profiling_Release.apk)
- **Territory Setup EXE:** [`Territory_Reconfiguration_Setup.exe`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/legacy_versions/v.1.0.1/Territory_Reconfiguration_Setup.exe)
- **Territory Setup ZIP:** [`Territory_Reconfiguration_Setup.zip`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/legacy_versions/v.1.0.1/Territory_Reconfiguration_Setup.zip)

## Highlights
- **Play Store Console Alignment (`1.0.1` / `versionCode = 2`)**: Built strictly against `Environment.staging` (`https://staging.pmii-marketing.com`), retaining `v.1.0.0` untouched on `origin/dev`.
- **High-Definition `HCP Nexus` Official Icon & Branding**: Remastered full-bleed `1024x1024` alpha-free `HN+` logo across Android mipmaps, iOS AppIcons, Flutter assets, Windows `.ico`, and Territory Reconfiguration Web App headers/favicons, with unified `HCP Nexus` application labels and headers.
- **Indexed Search & Web-App Pagination (`20 / 40 / 80 / 100`)**: Added `PaginatedFooterBar` (`Prev`, page indicator, `Next`, range summary, and `20 | 40 | 80 | 100` segmented selector) backed by pre-lowercased search indices and memoized filtering/sorting across HCP Masterlist, HCP Account, and Institution Directory.
