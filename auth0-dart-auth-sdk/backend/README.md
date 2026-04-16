# Auth0 Dart Auth SDK

Backend-focused Dart wrappers for Auth0 authentication, authorization, MFA, logout, metadata, and user-info endpoints.

## Features

This package exposes request/response models and service helpers for common Auth0 flows, including:

* username/password login
* token exchange via `/oauth/token`
* passwordless and request-handling flows
* MFA challenge, verify, add, list, and delete operations
* logout URL generation
* metadata and user-info retrieval
* dynamic client registration and authorization URL helpers

The public API is exported from:

```dart
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
```

## Installation

```bash
dart pub add auth0_dart_auth_sdk
```

Or in `pubspec.yaml`:

```yaml
dependencies:
  auth0_dart_auth_sdk: ^0.0.5
```

## Quick Start

### Username/password login

```dart
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

final service = Auth0LoginService(auth0Domain: 'your-tenant.auth0.com');

final response = await service.login(
  Auth0LoginRequest(
    username: 'user@example.com',
    password: 'password123',
    connection: 'Username-Password-Authentication',
    clientId: 'your-client-id',
  ),
);

print(response.accessToken);
```

### Token exchange

```dart
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

final response = await auth0GetToken(
  domain: 'your-tenant.auth0.com',
  request: Auth0GetTokenRequest(
    grantType: 'authorization_code',
    clientId: 'your-client-id',
    code: 'authorization-code',
    redirectUri: 'https://your-app.example/callback',
  ),
);

print(response.accessToken);
```

### User info

```dart
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

final profile = await auth0GetUserInfo(
  domain: 'your-tenant.auth0.com',
  request: Auth0GetUserInfoRequest(accessToken: 'access-token'),
);

print(profile.email);
```

### Logout URL

```dart
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

final logout = Auth0Logout(auth0Domain: 'your-tenant.auth0.com');
final response = logout.generateLogoutUrl(
  Auth0LogoutRequest(
    clientId: 'your-client-id',
    returnTo: 'https://your-app.example/logout-complete',
  ),
);

print(response.logoutUrl);
```

## Package Layout

The package is organized around Auth0 capability areas:

* `authentication`
* `authorization`
* `dynamic_registration`
* `logout`
* `metadata_federation`
* `multifactor`
* `request_handling`
* `sso_federation`
* `user_info`

## Verification

The backend package is currently verified with:

```bash
dart test
dart analyze lib test
```

## License

BSD-3-Clause
