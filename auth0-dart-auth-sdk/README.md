# Social Login Authentication

This module provides functionality for authenticating users via social providers through Auth0.

## Features

## Features:

- **User Management:** Manage user accounts seamlessly with a suite of comprehensive user management functionalities.
- **Custom Token Minting:** Integrate cognito authentication with your backend services by generating custom tokens.
- **Generating Email Action Links:** Perform authentication by creating and sending email action links to users emails for email verification, password reset, etc.
- **ID Token verification:** Verify ID tokens securely to ensure that application users are authenticated and authorised to use app.
- **Managing SAML/OIDC Provider Configuration**: Manage and configure SAML and ODIC providers to support authentication and simple sign-on solutions.

## Getting Started

If you want to use the cognito Dart Admin Auth SDK for implementing a cognito authentication in your Flutter projects follow the instructions on how to set up the auth SDK.

- Ensure you have a Flutter or Dart (3.4.x) SDK installed in your system.
- Set up a cognito project and service account.
- Set up a Flutter project.

## Installation

For Flutter use:

```javascript
flutter pub add cognito_dart_auth_sdk
```

You can manually edit your `pubspec.yaml `file this:

```yaml
dependencies:
  cognito_dart_auth_sdk: ^0.0.3
```

You can run a `flutter pub get` for Flutter respectively to complete installation.

**NB:** SDK version might vary.

## Usage

### Initialization

```dart
final socialLogin = AortemAuth0SocialLogin(
  domain: 'your-domain.auth0.com',
  clientId: 'your_client_id',
);
# Database/AD/LDAP Passive Authentication

This module provides functionality for authenticating users via passive login flow using Database, Active Directory, or LDAP connections through Auth0.

## Features

- Passive authentication flow for Database/AD/LDAP connections
- Type-safe request/response handling
- Comprehensive error handling
- Support for standard OAuth parameters (scope, audience)

## Usage

### Initialization

```dart
final passiveAuth = AortemAuth0DatabaseAdLdapPassive(
  domain: 'your-domain.auth0.com',
  clientId: 'your_client_id',
);

# Enterprise SAML Authentication

This module provides functionality for authenticating users via enterprise SAML through Auth0.

## Features

- Enterprise SAML authentication flow
- Support for SAML request/response exchange
- Relay state handling
- Comprehensive error handling

## Usage

### Initialization

```dart
final samlAuth = AortemAuth0EnterpriseSaml(
  domain: 'your-domain.auth0.com',
);