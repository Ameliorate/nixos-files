pkgs: rec {
  python-with-my-packages = pkgs.python3.withPackages (python-packages: with python-packages; [
    virtualenvwrapper
    evdev
  ]); 

  nmfd = pkgs.stdenv.mkDerivation rec {
    name = "nmfd-${version}";
    version = "1.1.3";
    src = pkgs.fetchFromGitHub {
      owner = "Ameliorate";
      repo = "nmfd";
      rev = "v${version}";
      sha256 = "1gk3kz9m8547yn9w7cr4a3nlg5pq7z86mksv2ayrmvcicm6m0ifc";
    };

    makeFlags = [ "INSTALL_PATH=$(out)/bin/" "MANUAL_PATH=$(out)/share/man/man1" ];

    preBuild = ''
        mkdir -p $out/bin
        mkdir -p $out/share/man/man1
    '';
  };
}
