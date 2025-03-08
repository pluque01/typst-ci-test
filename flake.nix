{
  description = "Typst grammar checking workflow";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # Package the grammar checker as a derivation
        typst-languagetool = pkgs.rustPlatform.buildRustPackage {
          useFetchCargoVendor = true;
          pname = "typst-languagetool";
          version = "0.1.0"; # Update this as needed

          src = pkgs.fetchFromGitHub {
            owner = "antonWetzel";
            repo = "typst-languagetool";
            rev = "main"; # Replace with specific commit when possible
            sha256 = "sha256-hnt8zsDSiq2Kt+N1rh1YHXC6VYRbmDxomHDN8CVvs18=";
          };
          cargoHash = "sha256-tVbiOjsVGR3JgNIPlYlH56g4VqAKpVdcjh8RkGYIXMk=";

          buildFeatures = ["jar"];

          # Add any native build inputs required
          nativeBuildInputs = with pkgs; [
            rust-bin.stable.latest.default
            pkg-config
          ];

          # Add any runtime dependencies
          buildInputs = with pkgs; [
            openssl
            jdk
          ];

          meta = with pkgs.lib; {
            description = "Typst grammar checker using LanguageTool";
            homepage = "https://github.com/antonWetzel/typst-languagetool";
            license = licenses.mit;
          };
        };
      in {
        # Make the package available
        packages.typst-languagetool = typst-languagetool;
        packages.default = typst-languagetool;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            self.packages.${system}.typst-languagetool

            pkgs.jdk
            pkgs.pkg-config
            pkgs.openssl
            pkgs.libiconv
          ];

          shellHook = ''
            echo "Typst Grammar Checking Development Environment"
            echo "--------------------------------------------"
            echo "Available tools:"
            echo "  - typst-languagetool: $(which typst-languagetool)"
            echo ""
            echo "Usage:"
            echo "  - Run grammar check: typst-languagetool check --main=./path/to/main.typ --options=./path/to/options.json --jar-location=./path/to/jar"
            echo "--------------------------------------------"
          '';
        };
      }
    );
}
