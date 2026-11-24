# HCP Nexus App — Release Notes (v.1.0.0)

**Release Date:** November 24, 2026
**Version:** v.1.0.0 (Build 1 / `1.0.0+1`)
**Bundle ID / Package Name (`applicationId` / `namespace`):** `com.pims.hcpnexus`
**Android SDK:** `minSdk = 24`, `targetSdk = 36`, `compileSdk = 36`

## Highlights
- **Initial TestFlight iOS UAT Baseline (`v.1.0.0+1`)**: Synchronized `ios/Flutter/Generated.xcconfig` (`FLUTTER_BUILD_NAME=1.0.0`, `FLUTTER_BUILD_NUMBER=1`) alongside updated iOS `Podfile`, `Info.plist`, `AppDelegate.swift`, and `Runner.xcworkspace` project settings for Xcode Archive & TestFlight upload.
- **Full `1,328` Institution Sync**: Updated `ApiService.fetchInstitutions()` to paginate cleanly in `500`-record batches across all ERPNext `Institution` records and synchronized `HcpDashboardScreen` KPI counts.
- **Compact Static Responsive Pagination (`PaginatedFooterBar`)**: Docked pagination footer matching the web portal format (`Showing X–Y of Z`, `◀ Prev [ 1 / N ] Next ▶`, `Rows: [ 20 | 40 | 80 | 100 ]`) verified across iPad and mobile screen widths.
- **Clean Institution Submission UI & Audit Log**: Removed KPI summary cards, header/drawer subtitles, `"Active"` badge, and `"Awaiting SFE Review"` banners; centered the 5 colored-outline status tabs with top-left search spacing; restricted direct Institution Edit/Remap/Resubmit to `SFE` and `Admin`; upgraded `InstitutionAuditTrailDialog` with Facility Overview and Activity Timeline.
- **CI/CD & Parity**: Synchronized companion APK (`HCP_Profiling_V.1.0.0.apk`), Territory Reconfiguration Portal assets, and pinned CI Flutter SDK `3.47.9`.
