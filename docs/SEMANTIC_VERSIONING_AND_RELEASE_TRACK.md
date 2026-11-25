# Semantic Versioning & Staging-to-Production Release Track

> **Environment Scope:** `Environment.staging` (`https://staging.pmii-marketing.com`) — Pre-Production UAT Track  
> **Standard:** [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) (`MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]`)

This document is the single source of truth for pre-production semantic versioning across **HCP Nexus** (Android & iOS) and **Territory Reconfig** (Territory Reconfiguration Web & Desktop Portal) while operating in the **Staging** environment ahead of **Production** (`https://hris.pmii-marketing.com`) cutover.

---

## 1. Active Staging Release Track Matrix

| Product / Module | Staging SemVer Track | Matched Store / Portal Version | Target Backend | Retained Repository Baseline |
| :--- | :--- | :--- | :--- | :--- |
| **HCP Nexus** (`com.pims.hcpnexus` — Play Store `.aab` & TestFlight `.ipa`) | **`1.0.1-alpha`** | Marketing Version: `1.0.1` · Build: `2` (`1.0.1+2`) | `Environment.staging` (`staging.pmii-marketing.com`) | `VERSION`: `v.1.0.0` · `pubspec.yaml`: `1.0.0+1` · `AppVersion`: `v.1.0.0` |
| **Territory Reconfig** (Territory Reconfiguration Portal — Web & Desktop Suite) | **`1.0.0-alpha`** | Portal Suite Parity Track: `1.0.0-alpha` | `staging.pmii-marketing.com` | `installers/Streamlit_Deployment/VERSION`: `v.0.1.3` |

> **Baseline Retention Policy:** Existing repository version files (`VERSION`, `pubspec.yaml`, `lib/constants/app_version.dart`, and `installers/Streamlit_Deployment/VERSION`) are intentionally retained at their current active UAT baselines so automated architectural parity checks (`audit_tech_debt.py`) and deployed UAT artifacts remain unbroken.

---

## 2. HCP Nexus (`1.0.1-alpha`) — Matched Play Store & TestFlight Versioning

Both **Google Play Console** and **Apple TestFlight** must stay synchronized on the same **HCP Nexus** release version (`1.0.1-alpha`) when distributing staging UAT builds:

### A. Store Binary Compatibility Rules

1. **Google Play Console (`.aab`)**:
   - **Signing Requirement:** **Must be signed with `.jks`** (`pims-hcp-upload-keystore.jks`, alias `pims_hcp_upload`, certificate `SHA-1: 08:AB:52:68:6E:B0:0D:F8:BD:28:06:09:F1:F3:CF:50:6C:E2:70:D2`). Unsigned or debug-signed bundles are rejected by Play Console.
   - **Current Signed Staging Bundle:** `releases/PlayStore_Release_v1.0.1/pims-hcpnexus-rel-1.0.1.aab` (`versionName = 1.0.1`, `versionCode = 2`).
   - **Play Console Release Name:** Set the Play Console release name to **`1.0.1-alpha`** on the Internal/Closed Testing track so testers see the exact semantic track.

2. **Apple TestFlight / App Store Connect (`.ipa`)**:
   - **Signing Requirement:** Does **NOT** use `.jks`. Uses **Xcode Automatic Signing** (`ios/Runner.xcworkspace`, paid Apple Developer Program **Apple Distribution Certificate** + **App Store Provisioning Profile** for `com.pims.hcpnexus`).
   - **Apple Store Numeric Constraint:** App Store Connect requires `CFBundleShortVersionString` (`FLUTTER_BUILD_NAME`) to contain only dot-separated integers (`MAJOR.MINOR.PATCH`) and rejects `-alpha` inside `Info.plist`.
   - **Matched Configuration:** Archive and upload with numeric version **`1.0.1`** and build **`2`** (`--build-name=1.0.1 --build-number=2`), and label the TestFlight *What to Test* notes / Git release tag **`1.0.1-alpha`** so Android Play Store and iOS TestFlight stay 1:1 aligned.

### B. Matched Build Commands (`1.0.1-alpha` / Build `2`)

```bash
# 1. Google Play Console signed .aab (uses android/key.properties + .jks)
flutter build appbundle --release \
  --android-skip-build-dependency-validation \
  --build-name=1.0.1 \
  --build-number=2

# 2. Verify Play Store .aab signature matches v.1.0.0 upload key
jarsigner -verify releases/PlayStore_Release_v1.0.1/pims-hcpnexus-rel-1.0.1.aab
keytool -printcert -jarfile releases/PlayStore_Release_v1.0.1/pims-hcpnexus-rel-1.0.1.aab | grep SHA1

# 3. Sync Apple TestFlight xcconfig to match Play Store 1.0.1 (Build 2)
flutter build ios --config-only --release --no-codesign \
  --build-name=1.0.1 \
  --build-number=2
open -a Xcode ios/Runner.xcworkspace
# In Xcode: Any iOS Device (arm64) -> Product -> Archive -> Distribute App -> TestFlight & App Store
```

---

## 3. Territory Reconfig (`1.0.0-alpha`) — Portal Parity & Release Standard

- **Semantic Track:** **`1.0.0-alpha`** for Staging pre-production validation of the Territory Reconfiguration Portal (Streamlit Cloud deployment + Windows Desktop Installer Suite).
- **Retained Portal Version Token:** `installers/Streamlit_Deployment/VERSION` (`v.0.1.3`) and `#headerPortalVersionBadge` are retained cleanly alongside this governance spec.
- **Zero-Drift Parity Requirement:** Whenever Territory Reconfig assets are updated on any staging or production promotion, all **6 copies** of `territory_reconfiguration_portal.html` must remain byte-for-byte SHA-256 identical:
  1. `docs/territory_reconfiguration_portal.html`
  2. `assets/web/territory_reconfiguration_portal.html`
  3. `installers/Territory_Reconfiguration_App/territory_reconfiguration_portal.html`
  4. `installers/Streamlit_Deployment/territory_reconfiguration_portal.html`
  5. `installers/Streamlit_Deployment/index.html`
  6. `releases/legacy_versions/<VERSION>/Territory_Reconfiguration_Setup/territory_reconfiguration_portal.html`
- **Authentication Invariance:** `handlePortalLogin`, `applyAuthenticatedUser`, `checkAuthSession`, `showLoginView`, `streamlit:render` auth message handling, and `verify_erpnext_credentials` must remain untouched across all releases.

---

## 4. SemVer 2.0.0 Lifecycle (Dev → Staging → Production)

| Stage / Branch | Environment | SemVer Format | HCP Nexus Example | Territory Reconfig Example | Store Build Numbers (`versionCode` / `CFBundleVersion`) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Development (`dev`)** | `Environment.development` (`dev.pmii-marketing.com`) | `MAJOR.MINOR.PATCH-dev.N` | `1.0.1-dev.1` | `1.0.0-dev.1` | Local test builds only |
| **Staging UAT (`staging`)** | `Environment.staging` (`staging.pmii-marketing.com`) | `MAJOR.MINOR.PATCH-alpha[.N]` → `-beta.N` → `-rc.N` | **`1.0.1-alpha`** (store binary: `1.0.1+2`) | **`1.0.0-alpha`** | Strictly monotonic (`2`, `3`, `4`, …) matched across Play Store & TestFlight |
| **Production GA (`prod` / `main`)** | `Environment.production` (`hris.pmii-marketing.com`) | `MAJOR.MINOR.PATCH` *(drop pre-release suffix)* | `1.0.1` *(or `1.1.0`)* | `1.0.0` *(or `1.1.0`)* | Must stay higher than prior TestFlight/Play Console builds (`+3+`) |

### SemVer Increment Rules
- **`MAJOR` (`X.0.0`):** Breaking workflow/API contract changes, package/bundle ID changes, or architectural overhauls.
- **`MINOR` (`0.Y.0`):** Backwards-compatible new features or workflow modules (e.g., new ERPNext DocType flows, new portal capabilities).
- **`PATCH` (`0.0.Z`):** Bug fixes, UI polish, pagination/layout fixes, and resilience hardening.
- **Pre-release Identifiers (`-alpha`, `-beta`, `-rc`):** Only used before Production GA promotion (`alpha` = early staging integration & UAT; `beta` = feature-complete staging UAT; `rc` = release candidate sign-off).

---

## 5. Platform Signing & Credential Isolation Summary

| Target Platform | Signing Mechanism | Keystore / Certificate Location | Git Status |
| :--- | :--- | :--- | :--- |
| **Android Play Console (`.aab`)** | Upload Keystore (`pims-hcp-upload-keystore.jks`, alias `pims_hcp_upload`) | `releases/PlayStore_Release_v1.0.0/upload_keystore/` & `android/key.properties` | **Strictly gitignored** (`.gitignore`) |
| **Apple TestFlight / App Store (`.ipa`)** | Automatic Xcode Signing (`DEVELOPMENT_TEAM` + App Store Distribution Profile, **no `.jks`**) | macOS Keychain + Apple Developer Account in Xcode | Never stored in Git |
| **Territory Reconfig Web Portal** | Dual Auth Engine (Live ERPNext + Local Session Failover Token) | Runtime session / Streamlit secrets | Secrets strictly gitignored |

---

## 6. Pre-Production Cutover Gate Checklist

Before promoting from **Staging (`-alpha` / `-beta` / `-rc`)** to **Production (`X.Y.Z`)**:
1. Switch `AppConfig.environment` in `lib/app_config.dart` intentionally for Production only on the production release branch (`Environment.production`), keeping `staging` isolated.
2. Increment build numbers monotonically across both stores (`--build-name=X.Y.Z --build-number=N`), matching Android Play Console and Apple TestFlight 1:1.
3. Verify Play Store `.aab` passes `jarsigner -verify` and matches upload key `SHA-1: 08:AB:52:68:6E:B0:0D:F8:BD:28:06:09:F1:F3:CF:50:6C:E2:70:D2`.
4. Verify TestFlight `.ipa` archives cleanly from `ios/Runner.xcworkspace` with paid Apple Developer Distribution signing.
5. Pass `flutter analyze --no-fatal-infos` (0 errors, 0 warnings), `flutter test --no-pub`, and `python3 .github/scripts/audit_tech_debt.py` (**Grade A+ — 5/5 invariants**).
6. Ensure CI/CD GitHub Actions passes (`SUCCESS`) across all workflows before tagging the production release.
