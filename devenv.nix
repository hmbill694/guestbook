{ pkgs, ... }:

{
  # Tools every recipe in the justfile needs.
  packages = [
    pkgs.just
    pkgs.git
  ];

  # The Node developers and CI build with. The Node that ships is the
  # Dockerfile's base image; package.json `engines` is the supported minimum.
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_24;
    # `just setup` installs from the lockfile; auto-install on shell entry
    # would run `npm install` in CI and could rewrite package-lock.json.
    npm.enable = true;
  };

  enterShell = ''
    just --list
  '';
}
