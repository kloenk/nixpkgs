{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, coverage
, twine
, wheel
, pytest
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-crispy-forms";
  version = "1.8.1";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = pname;
    rev = "baf94397a011b3f15a9899097234caa68b86a65e";
    sha256 = "1h74c6lw3izmdbm1silbar9ji728as2m4q1qn8b5pgqj2ahqmm32";
  };

  propagatedBuildInputs = [ django coverage twine wheel pytest pytest-django ];
  checkInputs = [ django coverage twine wheel pytest pytest-django ];

  doCheck = false;
  #checkPhase = "${python.interpreter} run_tests.py";

  meta = with lib; {
    description = "A slick app that supports automatic or manual queryset caching and automatic granular event-driven invalidation";
    homepage = https://github.com/Suor/django-cacheops;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kloenk ];
  };
}