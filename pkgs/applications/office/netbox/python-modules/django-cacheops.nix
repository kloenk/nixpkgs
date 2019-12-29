{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, redis
, jinja2
, funcy
, six
, before_after
}:

buildPythonPackage rec {
  pname = "django-cacheops";
  version = "4.2";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "Suor";
    repo = pname;
    rev = "21aae96dd52e599ab3c2c13e5ad9e49d339ccdfa";
    sha256 = "075aggy67klacrkr582sagd0rjzv95camvj254mmrjkwhvaq8d2x";
  };

  propagatedBuildInputs = [ django redis jinja2 funcy six  ];
  checkInputs = [ django redis jinja2 funcy six before_after ];

  doCheck = false;
  #checkPhase = "${python.interpreter} run_tests.py";

  meta = with lib; {
    description = "A slick app that supports automatic or manual queryset caching and automatic granular event-driven invalidation";
    homepage = https://github.com/Suor/django-cacheops;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kloenk ];
  };
}
