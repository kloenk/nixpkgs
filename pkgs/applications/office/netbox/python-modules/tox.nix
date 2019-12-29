{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pluggy
, py
, six
, virtualenv
, setuptools_scm
, toml
, filelock
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "tox";
  version = "3.14.1";

  buildInputs = [ setuptools_scm importlib-metadata ];
  propagatedBuildInputs = [ importlib-metadata packaging pluggy py six virtualenv toml filelock ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l6hsaksq78mwd2ansnmd8lchzgyfvcxysmm0w3bgsf1md03xymw";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = https://tox.readthedocs.io/;
    license = licenses.mit;
  };
}