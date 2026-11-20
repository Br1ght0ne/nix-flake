darwinConfigurations:
let
  home = host: darwinConfigurations.${host}.config.home-manager.users.brightone;
  silicon = home "silicon";

  # Resolve the installed package so an override cannot leave the check testing a stock build.
  installedOnSilicon =
    name:
    let
      matches = builtins.filter (pkg: (pkg.pname or pkg.name) == name) silicon.home.packages;
    in
    if builtins.length matches == 1 then
      builtins.head matches
    else
      throw "Expected exactly one ${name} package in silicon's Home Manager configuration";

  entry = app: pkg: {
    inherit app;
    path = pkg.outPath;
  };
  sharedApps = host: [
    # The program modules add local wrappers to these packages.
    (entry "emacs" (home host).programs.emacs.package)
    (entry "zed-editor" (home host).programs.zed-editor.package)
  ];
in
sharedApps "silicon"
++ sharedApps "iridium"
++ map (name: entry name (installedOnSilicon name)) [
  "alt-tab-macos"
  "imhex"
  "moonlight-qt"
  "sniffnet"
]
