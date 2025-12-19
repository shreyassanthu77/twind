# Agent Guidelines for twind

## Commands
```bash
# Repo-level tasks (preferred)
deno task get
deno task fmt
deno task analyze
deno task test

# Publish dry-runs
# (useful before tagging for release)
deno task dpub

# Package-level commands (for debugging)
cd packages/twind && flutter test [test/path_test.dart]
cd packages/twind_generator && dart test

flutter analyze packages/twind
dart analyze packages/twind_generator

# Code generation
cd packages/twind && dart run build_runner build --delete-conflicting-outputs
```

## Style
- **Imports**: `package:` imports first, then relative imports, alphabetically sorted
- **Formatting**: Use `dart format`, max line length 80 (enforced by formatter)
- **Types**: Always explicit return types, use `final` for immutables
- **Naming**: `lowerCamelCase` for vars/functions, `UpperCamelCase` for classes, `_private` for internals
- **Lints**: Follow `package:flutter_lints/flutter.yaml` (configured in analysis_options.yaml)
- **Errors**: Throw `InvalidGenerationSourceError` in generators with descriptive messages
- **Generated code**: Prefix classes with `_$`, add `// ignore_for_file:` pragmas as needed
- **Comments**: Use `///` for public API docs, `//` for implementation notes

## Publishing
- Bump versions in both `packages/*/pubspec.yaml` + CHANGELOGs
- Tag: `git tag twind-v0.0.X` and `git tag twind_generator-v0.0.X`, then push tags
- GitHub Actions handles automated publishing via OIDC
