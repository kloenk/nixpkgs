{ llvmPackages_11, stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  stdenv = llvmPackages_11.stdenv;
  version = "5.9-rc2";
  extraMeta.branch = "5.9";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  src = fetchFromGitHub {
    owner = "kloenk";
    repo = "linux";
    rev = "cc175e9a774a4b758029c1e6ca69db00b5e19fdc";
    sha256 = "sha256-EYCVtEd2/t98d0UbmINlMoJuioRqD3ZxrSVMADm22SE=";
  };
  /*fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "19ma3bbr8k85nkchm9n7b1zxv5wsk4h7g6br0xs2fsp3mx2s3ngs";
  };*/

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];


} // (args.argsOverride or {}))
