# twind

Tailwind-style utility classes for Flutter widgets with compile-time code generation.

## Packages

- [`twind`](./packages/twind) - Runtime annotations and core types
- [`twind_generator`](./packages/twind_generator) - Code generator

## Development

This is a monorepo managed with [Melos](https://melos.invertase.dev/).

### Setup

```bash
# Install melos
dart pub global activate melos

# Bootstrap the workspace
melos bootstrap
```

### Commands

```bash
# Run tests
melos run test

# Analyze code
melos run analyze

# Format code
melos run format

# Check formatting
melos run format:check
```

## Publishing

### Automated (via GitHub Actions)

1. Update version in both `packages/twind/pubspec.yaml` and `packages/twind_generator/pubspec.yaml`
2. Update CHANGELOGs
3. Commit changes
4. Create and push a tag:

```bash
git tag v0.0.2
git push origin v0.0.2
```

GitHub Actions will automatically publish to pub.dev.

### Manual

```bash
cd packages/twind
dart pub publish

cd ../twind_generator
dart pub publish
```

## License

MIT
