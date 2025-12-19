# twind

Tailwind-style utility classes for Flutter widgets with compile-time code generation.

## Packages

- [`twind`](./packages/twind) - Runtime annotations and core types
- [`twind_generator`](./packages/twind_generator) - Code generator

## Development

This is a monorepo managed with [Melos](https://melos.invertase.dev/).

### Setup

```bash
# Install melos (optional, can use pub directly)
dart pub global activate melos

# Get dependencies for each package
cd packages/twind && flutter pub get
cd ../twind_generator && dart pub get
```

### Commands

```bash
# Run tests
cd packages/twind && flutter test

# Analyze code
cd packages/twind && flutter analyze
cd packages/twind_generator && dart analyze

# Format code
dart format packages/*/lib packages/*/test
```

## Publishing

### Manual Publishing (Current Method)

1. Update version in both `packages/twind/pubspec.yaml` and `packages/twind_generator/pubspec.yaml`
2. Update CHANGELOGs
3. Commit and push changes
4. Publish manually:

```bash
cd packages/twind
dart pub publish

cd ../twind_generator
dart pub publish
```

5. Create and push tag:

```bash
git tag v0.0.X
git push origin v0.0.X
```

### Automated Publishing (Coming Soon)

GitHub Actions workflow exists but requires pub.dev credentials setup. For now, use manual publishing.

## License

MIT
