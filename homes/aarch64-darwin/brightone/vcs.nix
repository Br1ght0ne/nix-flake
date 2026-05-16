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
    settings.aliases.tug = [
      "bookmark"
      "move"
      "--from"
      "heads(::@ & bookmarks())"
      "--to"
      "heads(::@ ~ empty())"
    ];
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
