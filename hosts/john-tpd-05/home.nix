{ lib, ... }:
{
  imports = [
    ../../modules/home/profiles/personal.nix

    # Linux-only extras: desktop, browsers, and host-specific leaves.
    ../../modules/packages/browsers.nix
    ../../modules/packages/developer.nix
    ../../modules/packages/personal.nix
    ../../modules/packages/work.nix

    ../../modules/desktop/cosmic/default.nix
    ../../modules/desktop/hypr/default.nix

    ../../modules/home/alacritty.nix
    ../../modules/home/rclone.nix
  ];

  # This is being imported from the modules above
  # home.packages = with pkgs; [
  # ];

  # Aliases: lg/ldock/cat come from profiles/personal.nix
  home.shellAliases = {
    zed = "zeditor";
  };

  # Enable XDG
  xdg.enable = true;

  # Set Okular as default PDF viewer
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Thunar as the default file manager (directories + trash)
      "inode/directory" = [ "thunar.desktop" ];
      "x-scheme-handler/trash" = [ "thunar.desktop" ];

      "application/pdf" = [ "okularApplication_pdf.desktop" ];
      "application/x-pdf" = [ "okularApplication_pdf.desktop" ];
      "application/acrobat" = [ "okularApplication_pdf.desktop" ];
      "application/vnd.pdf" = [ "okularApplication_pdf.desktop" ];
      "text/pdf" = [ "okularApplication_pdf.desktop" ];

      "text/html" = [ "zen-beta.desktop" ];
      "application/xhtml+xml" = [ "zen-beta.desktop" ];
      "x-scheme-handler/http" = [ "zen-beta.desktop" ];
      "x-scheme-handler/https" = [ "zen-beta.desktop" ];
      # swayimg for images (mimeapps.list doesn't support wildcards like image/*)
    }
    // lib.genAttrs [ "image/jpeg" "image/png" "image/gif" "image/webp" ] (_: [ "swayimg.desktop" ]);
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
