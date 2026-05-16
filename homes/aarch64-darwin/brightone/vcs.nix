{ pkgs, ... }:
{
  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Br1ght0ne";
      user.email = "12615679+Br1ght0ne@users.noreply.github.com";
    };
    signing.key = "5337CD105484F2C839865B01524CFA23C413B905";
  };
  programs.gh.enable = true;
  programs.lazygit.enable = true;

  # Jujutsu
  programs.jujutsu = {
    enable = true;
    settings = {
      aliases = {
        blame = [
          "file"
          "annotate"
        ];
        collapse = [
          "squash"
          "-f"
          "branch_start(@)+::@"
          "-t"
          "branch_start(@)"
        ];
        difft = [
          "diff"
          "--tool"
          "difft"
        ];
        long = [
          "log"
          "-T"
          "builtin_log_detailed"
        ];
        open = [
          "log"
          "-r"
          "heads(mine()) ~ ::trunk()"
        ];
        push = [
          "git"
          "push"
        ];
        restack = [
          "rebase"
          "-o"
          "trunk()"
          "-s"
          "mutable_roots()"
        ];
        short = [
          "log"
          "-T"
          "builtin_log_oneline"
        ];
        sync = [
          "git"
          "fetch"
          "--all-remotes"
        ];
        tug = [
          "bookmark"
          "advance"
        ];
      };
      revset-aliases = {
        "branch_start(to)" = "heads(::to & trunk())+ & ::to";
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "closest_pushable(to)" = "heads(::to & ~description(exact:\"\") & (~empty() | merges()))";
        "mutable_roots()" = "roots(trunk()..) & mutable()";
      };
      revsets.bookmark-advance-to = "closest_pushable(@)";
      ui.default-command = "log";
      user = {
        name = "Oleksii Filonenko";
        email = "github@brightone.cloud";
      };
    };
  };
  programs.jjui.enable = true;
  home.packages = with pkgs; [
    git-backdate
    gitleaks
    lazyjj
    trufflehog
  ];

  # Diff
  programs.delta.enable = true;
  programs.difftastic = {
    enable = true;
    git.enable = true;
    jujutsu.enable = true;
    git.diffToolMode = true;
  };
}
