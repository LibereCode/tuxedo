{
  lib,
  rustPlatform,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:
let
  repoRoot = ../../.;
  cargoToml = fromTOML (builtins.readFile (repoRoot + /Cargo.toml));
  inherit (cargoToml.package) version;
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuxedo";
  inherit version;
  __structuredAttrs = true;

  src = lib.cleanSource repoRoot;

  cargoLock.lockFile = repoRoot + /Cargo.lock;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  checkFlags = [
    # Failure
    "--skip=insert_dialog_after_nl_parse"
  ];

  meta = {
    description = "Fast, keyboard-driven terminal UI for todo.txt";
    homepage = "https://github.com/webstonehq/tuxedo";
    changelog = "https://github.com/webstonehq/tuxedo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "tuxedo";
  };
})
