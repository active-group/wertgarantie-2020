let
  pkgs = import <nixpkgs> {};
  erlangv2303 = pkgs.stdenv.lib.overrideDerivation pkgs.erlangR23 (oldAttrs: rec {
    wxGTK = null;
    name = "erlang-" + version;
    version = "23.0.3";
    src = pkgs.fetchFromGitHub {
      owner = "erlang";
      repo = "otp";
      rev = "OTP-${version}";
      sha256 = "133aw1ffkxdf38na3smmvn5qwwlalh4r4a51793h1wkhdzkyl6mv";
    };
  });
#in with (import <nixpkgs> { config = import ./config.nix; }); {
in with (import <nixpkgs> { config = {allowUnfree = true;}; }); {
#in with pkgs; {
   allowUnfree = true;
   ecEnv = stdenv.mkDerivation {
      name = "env";
      nativeBuildInputs = [
         # libtool
         # autoconf
         # automake
         # libiconv
         erlangR23
         (beam.packagesWith erlangR23).elixir_1_10
         inotify-tools
         vscode
         ];
      src = null;
      shellHook = ''
        unset ERL_LIBS
      '';
   };
}
