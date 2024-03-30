{ lib, stdenv, fetchFromGitHub, cmake, ninja, python3, gcc, gcc-arm-embedded, pico-sdk }:

stdenv.mkDerivation rec {
  pname = "rpi-debugprobe";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "debugprobe";
    rev = "debugprobe-v${version}";
    hash = "sha256-jlrJMuVKuZ8Hl0YZ8B4kWyULu1JO5c7htjKY4CKcwD0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    python3
    gcc
    gcc-arm-embedded
  ];
  buildInputs = [ pico-sdk ];

  cmakeFlags = [
    "-DPICO_SDK_PATH=${pico-sdk}/lib/pico-sdk"
    "-DCMAKE_C_COMPILER=${gcc-arm-embedded}/bin/arm-none-eabi-gcc"
    "-DCMAKE_CXX_COMPILER=${gcc-arm-embedded}/bin/arm-none-eabi-g++"
  ];
}
