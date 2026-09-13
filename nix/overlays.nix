{
  self,
  ...
}:
{
  flake.overlays = {
    default = final: _prev: {
      tuxedo = self.packages.${final.stdenv.hostPlatform.system}.default;
    };
  };
}
