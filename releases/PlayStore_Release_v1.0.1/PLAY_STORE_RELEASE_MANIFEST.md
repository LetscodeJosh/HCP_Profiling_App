# Google Play Store Console Release Package — `v.1.0.1` (`com.pims.hcpnexus`, Staging UAT)

> **Unsigned Bundle Ready for Signing:** [`pims-hcpnexus-rel-1.0.1_unsigned.aab`](./pims-hcpnexus-rel-1.0.1_unsigned.aab) has had debug signatures stripped (`META-INF/ANDROIDD.*` & `MANIFEST.MF`). Sign it with the Play Store upload keystore (`pims-hcp-upload-keystore.jks`, alias `pims_hcp_upload`) before uploading to Google Play Console.

---

## Verified App Bundle Identity & Staging Configuration

| Field | Configured & Verified Value |
| :--- | :--- |
| **App Display Name** | `HCP Nexus` |
| **Artifact File** | `pims-hcpnexus-rel-1.0.1_unsigned.aab` (`59,636,813` bytes) |
| **Backend Environment** | `Environment.staging` (`https://staging.pmii-marketing.com`) |
| **Package Name (`applicationId` / `namespace`)** | `com.pims.hcpnexus` |
| **Version Code (`versionCode`)** | `2` |
| **Version Name (`versionName`)** | `1.0.1` (`v.1.0.1+2`) |
| **Minimum SDK (`minSdk`)** | `24` (Android 7.0 Nougat) |
| **Target SDK (`targetSdk`)** | `36` (Android 16) |
| **Compile SDK (`compileSdk`)** | `36` |
| **Unsigned AAB SHA-256** | `6e9ebac6b9957b7ae9233c048725e7ccae3c84fb16908cbe6787058afa3d4c1e` |
| **Companion Staging APK** | [`../HCP_Profiling_Release.apk`](../HCP_Profiling_Release.apk) (`61,909,400` bytes, SHA-256 `a0513012454082dbe40abf3354abaa25037265dca3651ac3a679382be6124021`) |

---

## Senior Dev Signing Command (Upload Keystore)

Copy `pims-hcpnexus-rel-1.0.1_unsigned.aab` to a signed `.aab` (`pims-hcpnexus-rel-1.0.1.aab`) and run `jarsigner`:

```bash
cp pims-hcpnexus-rel-1.0.1_unsigned.aab pims-hcpnexus-rel-1.0.1.aab
jarsigner -verbose \
  -sigalg SHA256withRSA \
  -digestalg SHA-256 \
  -keystore /path/to/pims-hcp-upload-keystore.jks \
  pims-hcpnexus-rel-1.0.1.aab \
  pims_hcp_upload
jarsigner -verify -verbose -certs pims-hcpnexus-rel-1.0.1.aab
```

Or rebuild signed directly on `staging` with environment variables exported (`KEYSTORE_PATH`, `KEYSTORE_PASSWORD`, `KEY_ALIAS=pims_hcp_upload`, `KEY_PASSWORD`) or `android/key.properties` configured (`flutter build appbundle --release --android-skip-build-dependency-validation`).
