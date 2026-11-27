# Google Play Store Console Release Package — `v.1.0.2-alpha` (`com.pims.hcpnexus`, Staging UAT)

> **Signed & Verified Bundle Ready for Play Store Upload:** [`pims-hcpnexus-rel-1.0.2-alpha.aab`](./pims-hcpnexus-rel-1.0.2-alpha.aab) is built from the `v.1.0.2-alpha` Staging UAT release and signed with the production Play Store upload keystore (`pims-hcp-upload-keystore.jks`, alias `pims_hcp_upload`, matching `v.1.0.0` and `v.1.0.1-alpha`).

---

## Verified App Bundle Identity & Staging Configuration

| Field | Configured & Verified Value |
| :--- | :--- |
| **App Display Name** | `HCP Nexus` |
| **Login Page Version Display** | `v.1.0.2-alpha` |
| **Artifact File** | [`pims-hcpnexus-rel-1.0.2-alpha.aab`](./pims-hcpnexus-rel-1.0.2-alpha.aab) (`60,291,304` bytes) |
| **Backend Environment** | `Environment.staging` (`https://staging.pmii-marketing.com`) |
| **Package Name (`applicationId` / `namespace`)** | `com.pims.hcpnexus` |
| **Version Code (`versionCode` / `buildNumber`)** | `3` (incremented from `v.1.0.1-alpha` build `2`) |
| **Version Name (`versionName`)** | `1.0.2` |
| **Minimum SDK (`minSdk`)** | `24` (Android 7.0 Nougat) |
| **Target SDK (`targetSdk`)** | `36` (Android 16) |
| **Signed AAB SHA-256** | `1a8acfadd97f8e8e04926cd897d85e7aebccf70a041484d0e13b35cd1d17fa8f` |
| **Upload Key Alias / SHA-1** | `pims_hcp_upload` (`08:AB:52:68:6E:B0:0D:F8:BD:28:06:09:F1:F3:CF:50:6C:E2:70:D2`) |
| **Upload Key SHA-256** | `E2:0F:7C:66:12:74:96:89:4F:8E:7F:07:5B:F1:67:22:4E:A3:06:40:5F:1F:D2:8D:B8:D0:33:08:C3:A1:39:27` |
| **Companion Staging APK** | `releases/legacy_versions/v.1.0.2-alpha/HCP_Profiling_V.1.0.2-alpha.apk` (`62,631,838` bytes, SHA-256 `15ffb010f9b6102481dc76474a4ed963011406cd87bc3134f338c3325ebef57b`) |

---

## Companion Apple TestFlight Note (`v.1.0.2-alpha` Track)

- **Matched Store Version:** `FLUTTER_BUILD_NAME=1.0.2` and `FLUTTER_BUILD_NUMBER=3` are synchronized in `ios/Flutter/Generated.xcconfig` for Xcode Archive / TestFlight upload.

---

## Highlights Included in This `v.1.0.2-alpha` Release

- **MedRep Live Institution Fetch & `INST-00001` (`417 LinkValidationError`) Resolution:** 8 progressive REST/RPC GET tiers + CSRF-authenticated `reportview.get`/`search_link` fallbacks, cross-environment disk cache purge on Staging boot, live server `_lookupLiveInstitutionId(forceServer: true)` + `417` retry recovery across `createSubmission()`, `updateSubmission()`, and `syncHcpAccount()`, and accurate total live counts on MedRep `Institution Submission`.
- **Human-Readable Error Messaging (`ApiService.formatUserFriendlyError`):** Replaces raw JSON/Python tracebacks with plain-English explanations and a clean `(Exception Error: <code>)` code across submission, approval, institution remap, and doctor forms.
- **SFE Dual-Role Admin & Hamburger Menu + `Review` Tab:** Keeps full Admin capabilities active for SFE Admins (`_hasSfeRole`) with both assigned `employeeBranch` and interactive `Switch Program` dropdown, relabels the `Changes` tab to `Review`, and fixes resubmission workflow transitions.
- **Standalone Territory Reconfiguration Web App (`server.py` + 6-Copy Portal Parity):** Targets `https://staging.pmii-marketing.com` directly without Streamlit dependency, with automatic Frappe CSRF handling, `/` territory docnames & multi-column `order_by` support, direct standalone ERPNext writebacks, and Staging `localStorage` hygiene.
