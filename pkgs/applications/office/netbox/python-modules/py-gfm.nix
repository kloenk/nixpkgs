{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, coreapi
, markdown
}:

buildPythonPackage rec {
  pname = "py-gfm";
  version = "0.1.4";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "Zopieux";
    repo = pname;
    rev = "cd3a2eef17c7ae6cfb9eae269621e534368c726a";
    sha256 = "12ndvdcxr5wxfihl8w9n62zsc0s1c45w0ryw4c71bif87gz45x9r";
  };

  propagatedBuildInputs = [ django coreapi markdown ];
  checkInputs = [ ];

  #checkPhase = "${python.interpreter} test.py";
  doCheck = false;

  meta = with lib; {
    description = "Github-Flavored Markdown for Python-Markdown";
    homepage = https://github.com/zopieux/py-gfm;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kloenk ];
  };
}