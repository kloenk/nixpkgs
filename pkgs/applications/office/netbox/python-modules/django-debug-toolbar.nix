{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, jinja2
, coverage
, flake8
, html5lib
, isort
, selenium
, tox
, sphinx
, wheel
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "django-debug-toolbar";
  version = "2.1";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "84bf0965c5b132e6bc4ac1196d0acb7093c415e6";
    sha256 = "0drsyh6q6qcbrbc03vgw18s1rzf0syz2v09c5f1nnlgjg32ml63d";
  };

  propagatedBuildInputs = [ django tox importlib-metadata ]; # jinja2 funcy six before_after ];
  checkInputs = [
    django
    jinja2
    coverage
    flake8
    html5lib
    isort
    selenium
    tox
    sphinx
    wheel
  ];

  doCheck = false;

  meta = with lib; {
    description = "The Django Debug Toolbar is a configurable set of panels that display various debug information about the current request/response and when clicked, display more details about the panel's content";
    homepage = https://github.com/jazzband/django-debug-toolbar;
    maintainers = with maintainers; [ kloenk ];
  };
}