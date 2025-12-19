# twind

Tailwind-style utility classes for Flutter widgets with compile-time code generation.

## Packages

- [`twind`](./packages/twind) - Runtime annotations and core types  
  [![pub package](https://img.shields.io/pub/v/twind.svg)](https://pub.dev/packages/twind)
- [`twind_generator`](./packages/twind_generator) - Code generator  
  [![pub package](https://img.shields.io/pub/v/twind_generator.svg)](https://pub.dev/packages/twind_generator)

## Development

This is a simple monorepo with two packages. No special tooling required.

```bash
# Get dependencies
cd packages/twind && flutter pub get
cd packages/twind_generator && dart pub get

# Run tests
cd packages/twind && flutter test

# Analyze
cd packages/twind && flutter analyze
cd packages/twind_generator && dart analyze

# Format
dart format packages/*/lib packages/*/test
```

## Publishing

### Automated (via GitHub Actions)

1. Update versions in `packages/twind/pubspec.yaml` and `packages/twind_generator/pubspec.yaml`
2. Update CHANGELOGs
3. Commit and push
4. Create and push tags:

```bash
# For twind
git tag twind-v0.0.X
git push origin twind-v0.0.X

# For twind_generator  
git tag twind_generator-v0.0.X
git push origin twind_generator-v0.0.X
```

GitHub Actions will automatically publish to pub.dev using OIDC authentication.

### Manual Publishing

Manual publishing is disabled. Use GitHub Actions by pushing tags.

## License

MIT
