{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, nose
, coverage
, pyyaml
#, pytidylib
, mkdocs
#, mkdocs-nature
}:

buildPythonPackage rec {
  pname = "markdown";
  version = "2.6.11";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "Python-Markdown";
    repo = pname;
    rev = "fc96b467832cfe4d7060017e439344b10c77a31b";
    sha256 = "0l4mjhyd5saj25pl3nydik4clxq94cmln1c6k0gc7q61sdp2pasz";
  };

  propagatedBuildInputs = [ django ];
  checkInputs = [ ];

  #checkPhase = "${python.interpreter} run-tests.py";
  doCheck = false;

  meta = with lib; {
    description = "This is a Python implementation of John Gruber's Markdown";
    homepage = https://github.com/Python-Markdown/markdown/tree/2.6.11;
    maintainers = with maintainers; [ kloenk ];
  };
}