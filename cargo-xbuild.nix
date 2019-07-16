{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "cargo-xbuild-${version}";
  version = "0.5.5";

  cargoSha256 = "1z9ba450kgyvz3mj310nsy4q55gqnamkxr9qvp5qlw0w7x1s82mb";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = "cargo-xbuild";
    rev = "v${version}";
    sha256 = "1v1xmqcwlxq4q7da0qf62js3rr2z5g4n41r0cz5lgc0hg3qy4bx7";
  };

  doCheck = false;

  preConfigure = ''
    export HOME=`mktemp -d`
  '';
}

