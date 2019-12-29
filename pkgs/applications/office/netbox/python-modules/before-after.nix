{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, mock
, django
}:

buildPythonPackage rec {
  pname = "before_after";
  version = "1.0.0";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "c-oreills";
    repo = pname;
    rev = "f7b4935db989b984b7da7116a3bb8c9ef9f811b3";
    sha256 = "0hv4w95jnlzp9vdximl6bb27fyi75001jhvsbs0ikkd8amq8iaj7";
  };

  propagatedBuildInputs = [ mock django ];
  checkInputs = [ mock ];

  checkPhase = "${python.interpreter} run_tests.py";

  doCheck = false;

  meta = with lib; {
    description = "before_after provides utilities to help test race conditions";
    homepage = https://github.com/c-oreills/before_after;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kloenk ];
  };
}