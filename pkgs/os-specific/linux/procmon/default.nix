{ stdenv, kernel, bcc, fetchFromGitHub, cmake }:

assert stdenv.lib.versionAtLeast kernel.version "4.18";

stdenv.mkDerivation rec {
  pname = "procmon";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "ProcMon-for-Linux";
    rev = "1.0";
    sha256 = "sha256-9CcPjJEboDEqxOVRkA9vcZoy+mj+vIZezTW/hD/GEjg=";
  };

  nativeBuildInputs = [ bcc cmake ] ++ kernel.moduleBuildDependencies;

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  meta = with stdenv.lib; {
    description = "Procmon is a Linux reimagining of the classic Procmon tool from the Sysinternals suite of tools for Windows";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kloenk ];
  };
}
