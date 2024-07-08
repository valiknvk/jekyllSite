{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
	  site_dir = pkgs.lib.fileset.toSource {
          	root = ./.;
          	fileset = ./site;
        	};
          nginxConf = pkgs.lib.fileset.toSource {
                root = ./.;
                fileset = ./nginx.conf;
                };

      in with pkgs; rec {
          defaultPackage = dockerTools.buildLayeredImage {
            name = "nginx";
            tag = "nix";

            contents = [
		nginxConf
                site_dir
                nginx
                bash
                dockerTools.fakeNss
                coreutils
                gnugrep
           ];
            extraCommands = ''
                       mkdir -p var/log/nginx var/cache/nginx var/www
                       mkdir -p tmp/nginx_client_body
            '';
            config.Cmd = ["${pkgs.nginx}/bin/nginx" "-c" "${nginxConf}/nginx.conf"] ;
            config.ExposedPorts = {"80/tcp" = {};};
          };
	});
}
