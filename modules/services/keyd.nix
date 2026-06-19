{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ]; # Apply to all keyboards
        settings = {
          main = {
            # Caps Lock: tap for Esc, hold for Ctrl (matches your evremap config)
            capslock = "overload(control, esc)";

            # Physical Alt behaves like Cmd/Super; physical Super remains Alt.
            leftalt = "layer(meta)";
            rightalt = "layer(meta)";
            leftmeta = "layer(alt)";
          };

          meta = {
            a = "C-a";
            c = "C-c";
            f = "C-f";
            l = "C-l";
            n = "C-n";
            o = "C-o";
            p = "C-p";
            q = "C-q";
            r = "C-r";
            s = "C-s";
            t = "C-t";
            v = "C-v";
            w = "C-w";
            x = "C-x";
            z = "C-z";
          };
        };
        extraConfig = ''
          [meta+shift]
          r = C-S-r
          t = C-S-t
          z = C-S-z
        '';
      };
    };
  };
}
