# Release Notes - v.0.8.1 (Build 52)

**Release Date:** November 12, 2026

## Highlights
- **Bi-Directional SFE Institution Approval Synchronization & Lockscreen Alerts**:
  - **Descending Comment Fetch (`order_by=creation desc`)**: Fixed comment truncation bug where Frappe returned only the oldest 1,000 comments, causing newly rejected institutions to be clipped; comments are now fetched in descending order and sorted chronologically so SFE reviews always take precedence.
  - **Bi-Directional Cache Reconciliation**: Linked `HcpAccount`, `Doctor`, and `HcpProfileSubmission` records with `[REJECTED INSTITUTION: ...]` tags automatically reconcile and update local `Institution` records to `Rejected` status.
  - **Lockscreen & Heads-Up Alerts**: `NotificationService.checkAndNotifyPendingRejections` reliably triggers Android lockscreen and heads-up notifications with custom red theme, facility name, and rejection reason.
  - **Prominent UI Rejection Badges**: Added rejection notices to `InstitutionDirectoryScreen` rows and guaranteed full MedRep visibility on `InstitutionApprovalsScreen`.

