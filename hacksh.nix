pkgs: let pipe = "/tmp/hackshpipe.fifo"; in {
  client = pkgs.writeShellScriptBin "hackshclient" ''
    pipe=${pipe}

    if [[ ! -p $pipe ]]; then
      echo "Reader not running"
      exit 1
    fi

    echo "$2" >$pipe
  '';

  server = pkgs.writeShellScriptBin "hackshserver" ''
    pipe=${pipe}

    trap "rm -f $pipe" EXIT

    if [[ ! -p $pipe ]]; then
      ${pkgs.coreutils}/bin/mkfifo $pipe
      chmod 600 $pipe
    fi

    while true
    do
      if read line <$pipe; then
        # This isn't using the pure-nix version of bash because we want all of the environment variables that come with PATH's bash.
        bash -c "$line" &
      fi
    done
  '';
}
