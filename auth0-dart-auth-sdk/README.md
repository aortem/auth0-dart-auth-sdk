# Auth0 Dart Auth SDK

## Overview

The **Auth0 Dart Auth SDK** provides seamless integration with Auth0’s OAuth2 and OpenID Connect endpoints for both server-side Dart applications and Flutter clients. With this SDK you can:

* Perform interactive and non-interactive authentication flows:
  * Authorization Code + PKCE  
  * Client Credentials (machine-to-machine)  
  * Resource Owner Password Credentials (ROPC)  
* Acquire, cache, and refresh access, ID, and refresh tokens  
* Securely persist tokens using a pluggable `TokenStorage` interface  
* Integrate with Auth0 Universal Login in Flutter Web  
* Call Auth0 Management and custom APIs with on-behalf-of tokens  

Whether you’re building a Dart backend, a Flutter mobile app, or a Flutter web client, this SDK handles the heavy lifting of Auth0 authentication so you can focus on your business logic.

---

## Features

* **Unified Auth Flows**  
  Support for PKCE, client credentials, and ROPC—one SDK for all your needs.
* **Token Management**  
  Automatic caching, expiration checks, and silent refresh using refresh tokens.
* **Secure Storage**  
  `TokenStorage` interface with built-in `FileTokenStorage` and `MemoryTokenStorage`; implement your own backend (Keychain, SecureStore, database).
* **Flutter Web Support**  
  Out-of-the-box integration with Auth0’s Universal Login widget; handles redirects and code exchange.
* **Management API Helpers**  
  Acquire Auth0 Management API tokens via client credentials and call common endpoints (user management, roles, permissions).
* **Extensible & Configurable**  
  Customize HTTP client, logging, timeouts, and JSON serialization.

---

## Getting Started

### Prerequisites

* Dart SDK ≥ 2.14.0 (null safety) or Flutter SDK ≥ 3.0  
* An Auth0 tenant with an Application configured:  
  * **Regular Web App** for Flutter Web / server  
  * **Native App** for Flutter mobile  
  * **Machine-to-Machine App** for service-to-service flows  

### Configure Your Auth0 Application

1. In the Auth0 Dashboard, create or select an Application.  
2. Note your **Domain**, **Client ID**, and (for confidential flows) **Client Secret**.  
3. Add allowed callback/redirect URIs, e.g.:  
   * `com.example.app://callback` (mobile)  
   * `https://localhost:8080/callback` (web)  

---

## Installation

Add the SDK to your project:

```bash
# Dart:
dart pub add auth0_dart_auth_sdk

# Flutter:
flutter pub add auth0_dart_auth_sdk
````

Or add to your `pubspec.yaml` manually:

```yaml
dependencies:
  auth0_dart_auth_sdk: ^0.0.1
```

Then fetch:

```bash
dart pub get
```

---

## Usage

### 1. Initialize the SDK

```dart
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

final auth = Auth0Auth(
  domain: 'your-tenant.auth0.com',
  clientId: 'YOUR_CLIENT_ID',
  redirectUri: Uri.parse('com.example.app://callback'),
);
```

### 2. Authorization Code + PKCE Flow

```dart
// Trigger interactive login
final result = await auth.loginWithPkce(
  audience: 'https://api.yourservice.com',
  scopes: ['openid', 'profile', 'email'],
);

print('Access Token: ${result.accessToken}');
print('ID Token Claims: ${result.idTokenClaims}');
```

### 3. Client Credentials Flow (Server)

```dart
final serverAuth = Auth0Auth.machineToMachine(
  domain: 'your-tenant.auth0.com',
  clientId: 'YOUR_M2M_CLIENT_ID',
  clientSecret: 'YOUR_CLIENT_SECRET',
);

final token = await serverAuth.clientCredentialsToken(
  audience: 'https://your-tenant.auth0.com/api/v2/',
);

print('Management API Token: ${token.accessToken}');
```

### 4. Token Storage & Silent Refresh

```dart
// Initialize built-in storage (file or memory)
await auth.initStorage();

// Later, silently get a valid token without UI:
final silent = await auth.acquireTokenSilent(
  audience: 'https://api.yourservice.com',
  scopes: ['openid', 'email'],
);

print('Refreshed Access Token: ${silent.accessToken}');
```

### 5. Management API Helper

```dart
final mgmt = Auth0ManagementClient(serverAuth);
final users = await mgmt.listUsers(page: 0, perPage: 10);
print('First user email: ${users.first.email}');
```

---

## Advanced

* **Custom TokenStorage**

  ```dart
  class SecureStorage implements TokenStorage {
    // implement read/write methods using your secure store
  }

  auth.setStorage(SecureStorage());
  ```
* **Logging & Debugging**

  ```dart
  auth.logger.level = LogLevel.debug;
  auth.logger.onLog((level, msg) => print('[$level] $msg'));
  ```
* **Custom HTTP Client**

  ```dart
  auth.httpClient = myCustomDioInstance;
  ```

---

## Documentation

For full API reference, migration guides, and examples, see our GitBook:

👉 [Auth0 Dart Auth SDK Docs](https://aortem.gitbook.io/auth0-dart-auth-sdk/)

```
