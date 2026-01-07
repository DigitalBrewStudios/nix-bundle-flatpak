{
  lib,
  flatpak-builder,
  runCommand,
  toArx, # This is the nix-bundle package/derivation
}:
{
  program,
  pname ? (lib.last (lib.splitString "/" program)),
  name ? pname,
  appId ? "io.github.${pname}",
}:
let
  manifest = builtins.toFile "manifest.json" (
    builtins.toJSON {
      app-id = appId;
      runtime = "org.freedesktop.Platform";
      runtime-version = "23.08";
      sdk = "org.freedesktop.Sdk";
      command = pname;
      modules = [
        {
          name = pname;
          buildsystem = "simple";
          build-commands = [
            "install -D ${toArx} /app/bin/${pname}"
          ];
        }
      ];
    }
  );
in
runCommand "${name}-flatpak"
  {
    nativeBuildInputs = [ flatpak-builder ];
    # flatpak-builder requires a writable HOME for cache and lock files
    HOME = "/build";

    # See issue https://github.com/DigitalBrewStudios/nix-bundle-flatpak/issues/1 for more info.
    meta.broken = true;
  }
  ''
    export XDG_CACHE_HOME=$TMPDIR/flatpak-cache
    mkdir -p $XDG_CACHE_HOME

    # Build the Flatpak repo
    flatpak-builder --repo=repo --force-clean build-dir ${manifest}

    # Export the final .flatpak bundle
    mkdir -p $out
    flatpak build-bundle repo $out/${name}.flatpak ${appId}
  ''
