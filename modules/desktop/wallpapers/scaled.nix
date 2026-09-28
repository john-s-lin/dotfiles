{
  pkgs,
  lib,
}:
{
  # Pre-scale a source wallpaper to an exact monitor resolution with a proper
  # Lanczos resampler. hyprpaper (hyprtoolkit) samples textures with plain
  # GL_LINEAR and no mipmaps, so letting it shrink large images on the GPU
  # aliases high-frequency detail into a crunchy, noisy mess. Pre-scaling to
  # the target resolution gives hyprpaper a 1:1 blit: zero resampling, zero
  # aliasing, and ~3MB instead of ~450MB of decoded bitmaps in RAM.
  # The light unsharp mask restores microcontrast lost to antialiasing.
  scaledWallpaper =
    src: width: height:
    let
      name = lib.removeSuffix ".jpg" (baseNameOf (toString src));
    in
    pkgs.runCommand "wallpaper-${name}-${toString width}x${toString height}.jpg" { } ''
      ${pkgs.imagemagick}/bin/magick ${src} \
        -auto-orient \
        -filter Lanczos \
        -resize ${toString width}x${toString height}^ \
        -gravity center -extent ${toString width}x${toString height} \
        -unsharp 0x0.75+0.6+0.008 \
        -strip -quality 95 \
        jpg:$out
    '';
}