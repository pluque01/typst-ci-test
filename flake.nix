{
  description = "Typst grammar checking workflow";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      system = "x86_64-linux"; # Or your specific Linux system architecture
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
          rev = "0b4d4f9b9540a4a58003365fa618cfed07e85490";
          sha256 = "sha256-hnt8zsDSiq2Kt+N1rh1YHXC6VYRbmDxomHDN8CVvs18=";
        };
        cargoHash = "sha256-tVbiOjsVGR3JgNIPlYlH56g4VqAKpVdcjh8RkGYIXMk=";

        buildFeatures = ["jar"];

        nativeBuildInputs = with pkgs; [
          (rust-bin.stable.latest.minimal.override {
            extensions = [ "rust-src" ];
            targets = [ "x86_64-unknown-linux-gnu" ];
          })
          pkg-config
        ];

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
      # Define packages only for Linux
      packages.${system} = {
        typst-languagetool = typst-languagetool;
        default = typst-languagetool;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          typst-languagetool
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
    };
}
