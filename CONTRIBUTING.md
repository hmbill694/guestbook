# Contributing

## Environment

The toolchain (Node 24, npm, `just`) comes from [devenv](https://devenv.sh). With direnv installed, `cd` into the repo and run `direnv allow` once; otherwise run `devenv shell`.

Every command is a `just` recipe:

| Command           | Does                                                      |
| ----------------- | --------------------------------------------------------- |
| `just setup`      | install dependencies from the lockfile                    |
| `just run`        | start the dev server                                      |
| `just fmt`        | format with Prettier                                      |
| `just check`      | format check, `astro check`, tests, build                 |
| `just ci`         | exactly what CI runs                                      |
| `just docker-run` | build the image and run it with a `guestbook-data` volume |

The database path is read from `DB_PATH` (default `data/guestbook.db`).

## Commit convention

PR titles must follow [Conventional Commits](https://www.conventionalcommits.org): `type: lowercase subject` with no trailing period. Allowed types are `feat`, `fix`, `docs`, `chore`, `refactor`, `perf`, `test`, `build`, `ci` and `revert`.

PRs are squash-merged, so the PR title becomes the commit on `main`. release-please reads those commits to pick the next version and write `CHANGELOG.md`:

- `feat` bumps the minor version, `fix` the patch version
- `feat!` or a `BREAKING CHANGE:` footer bumps the major version (minor while we are below 1.0)
- `chore`, `ci` and `test` are left out of the changelog

Merging the release PR tags the release and publishes `ghcr.io/hmbill694/guestbook`. Never edit `CHANGELOG.md` by hand.
