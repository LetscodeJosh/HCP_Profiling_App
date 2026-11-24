# HCP Profiling App — Release Notes (v.1.1.0)

**Release Date:** November 24, 2026  
**Version:** v.1.1.0 (Build 2 / `1.1.0+2`)  
**Target Environment:** Staging UAT (`https://staging.pmii-marketing.com`)  
**Android Package Name (`applicationId` / `namespace`):** `com.pims.hcpnexus`  
**Android SDK:** `minSdk = 24`, `targetSdk = 36`, `compileSdk = 36`

## Binary Packages
- **Play Store Unsigned AAB (for Upload Keystore Signing):** [`pims-hcpnexus-rel-1.1.0_unsigned.aab`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/legacy_versions/v.1.1.0/pims-hcpnexus-rel-1.1.0_unsigned.aab) (`59,526,461` bytes, SHA-256: `9a3b33f3260d92481f84e2a4ef6bd1351230e3591f80daaca139f29e004b39aa`)
- **Play Store Release Folder Copy:** [`pims-hcpnexus-rel-1.1.0_unsigned.aab`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/PlayStore_Release_v1.1.0/pims-hcpnexus-rel-1.1.0_unsigned.aab)
- **Root AAB Copy (Unsigned):** [`HCP_Profiling_Release.aab`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/HCP_Profiling_Release.aab)
- **Staging Release APK:** [`HCP_Profiling_V.1.1.0.apk`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/legacy_versions/v.1.1.0/HCP_Profiling_V.1.1.0.apk) (`61,830,525` bytes, SHA-256: `4d1eee2382f805f1739cd53843215931dc8da3a366a1c525d7a0f5db4a46c8e5`)
- **Root Release APK Copy:** [`HCP_Profiling_Release.apk`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/HCP_Profiling_Release.apk)
- **Territory Setup EXE:** [`Territory_Reconfiguration_Setup.exe`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/legacy_versions/v.1.1.0/Territory_Reconfiguration_Setup.exe)
- **Territory Setup ZIP:** [`Territory_Reconfiguration_Setup.zip`](file:///Users/devjptan/Downloads/HCP_Test_Repo/releases/legacy_versions/v.1.1.0/Territory_Reconfiguration_Setup.zip)

## Highlights
- Compiled cleanly against `AppConfig.environment = Environment.staging` (`https://staging.pmii-marketing.com`) for UAT-Staging profiling testing, while retaining `v.1.0.0` untouched on `dev`.
- Configured Android build for `com.pims.hcpnexus` with `versionCode = 2`, `versionName = 1.1.0`, `minSdk = 24`, `targetSdk = 36`, and `compileSdk = 36`.
- Debug `META-INF` signature files (`ANDROIDD.SF`, `ANDROIDD.RSA`, `MANIFEST.MF`) stripped from all unsigned `.aab` packages so the senior developer can sign with the Play Console upload key (`pims_hcp_upload`).
