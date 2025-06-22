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

1. Pre-commit hooks automatically format Dart code via Husky and lint-staged
2. All packages support Dart SDK `>=2.17.0 <4.0.0` and Flutter `>=3.0.0`
3. Each package is independently versioned and published to pub.dev

## Creating New Hooks

1. Add hook file to `packages/[package_name]/lib/src/`
2. Follow existing naming convention: `use_[hook_name].dart`
3. Export from main library file
4. Add comprehensive tests using the hook testing utilities
5. Add documentation in `/docs/` with DartPad example link if applicable