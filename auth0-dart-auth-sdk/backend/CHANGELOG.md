# 0.0.4

### Added

* Example **Authorization Code + PKCE** quickstart (Flutter & server-side) to reduce setup friction.
* Built-in **request timeouts** and **retry/backoff** for token/network calls (configurable).
* Additional inline docs and DartDoc for common flows (login, refresh, logout, user info).

### Changed

* Improved error surfaces with typed exceptions (e.g., `Auth0AuthException`, `Auth0NetworkException`) and clearer messages.
* Normalized parameter handling for `scope`, `audience`, and `redirectUri` across methods.
* Updated README with **OnePub/private registry** guidance and troubleshooting steps.

### Fixed

* `revokeToken()` now treats **HTTP 204** as success (no-content) instead of throwing.
* Fixed `logout()` occasional false negatives on slow networks.
* Safer JSON parsing for user profile fields with missing/extra properties.

### Notes

* **No breaking changes.**
* Recommended: run `dart pub upgrade` to pick up the improved networking defaults.

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
