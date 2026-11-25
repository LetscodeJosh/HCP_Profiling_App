# Google Play Store Console Release Package — `1.0.1-alpha` (`com.pims.hcpnexus`, Staging UAT)

> **Signed & Verified Bundle Ready for Play Store Upload:** [`pims-hcpnexus-rel-1.0.1-alpha.aab`](./pims-hcpnexus-rel-1.0.1-alpha.aab) is built from the `v.1.0.1-alpha` Staging UAT release (with full bi-directional 5-card Institution Submission `PIMS_META` sync) and signed with the production Play Store upload keystore (`pims-hcp-upload-keystore.jks`, alias `pims_hcp_upload`, matching `v.1.0.0`).

---

## Verified App Bundle Identity & Staging Configuration

| Field | Configured & Verified Value |
| :--- | :--- |
| **App Display Name** | `HCP Nexus` |
| **Artifact File** | [`pims-hcpnexus-rel-1.0.1-alpha.aab`](./pims-hcpnexus-rel-1.0.1-alpha.aab) (`59,892,849` bytes) |
| **Backend Environment** | `Environment.staging` (`https://staging.pmii-marketing.com`) |
| **Package Name (`applicationId` / `namespace`)** | `com.pims.hcpnexus` |
| **Version Code (`versionCode`)** | `2` |
| **Version Name (`versionName`)** | `1.0.1-alpha` |
| **Minimum SDK (`minSdk`)** | `24` (Android 7.0 Nougat) |
| **Target SDK (`targetSdk`)** | `36` (Android 16) |
| **Signed AAB SHA-256** | `c54d810e84cc83869dd49343f6794d356b5559435a915b924b7682db6950b2bd` |
| **Upload Key Alias / SHA-1** | `pims_hcp_upload` (`08:AB:52:68:6E:B0:0D:F8:BD:28:06:09:F1:F3:CF:50:6C:E2:70:D2`) |
| **Upload Key SHA-256** | `E2:0F:7C:66:12:74:96:89:4F:8E:7F:07:5B:F1:67:22:4E:A3:06:40:5F:1F:D2:8D:B8:D0:33:08:C3:A1:39:27` |
| **Companion Staging APK** | `releases/legacy_versions/v.1.0.1-alpha/HCP_Profiling_V.1.0.1-alpha.apk` (`62,139,036` bytes, SHA-256 `4d086d510676d4fe325bcb442e6db5f4b7c0359189a9e655eed18d34ade801aa`) |

---

## Companion Apple TestFlight Note (`1.0.1-alpha` Track, Without `.jks`)

- **No `.jks` Required:** Apple TestFlight (`.ipa`) uses **Xcode Automatic Signing** in `ios/Runner.xcworkspace` with your paid Apple Developer Program account (**no `.jks`**).
- **Matched Store Version:** Because App Store Connect enforces numeric-only `CFBundleShortVersionString` (`MAJOR.MINOR.PATCH`), archive TestFlight with numeric **`1.0.1`** and Build **`2`** (`FLUTTER_BUILD_NAME=1.0.1`, `FLUTTER_BUILD_NUMBER=2` synced in `ios/Flutter/Generated.xcconfig`) and tag TestFlight release notes as **`1.0.1-alpha`**.

---

## Highlights Included in This `v.1.0.1-alpha` Build

- Bi-directional real-time ERPNext `PIMS_META` synchronization & 15s background polling across all 5 Institution Submission cards (`All`, `Pending Approval`, `Pending DSM Approval`, `Approved`, `Rejected`) for MedRep proposals, resubmissions, SFE normalization/approvals, DSM endorsements, rejections, and remaps.
- Step 2 `show_hcp_form: 1` serialization and removal of restricted `rejection_reason` REST list field query.
- Step 3 `HCP Survey Template` multi-tier fetch + cache-aside (`fields=["*"]`), `Select`/`Multi-select`/`Data` inputs, program auto-population, and automatic redirect to `Changes` when no questionnaire exists.
- Removal of fallback stock doctor image (`pngimg.com`) when no portrait photo exists; centered 5 workflow tabs in HCP Profile Submission popup; Web-App-style 5 colored card-tabs with clean inline `Audit Log` / `Edit` actions on Institution Submission.
