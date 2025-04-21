# Social Login Authentication

This module provides functionality for authenticating users via social providers through Auth0.

## Features

- Exchange social provider access tokens for Auth0 tokens
- Support for multiple social providers (Google, Facebook, etc.)
- Type-safe request/response handling
- Comprehensive error handling

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