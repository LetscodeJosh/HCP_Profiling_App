# Google Play Store Console Release Package — `v1.1.0` (`com.pims.hcpnexus`, Staging UAT)

> **Unsigned Bundle Ready for Signing:** [`pims-hcpnexus-rel-1.1.0_unsigned.aab`](./pims-hcpnexus-rel-1.1.0_unsigned.aab) has had debug signatures stripped (`META-INF/ANDROIDD.*` & `MANIFEST.MF`). Sign it with the Play Store upload keystore (`pims-hcp-upload-keystore.jks`, alias `pims_hcp_upload`) before uploading to Google Play Console.

---

## Verified App Bundle Identity & Staging Configuration

| Field | Configured & Verified Value |
| :--- | :--- |
| **Artifact File** | `pims-hcpnexus-rel-1.1.0_unsigned.aab` (`59,526,461` bytes) |
| **Backend Environment** | `Environment.staging` (`https://staging.pmii-marketing.com`) |
| **Package Name (`applicationId` / `namespace`)** | `com.pims.hcpnexus` |
| **Version Code (`versionCode`)** | `2` |
| **Version Name (`versionName`)** | `1.1.0` (`v.1.1.0+2`) |
| **Minimum SDK (`minSdk`)** | `24` (Android 7.0 Nougat) |
| **Target SDK (`targetSdk`)** | `36` (Android 16) |
| **Compile SDK (`compileSdk`)** | `36` |
| **Unsigned AAB SHA-256** | `9a3b33f3260d92481f84e2a4ef6bd1351230e3591f80daaca139f29e004b39aa` |
| **Companion Staging APK** | [`../HCP_Profiling_Release.apk`](../HCP_Profiling_Release.apk) (`61,830,525` bytes, SHA-256 `4d1eee2382f805f1739cd53843215931dc8da3a366a1c525d7a0f5db4a46c8e5`) |

---

## Senior Dev Signing Command (Upload Keystore)

Copy `pims-hcpnexus-rel-1.1.0_unsigned.aab` to a signed `.aab` (`pims-hcpnexus-rel-1.1.0.aab`) and run `jarsigner`:

```bash
cp pims-hcpnexus-rel-1.1.0_unsigned.aab pims-hcpnexus-rel-1.1.0.aab
jarsigner -verbose \
  -sigalg SHA256withRSA \
  -digestalg SHA-256 \
  -keystore /path/to/pims-hcp-upload-keystore.jks \
  pims-hcpnexus-rel-1.1.0.aab \
  pims_hcp_upload
jarsigner -verify -verbose -certs pims-hcpnexus-rel-1.1.0.aab
```

Or rebuild signed directly on `staging` with environment variables exported (`KEYSTORE_PATH`, `KEYSTORE_PASSWORD`, `KEY_ALIAS=pims_hcp_upload`, `KEY_PASSWORD`) or `android/key.properties` configured (`flutter build appbundle --release`).
