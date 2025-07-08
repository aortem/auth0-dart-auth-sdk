<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
  </picture>
</p>

<h2 align="center">auth0_dart_auth_sdk</h2>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- Release Badge -->
  <a href="https://github.com/aortem/auth0_dart_auth_sdk/tags">
    <img alt="Release" src="https://img.shields.io/static/v1?label=release&message=v0.0.1-pre+10&color=blue&style=for-the-badge" />
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
   <a href="https://auth0.google.com/docs/reference/admin/node/auth0-admin.auth?_gl=1*1ewipg9*_up*MQ..*_ga*NTUxNzc0Mzk3LjE3MzMxMzk3Mjk.*_ga_CW55HF8NVT*MTczMzEzOTcyOS4xLjAuMTczMzEzOTcyOS4wLjAuMA..">
    <img alt="API Reference" src="https://img.shields.io/badge/API-reference-blue.svg?style=for-the-badge" />
  <br/>
<!-- Pipeline Badge -->
<a href="https://github.com/aortem/auth0_dart_auth_sdk/actions">
  <img alt="Pipeline Status" src="https://img.shields.io/github/actions/workflow/status/aortem/auth0_dart_auth_sdk/dart-analysis.yml?branch=main&label=pipeline&style=for-the-badge" />
</a>
<!-- Code Coverage Badges -->
  </a>
  <a href="https://codecov.io/gh/open-feature/dart-server-sdk">
    <img alt="Code Coverage" src="https://codecov.io/gh/open-feature/dart-server-sdk/branch/main/graph/badge.svg?token=FZ17BHNSU5" />
<!-- Open Source Badge -->
  </a>
  <a href="https://bestpractices.coreinfrastructure.org/projects/6601">
    <img alt="CII Best Practices" src="https://bestpractices.coreinfrastructure.org/projects/6601/badge?style=for-the-badge" />
  </a>
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

## Documentation

For detailed guides, API references, and example projects, visit our [auth0 Dart Auth SDK Documentation](https://aortem.gitbook.io/auth0-dart-auth-admin-sdk). Start building with  auth0 Dart Auth SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  auth0 Dart Auth SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  auth0 Dart Auth SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support Tiers

auth0 Dart Auth SDK offers various support tiers for our open-source products with an Initial Response Service Level Agreement (IRSLA):

### Community Support
- **Cost**: Free
- **Features**: Access to community forums, basic documentation.
- **Ideal for**: Individual developers or small startups.
- **SLA**: NA

### Standard Support
- **Cost**: $10/month - Billed Annually.
- **Features**: Extended documentation, email support, 10 business days response SLA.
- **Ideal for**: Growing startups and small businesses.
- **SLA**: 10 business days (Monday-Friday) IRSLANA
- [Subscribe-Coming Soon]()

### Enhanced Support
- **Cost**: $100/month - Billed Annually
- **Features**: Access to roadmap, 72-hour response SLA, feature request prioritization.
- **Ideal for**: Medium-sized enterprises requiring frequent support.
- **SLA**: 5 business days IRSLA
- [Subscribe-Coming Soon]()

### Enterprise Support
- **Cost**: 450/month
- **Features**: 
  - 48-hour response SLA, 
  - Access to beta features:
  - Comprehensive support for all Aortem Open Source products.
  - Premium access to our exclusive enterprise customer forum.
  - Early access to cutting-edge features.
  - Exclusive access to Partner/Reseller/Channel Program..
- **Ideal for**: Large organizations and enterprises with complex needs.
- **SLA**: 48-hour IRSLA
- [Subscribe-Coming Soon]()

*Enterprise Support is designed for businesses, agencies, and partners seeking top-tier support across a wide range of Dart backend and server-side projects.  All Open Source projects that are part of the Aortem Collective are included in the Enterprise subscription, with more projects being added soon.

## Licensing

All  auth0 Dart Auth SDK packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, which are licensed from third party software  Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with auth0 Dart Auth SDK

We hope the auth0 Dart Auth SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!