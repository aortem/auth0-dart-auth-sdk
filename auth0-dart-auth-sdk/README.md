````markdown
# Auth0 Dart Auth SDK

## Overview

The **Auth0 Dart Auth SDK** provides seamless integration with Auth0’s OAuth2 and OpenID Connect endpoints for both server‐side Dart applications and Flutter clients. With this SDK you can:

- Perform interactive and non‐interactive authentication flows (authorization code + PKCE, client credentials, ROPC)  
- Manage access, ID, and refresh tokens with automatic caching and refresh  
- Securely persist tokens using a pluggable storage backend  
- Integrate with Auth0’s Universal Login widget in Flutter Web  
- Call Auth0 Management and custom APIs with on‐behalf‐of tokens  

Whether you’re building a Dart web service, a Flutter mobile app, or a Flutter web client, this SDK handles the heavy lifting of Auth0 authentication so you can focus on your application logic.

---

## Features

- **Unified Auth Flows**  
  - Authorization Code + PKCE (recommended for Flutter & Web)  
  - Client Credentials (machine‐to‐machine)  
  - Resource Owner Password Credentials (ROPC)  

- **Token Management**  
  - Automatic caching of access, ID, and refresh tokens  
  - Expiration checks and silent refresh using refresh tokens  
  - Helper to decode and verify JWT claims  

- **Secure Storage**  
  - `TokenStorage` interface with built-in `FileTokenStorage` and `MemoryTokenStorage`  
  - Easily implement your own secure backends (Keychain, SecureStore, database)

- **Flutter Web Support**  
  - Built-in integration with Auth0’s Universal Login via `Auth0WebWidget`  
  - Handles redirect callbacks and code exchange automatically  

- **Management API Helpers**  
  - Acquire Auth0 Management API tokens using client credentials  
  - Built-in client for common endpoints: user management, roles, permissions  

- **Extensible & Configurable**  
  - Customize HTTP client, logging, timeouts, caching behavior  
  - Plug‐in your own JSON serializers or use the built-in `json_serializable` models  

---

## Getting Started

### Prerequisites

- Dart SDK ≥ 2.14.0 (null safety) or Flutter SDK ≥ 3.0  
- An Auth0 tenant with an Application (Regular Web App, SPA, or Machine‐to‐Machine App) configured  

### Configure Auth0 Application

1. In the Auth0 Dashboard, create an Application:  
   - **Regular Web App** for Flutter Web / server.  
   - **Native App** for Flutter mobile.  
   - **Machine‐to‐Machine App** for service-to-service flows.

2. Note your **Domain**, **Client ID**, and (if needed) **Client Secret**.  
3. Set allowed redirect URIs (e.g. `com.example.app://callback`, `https://localhost:8080/callback`).  

---

## Installation

Add the SDK to your project:

```bash
# Dart:
dart pub add auth0_dart_auth_sdk

# Flutter:
flutter pub add auth0_dart_auth_sdk
````

Or manually in your `pubspec.yaml`:

```yaml
dependencies:
  auth0_dart_auth_sdk: ^0.1.0
```

Then run:

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

### 2. Authorization Code + PKCE (Flutter & Web)

```dart
// Trigger interactive login
final result = await auth.loginWithPkce(
  audience: 'https://api.yourservice.com',
  scopes: ['openid', 'profile', 'email'],
);

// Access and ID tokens
print('Access Token: ${result.accessToken}');
print('ID Token Claims: ${result.idTokenClaims}');
```

### 3. Client Credentials (Server)

```dart
// Initialize for machine-to-machine flows
final serverAuth = Auth0Auth.machineToMachine(
  domain: 'your-tenant.auth0.com',
  clientId: 'YOUR_M2M_CLIENT_ID',
  clientSecret: 'YOUR_CLIENT_SECRET',
);

// Acquire Management API token
final token = await serverAuth.clientCredentialsToken(
  audience: 'https://your-tenant.auth0.com/api/v2/',
);
print('Mgmt API Token: ${token.accessToken}');
```

### 4. Token Silent Refresh & Storage

```dart
// Initialize your storage (file or memory)
await auth.initStorage();

// Later, acquire a fresh token silently
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

For full API reference, guides, and examples, visit our GitBook:

👉 [Auth0 Dart Auth SDK Docs](https://aortem.gitbook.io/auth0-dart-auth-sdk/)

---

## Contributing

We welcome issues and pull requests! Please read our [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines and coding standards.

---

## License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.

```
```
