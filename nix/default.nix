{}:
let
  sources = import ./sources.nix;
  overlays = [
    (import sources.nixpkgs-mozilla)
    (
      self: super: {
        rustChannel = self.rustChannelOf { channel = "nightly"; };
        rustFull = (self.rustChannel.rust.override {
          extensions = [
            "clippy-preview"
            "rustfmt-preview"
            "rust-analysis"
            "rust-std"
            "rust-src"
          ];
        });
        cargo = self.rustFull;
        rustc = self.rustFull;
      }
    )
    (self: super: { naersk = self.callPackage sources.naersk { }; })
    (self: super: { crate2nix = self.callPackage (sources.crate2nix + "/tools.nix") { }; })
    (self: super: rec {
      bootimage = (self.callPackage
        (self.crate2nix.generatedCargoNix {
          name = "bootimage";
          src = sources.bootimage;
        }) { }).rootCrate.build;
    })
  ];
  pkgs = import <nixpkgs> { inherit overlays; };
in
pkgs