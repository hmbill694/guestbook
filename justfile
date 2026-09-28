set shell := ["bash", "-euo", "pipefail", "-c"]
set dotenv-load

image := env("IMAGE", "ghcr.io/hmbill694/guestbook")
version := `git describe --tags --always --dirty 2>/dev/null || echo "0.0.0-dev"`

[doc('List all recipes')]
default:
    @just --list --unsorted

[doc('Install dependencies from the lockfile')]
[group('dev')]
setup:
    npm ci

[doc('Format in place')]
[group('fmt')]
fmt:
    npx prettier --write .

[doc('Verify formatting without writing')]
[group('fmt')]
fmt-check:
    npx prettier --check .

[doc('Type-check .astro and .ts files')]
[group('check')]
lint:
    npx astro check

[doc('Run unit tests')]
[group('test')]
test *ARGS:
    npx vitest run {{ ARGS }}

[doc('Run every test (no service-backed tests yet)')]
[group('test')]
test-all *ARGS:
    npx vitest run {{ ARGS }}

[doc('Build the standalone server into dist/')]
[group('build')]
build:
    npm run build

[doc('Run the dev server')]
[group('dev')]
run *ARGS:
    npm run dev -- {{ ARGS }}

[doc('Scan dependencies for known vulnerabilities')]
[group('check')]
audit:
    npm audit --audit-level high

[doc('Update dependencies within their ranges')]
[group('dev')]
update:
    npm update

[doc('Remove build output')]
[group('dev')]
clean:
    rm -rf dist .astro

[doc('Pre-push gate')]
check: fmt-check lint test build

[doc('Exactly what CI runs, in order')]
ci: setup fmt-check lint test build

[doc('Build the container image')]
[group('docker')]
docker-build tag=version:
    docker build \
      --build-arg VERSION={{ tag }} \
      --tag {{ image }}:{{ tag }} \
      --tag {{ image }}:latest \
      .

[doc('Run the image with a persistent data volume')]
[group('docker')]
docker-run *ARGS: docker-build
    docker run --rm -it -p 4321:4321 -v guestbook-data:/data {{ image }}:latest {{ ARGS }}

[confirm('Push image to the registry?')]
[doc('Push the image')]
[group('docker')]
docker-push tag=version:
    docker push {{ image }}:{{ tag }}
