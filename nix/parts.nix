{
  ...
}:
{
  imports = [
    ./packages
    ./overlays.nix
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
