{ den, ... }: {
  den.aspects.brightone = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects
    ];
    homeManager.home.stateVersion = "26.05";
  };
}
