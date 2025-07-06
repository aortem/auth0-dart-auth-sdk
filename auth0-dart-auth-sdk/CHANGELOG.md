## 0.0.1

### Added
- **`.gitattributes`**  
  Enforce `text=auto` for consistent line endings across platforms.  
- **`.gitignore`**  
  Global repo rules to ignore:
  - Environment files (`**/*.env`)  
  - IDE settings (`**/.idea/`, `**/.vscode/`)  
  - Dart build artifacts (`**/.dart_tool/`, `**/pubspec.lock`)  
- **GitLab CI Stages**  
  Introduced two new pipeline stages:
  - `setup` – prepares environment variables and merge-request context  
  - `validation` – runs branch/message validators and debug jobs  
- **`debug_merge_request` Job**  
  A lightweight validation task that echoes core CI variables for debugging merge-request pipelines.

### Changed
- **CI Pipeline Overhaul**  
  - Replaced the old `unit_testing`, `analyze_sample_apps`, and `release` stages with our new `setup` and `validation` stages.  
  - Consolidated testing and coverage steps under the `validation` stage to ensure full end-to-end CI validation.

### Removed
- **Obsolete CI Jobs**  
  - Removed the deprecated `unit_testing`, `analyze_sample_apps`, and `release` jobs from the pipeline configuration.
```


## 0.0.1-pre

- Initial pre-release version of the Auth0 Dart Auth SDK.
