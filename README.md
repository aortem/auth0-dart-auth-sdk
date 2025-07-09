<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
  </picture>
</p>

<h2 align="center">Auth0 Dart Auth SDK</h2>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- Release Badge -->
  <a href="https://github.com/aortem/auth0_dart_auth_sdk/tags">
  <img alt="Latest Release" src="https://img.shields.io/github/v/tag/aortem/auth0-dart-auth-sdk?style=for-the-badge" />
</a>
  <br/>
  <!-- Dart-Specific Badges -->
  <a href="https://pub.dev/packages/auth0_dart_auth_sdk">
    <img alt="Pub Version" src="https://img.shields.io/pub/v/auth0_dart_auth_sdk.svg?style=for-the-badge" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Built with Dart" src="https://img.shields.io/badge/Built%20with-Dart-blue.svg?style=for-the-badge" />
  </a>
 <!-- auth0 Badge -->
   <a href="https://auth0.com/docs/api/authentication#introduction">
    <img alt="API Reference" src="https://img.shields.io/badge/API-reference-blue.svg?style=for-the-badge" />
  <br/>
</p>
<!-- x-hide-in-docs-start -->

### **Core Authentication Methods**

| Authentication Method                         | SDK API                                    | Description                                                                                 |
|-----------------------------------------------|--------------------------------------------|---------------------------------------------------------------------------------------------|
| **Authorization Code (PKCE)**                 | `loginWithPkce(...)`                       | Standard interactive login using the Authorization Code flow with PKCE for enhanced security. |
| **Silent Authentication**                     | `acquireTokenSilent(...)`                  | Automatically renews access tokens in the background using a stored refresh token.          |
| **Refresh Token Flow**                        | (built into silent auth)                   | Explicitly exchanges a refresh token for a new access token when called directly.           |
| **Client Credentials**                        | `clientCredentialsToken(...)`              | Machine-to-machine (M2M) flow: exchange client ID/secret for an access token.               |
| **Resource Owner Password Credentials (ROPC)**| `loginWithUsernamePassword(...)`           | Direct username/password login (use sparingly; less secure and not recommended for public apps). |
| **Device Code Flow**                          | `loginWithDeviceCode(...)`                 | User-friendly device flow: poll for authentication on devices without browsers.             |
| **Passwordless (Email OTP)**                  | `loginPasswordlessWithCode(...)`           | One-time code sent via email for passwordless login.                                        |
| **Passwordless (Magic Link)**                 | `loginPasswordlessWithLink(...)`           | Email a magic-link that logs the user in when clicked.                                      |
| **Passwordless (SMS OTP)**                    | `loginPasswordlessWithSms(...)`            | One-time code sent via SMS for passwordless login.                                          |
| **Universal Login (Hosted UI)**               | `loginWithHostedUI(...)`                   | Redirects to Auth0’s hosted login page (customizable branding).                             |
| **Social & Enterprise Login**                 | (via Hosted UI)                            | Built-in support for Google, Facebook, Azure AD, SAML, and other connections.               |
| **Multi-Factor Authentication (MFA)**         | (configured in Hosted UI)                  | Enforce second-factor (OTP apps, SMS, email) as part of the hosted login flow.              |
| **Custom OAuth2 Connections**                 | `loginWithOAuth2Connection(...)`           | Plug in generic OAuth2/SAML identity providers not covered out of the box.                  |

## Available Versions / Sample Apps

Auth0-Dart-Auth-SDK is available in a single version with sample apps:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.

2. **Sample Apps - FrontEnd Version**: The sample apps are provided in various frontend languages in order to allow maximum flexibility with your frontend implementation with the Dart backend.  Note that new features are first tested in the sample apps before being released in the mainline branch. Use only as a guide for your frontend/backend implementation of Dart.

## Documentation

For detailed guides, API references, and example projects, visit our [Auth0-Dart-Auth-SDK Documentation](https://aortem.gitbook.io/auth0-dart-auth-sdk). Start building with  Auth0-Dart-Auth-SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  Auth0-Dart-Auth-SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  Auth0-Dart-Auth-SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support

For support across all Aortem open-source products, including this SDK, visit our [Support Page](https://aortem.io/support).


## Licensing

The **Auth0 Dart Auth SDK** is licensed under a dual-license approach:

1. **BSD-3 License**:
   - Applies to all packages and libraries in the SDK.
   - Allows use, modification, and redistribution, provided that credit is given and compliance with the BSD-3 terms is maintained.
   - Permits usage in open-source projects, applications, and private deployments.

2. **Enhanced License Version 2 (ELv2)**:
   - Applies to all use cases where the SDK or its derivatives are offered as part of a **cloud service**.
   - This ensures that the SDK cannot be directly used by cloud providers to offer competing services without explicit permission.
   - Example restricted use cases:
     - Including the SDK in a hosted SaaS authentication platform.
     - Offering the SDK as a component of a managed cloud service.

### **Summary**
- You are free to use the SDK in your applications, including open-source and commercial projects, as long as the SDK is not directly offered as part of a third-party cloud service.
- For details, refer to the [LICENSE](LICENSE.md) file.

## Enhance with Auth0-Dart-Auth-SDK

We hope the Auth0-Dart-Auth-SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!
