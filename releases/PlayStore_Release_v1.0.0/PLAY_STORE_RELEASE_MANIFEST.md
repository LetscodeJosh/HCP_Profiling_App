# Google Play Store Console Release Package — `v1.0.0` (`com.pims.hcpnexus`)

> **Upload File:** Upload **only** [`pims-hcpnexus-rel-1.0.0.aab`](./pims-hcpnexus-rel-1.0.0.aab) to Google Play Console (`Production` or `Internal Testing` -> `Create new release` -> `App bundles`).
> **Do NOT upload** `upload_keystore/` or share `KEYSTORE_CREDENTIALS.txt` anywhere public.

---

## Verified App Bundle Identity & SDK Compliance

| Google Play Console Field | Configured & Verified Value |
| :--- | :--- |
| **Artifact File** | `pims-hcpnexus-rel-1.0.0.aab` (`59,084,214` bytes / `56.35 MiB`) |
| **Package Name (`applicationId` / `namespace`)** | `com.pims.hcpnexus` |
| **Version Code (`versionCode`)** | `1` |
| **Version Name (`versionName`)** | `1.0.0` |
| **Minimum SDK (`minSdk`)** | `23` (Android 6.0 Marshmallow) |
| **Target SDK (`targetSdk`)** | `36` (Android 16 — meets Play Console API 36 requirement) |
| **Compile SDK (`compileSdk`)** | `36` |
| **AAB SHA-256** | `F821AF2D5390EA3FDA2DE2EA2EFAB01EAC8E64B6C64F834AA465DF86B349F1FC` |
| **Companion Release APK** | [`../HCP_Profiling_Release.apk`](../HCP_Profiling_Release.apk) (`61,083,127` bytes / `58.25 MiB`, SHA-256 `117D0B2B3BA84E88618321CDE9523D2D66EA0ADAB4F02901EA9D7C1BA8CEB510`) |

---

## Play App Signing / Upload Key Certificate

- **Keystore Format:** PKCS12 (`RSA 2048-bit`, `SHA256withRSA`)
- **Key Alias:** `pims_hcp_upload`
- **Owner DN:** `CN=PIMS HCP Profiling, OU=IT Engineering, O=Professional Insights Marketing Services, L=Makati, ST=Metro Manila, C=PH`
- **SHA-1:** `08:AB:52:68:6E:B0:0D:F8:BD:28:06:09:F1:F3:CF:50:6C:E2:70:D2`
- **SHA-256:** `E2:0F:7C:66:12:74:96:89:4F:8E:7F:07:5B:F1:67:22:4E:A3:06:40:5F:1F:D2:8D:B8:D0:33:08:C3:A1:39:27`

> Keep `upload_keystore/` backed up securely outside the workstation (and in your team password manager). Never overwrite `pims-hcp-upload-keystore.jks`, as Google Play requires every future app update (`versionCode >= 2`) to be signed with the same upload key.

---

## Pre-Upload Checklist

1. **Archive Structure:** Exact 4 top-level AAB entries (`base`, `BUNDLE-METADATA`, `META-INF`, `BundleConfig.pb`).
2. **Native Debug Symbols:** Stripped from all 12 ELF `.so` files and bundled cleanly as 9 `.sym` files across `arm64-v8a`, `armeabi-v7a`, and `x86_64` in `BUNDLE-METADATA/com.android.tools.build.debugsymbols/`.
3. **16 KB Memory Page Alignment:** Native `arm64-v8a` shared libraries verified at `>= 16 KB` (`16384` / `65536` bytes) alignment.
4. **Release Build Flags:** Non-debuggable manifest (`debuggable` absent) and `com.pims.hcpnexus.MainActivity` launchable activity verified via `aapt2` and AAB protobuf manifest inspection.
5. **Upload Steps in Google Play Console:**
   - Sign in to Play Console -> Select / create app (`com.pims.hcpnexus`).
   - Accept **Play App Signing** when prompted on your first upload (`v1.0.0`, `versionCode = 1`).
   - Drag and drop `pims-hcpnexus-rel-1.0.0.aab` into the release bundle uploader.
   - Enter release notes and submit App Content declarations (Data Safety, Privacy Policy URL, Permissions justification for Camera / Location / Biometric / Notifications).
