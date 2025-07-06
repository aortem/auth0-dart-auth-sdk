## 0.0.1

### Added
- **Exception & Interface Exports**  
  - Exported a full suite of new exception types in `lib/entra_id_dart_auth_sdk.dart`:  
    - `AortemEntraIdAuthorizationUserCancelException`  
    - `AortemEntraIdAzureJsonCacheException`  
    - `AortemEntraIdAzureLoopbackClientException`  
    - `AortemEntraIdClientApplicationException`  
    - `AortemEntraIdDeviceCodeRequestException`  
    - `AortemEntraIdInteractiveRequestException`  
    - `AortemEntraIdOnBehalfOfRequestException`  
    - `AortemEntraIdSerializedAccessTokenException`  
    - `AortemEntraIdSerializedAppMetadataException`  
    - `AortemEntraIdSerializedIdTokenException`  
    - `AortemEntraIdSerializedRefreshTokenException`  
    - `AortemEntraIdSilentFlowRequestException`  
    - `AortemEntraIdTokenCacheException`  
  - Exported core interfaces:  
    - `EntraIdICacheClient`  
    - `EntraIdIPartitionManager`  
    - `EntraIdIPublicClientApplication`  
    - `EntraIdITokenCache`

- **Initial Token Storage Config**  
  - Added an empty `auth0-dart-auth-sdk/token_storage.json` file for future storage configuration.

- **Semantic Version Branch Validation**  
  - Enhanced backend CI (`tools/pipelines/backend/child-ci-setup-validation.yml`) to recognize release branches named as `X.Y.Z[-tag][+build]` via a new regex rule.

### Changed
- **README Update**  
  - Fixed the closing sentence under **“Enhance with Entra Id Dart Auth SDK”**, removing a stray “test” and completing the statement.

- **Library Entry Reorganization**  
  - Consolidated exports in `lib/entra_id_dart_auth_sdk.dart` to include the newly added exception and interface modules.

### Removed
- **Encoding Utils Tests**  
  - Deleted unit tests for `AortemEntraIdEncodingUtils` (`encodeUrl`/`decodeUrl` and Base64 decode error scenarios).

- **Serializer Error Test**  
  - Removed the invalid-JSON error-handling test for `AortemEntraIdSerializer`.

## 0.0.1-pre

- Initial pre-release version of the Auth0 Dart Auth SDK.
