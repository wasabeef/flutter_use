# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a monorepo for `flutter_use` - a collection of Flutter Hooks inspired by React's `react-use` library. The project uses Melos for managing multiple packages within a single repository.

## Package Structure

- `/packages/basic/` - Core hooks library (`flutter_use`)
- `/packages/audio/` - Audio hooks (`flutter_use_audio`)
- `/packages/battery/` - Battery state hooks (`flutter_use_battery`)
- `/packages/geolocation/` - Geolocation hooks (`flutter_use_geolocation`)
- `/packages/network/` - Network state hooks (`flutter_use_network_state`)
- `/packages/sensors/` - Device sensors hooks (`flutter_use_sensors`)
- `/packages/video/` - Video player hooks (`flutter_use_video`)

## Essential Commands

### Monorepo Management (Melos)
```bash
# Install dependencies for all packages
melos get

# Upgrade dependencies across all packages
melos upgrade

# Run static analysis on all packages
melos analyze

# Format all Dart code
melos format

# Run tests (only available for flutter_use package)
melos test
```

### Per-Package Development
```bash
# Navigate to specific package first
cd packages/basic  # or any other package

# Standard Flutter commands
flutter pub get
flutter test
flutter analyze
dart format .
```

### Running Example Apps
```bash
# Each package has an example directory
cd packages/basic/example
flutter run
```

## Architecture Patterns

### Hook Development Pattern
All hooks follow a consistent pattern:
1. Located in `packages/[package_name]/lib/src/` as individual files
2. Return specialized action classes that encapsulate:
   - Getters for current state
   - Methods for state manipulation
   - Additional utility methods
3. Main export file aggregates all hooks

### Testing Pattern
- Uses custom `buildHook` and `act` utilities (see `packages/basic/test/testing/hook_testing.dart`)
- Test files mirror source structure
- Each hook has comprehensive test coverage

### Package Dependencies
- Core package (`flutter_use`) has minimal dependencies
- Other packages require specific plugins (e.g., `battery_plus`, `geolocator`)
- Dependencies are clearly marked in README with badge indicators

## Development Workflow

1. Pre-commit hooks automatically format Dart code via lefthook and lint-staged
2. All packages support Dart SDK `>=2.17.0 <4.0.0` and Flutter `>=3.0.0`
3. All packages use unified versioning (currently v1.0.0)
4. Automated CI/CD pipeline with GitHub Actions for quality assurance and publishing

## Creating New Hooks

1. Add hook file to `packages/[package_name]/lib/src/`
2. Follow existing naming convention: `use_[hook_name].dart`
3. For function-suffixed hooks (e.g., `useAsyncFn`), place in separate files for consistency
4. Export from main library file (`packages/[package_name]/lib/[package_name].dart`)
5. Add comprehensive tests using the hook testing utilities
6. Add documentation in `/docs/` with DartPad example link if applicable
7. Create demo implementations in `/demo/lib/hooks/` for interactive examples

## Release Process

### Automated Release Pipeline
The project uses fully automated releases via GitHub Actions:

1. **Tag Creation**: Create and push a version tag (e.g., `v1.0.1`)
   ```bash
   git tag v1.0.1
   git push origin main --tags
   ```

2. **Automated Steps**: GitHub Actions automatically:
   - Runs comprehensive quality checks (tests, formatting, analysis)
   - Validates all packages can be published (`melos publish --dry-run --yes`)
   - Generates release notes using git-cliff
   - Creates GitHub Release
   - Publishes all packages to pub.dev (`melos publish --no-dry-run --yes`)

### Version Management
- All packages maintain unified versioning
- Update version in all `pubspec.yaml` files before tagging
- Update `CHANGELOG.md` for each package with release notes

### Pre-Release Checklist
- [ ] All tests pass: `melos test`
- [ ] Code formatted: `melos format`
- [ ] Static analysis clean: `melos analyze`
- [ ] Package descriptions are accurate and specific
- [ ] CHANGELOG.md updated for all packages
- [ ] Version bumped in all pubspec.yaml files

### CI/CD Troubleshooting
- **Interactive Prompts**: Use `--yes` flag for Melos commands in CI
- **Package Validation**: Ensure all required fields in pubspec.yaml (name, version, description, homepage, repository, documentation, issue_tracker)
- **Git Clean State**: Commit all changes before tagging for release

## Documentation Standards

### DartDoc Comments
- Use comprehensive DartDoc comments for all public APIs
- Include usage examples in comments
- Document parameter types and return values
- Explain hook behavior and lifecycle

### CHANGELOG Format
- Use natural, developer-friendly language
- Group changes by type: New Features, Improvements, Breaking Changes
- Include context about why changes were made
- Avoid AI-generated tone in favor of authentic developer communication

### Package Descriptions
Each package should have a specific, descriptive summary:
- `flutter_use`: "Essential Flutter hooks collection with 36 production-ready hooks for async operations, form management, UI interactions, and state management."
- `flutter_use_audio`: "Audio playback hooks for Flutter applications..."
- etc.

## Quality Assurance

### Testing Requirements
- Minimum 252 tests for the basic package
- Test all hook states and edge cases
- Use proper cleanup in tests to prevent timer leaks
- Test error scenarios and recovery

### Code Standards
- Follow strict static analysis rules
- Use explicit type parameters where needed for type inference
- Maintain consistent file organization patterns
- Prefer composition over inheritance in hook design