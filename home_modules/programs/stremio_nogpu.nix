{ pkgs, ... }:

{
  home.packages = [
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh1
    (pkgs.symlinkJoin {
      name = "stremio";
      paths = [ pkgs.stremio-linux-shell ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/stremio \
          --set LIBGL_ALWAYS_SOFTWARE 1 \
          --set GALLIUM_DRIVER llvmpipe \
          --add-flags "--disable-gpu" \
          --add-flags "--disable-gpu-compositing" \
          --add-flags "--disable-software-rasterizer"
      '';
    })
  ];
}
