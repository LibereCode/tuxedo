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
      };
    };
}
