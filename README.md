# twind

Tailwind-style utility classes for Flutter widgets with compile-time code generation.

## Packages

- [`twind`](./packages/twind) - Runtime annotations and core types  
  [![pub package](https://img.shields.io/pub/v/twind.svg)](https://pub.dev/packages/twind)
- [`twind_generator`](./packages/twind_generator) - Code generator  
  [![pub package](https://img.shields.io/pub/v/twind_generator.svg)](https://pub.dev/packages/twind_generator)

## Development

This repo is a Dart **pub workspace** (monorepo support), so you can run a
single `dart pub get` at the repo root.

For convenience, common tasks are defined in `deno.json`.

```bash
# Get dependencies (workspace)
deno task get

# Format / analyze / test
deno task fmt
deno task analyze
deno task test

# Targeted runs
deno task test:generator
deno task e2e

# Publish dry-runs (recommended before tagging)
deno task dpub
```

Manual equivalents (no Deno):

```bash
# Dependencies
dart pub get

# Tests
cd packages/twind_generator && dart test
cd packages/twind/example && flutter test

# Analyze
flutter analyze packages/twind
dart analyze packages/twind_generator

# Format
dart format packages/*/lib packages/twind_generator/test packages/twind/example/lib packages/twind/example/test

# Code generation
cd packages/twind/example && flutter pub run build_runner build --delete-conflicting-outputs
```

## Publishing

Publishing is done automatically via GitHub Actions. To publish a new version,
run `deno task bump` and follow the prompts.

## License

MIT
