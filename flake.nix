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

        # Define which Rust version to use
        rustVersion = pkgs.rust-bin.stable.latest.default;

        # Name of your Rust grammar checker tool
        grammarCheckerPkg = "typst-languagetool";
        grammarCheckerUrl = "https://github.com/antonWetzel/typst-languagetool";
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Rust toolchain
            rustVersion
            pkgs.cargo-watch
            pkgs.rust-analyzer

            # Java and Maven
            pkgs.jdk
            pkgs.maven

            # Additional dependencies that might be needed
            pkgs.pkg-config
            pkgs.openssl
            pkgs.libiconv
          ];

          shellHook = ''
            echo "Typst Grammar Checking Development Environment"
            echo "--------------------------------------------"
            echo "Available tools:"
            echo "  - Rust: $(rustc --version)"
            echo "  - Cargo: $(cargo --version)"
            echo "  - Maven: $(mvn --version | head -n1)"

            # Install the grammar checker tool if not already installed
            if ! command -v ${grammarCheckerPkg} &> /dev/null; then
              echo "Installing ${grammarCheckerPkg}..."
              cargo install --git=${grammarCheckerUrl} cli --features=bundle
            else
              echo "${grammarCheckerPkg} is already installed"
            fi

            echo ""
            echo "Usage:"
            echo "  - Run grammar check: ${grammarCheckerPkg} check --bundle --main=./path/to/main.typ --options=./path/to/options.json"
            echo "--------------------------------------------"
          '';
        };
      }
    );
}
