{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      # Add Home Manager profile to PATH
      export PATH="$HOME/.nix-profile/bin:$PATH"
    '';
  };
}
