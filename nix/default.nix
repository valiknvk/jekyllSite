with import <nixpkgs> { };

let jekyll_env = bundlerEnv rec {
    name = "jekyll_env";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation rec {
    name = "site";
    buildInputs = [ jekyll_env bundler ruby ];
      buildPhase = ''
    ${jekyll_env}/bin/bundle exec jekyll build
  '';
    shellHook = ''
      exec ${jekyll_env}/bin/jekyll serve --watch
    '';
  }
