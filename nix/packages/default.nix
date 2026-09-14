{
  ...
}:
{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {

      packages = {
        tuxedo = pkgs.callPackage ./tuxedo.nix { };
        default = config.packages.tuxedo;
        git = config.packages.tuxedo.overrideAttrs { src = ../../.; };
      };
    };
}
