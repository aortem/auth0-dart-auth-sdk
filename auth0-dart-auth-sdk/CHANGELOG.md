## 0.0.3

### Changed

- Updated GitHub URL
- Normalized Dart Docs API naming convention

## 0.0.2

### Breaking

* **Rename:** all public file/module names changed from `aortem_auth0_*` → `auth0_*`.

  * If you import subpaths, replace occurrences of `aortem_auth0_` with `auth0_`.
  * Prefer importing the package entrypoint:

    ```dart
    import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
    ```

### Added

* **Example Flutter app** demonstrating:

  * Email/password & social login
  * Enterprise SAML
  * MFA (OTP/OOB/Recovery), list/add/delete authenticators
  * Token operations (get token, revoke)
  * OIDC/SAML logout, user info/profile
  * Dynamic application client registration

### Changed

* **Exports consolidated** under `auth0_*` namespace for consistency and clarity.
  (No runtime behavior changes intended.)

## 0.0.1

- Bump To Version 3.8.0 

## 0.0.1-pre

- Initial pre-release version of the Auth0 Dart Auth SDK.
