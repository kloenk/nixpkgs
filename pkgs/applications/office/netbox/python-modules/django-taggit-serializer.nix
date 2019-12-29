{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, wheel
, six
, django_taggit
}:

buildPythonPackage rec {
  pname = "django-taggit-serializer";
  version = "4.2";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "glemmaPaul";
    repo = pname;
    rev = "ee1b0505d72fce6810241627aacbe3844b4cfd83";
    sha256 = "108z2vl05jpyrqvl0m6r2z9hdazl3bfn8i7fq8j1df4w1zcrywfl";
  };

  propagatedBuildInputs = [ django six wheel django_taggit ];
  checkInputs = [ django six wheel django_taggit ];

  checkPhase = "${python.interpreter} runtests.py";

  doCheck = false;

  meta = with lib; {
    description = "The Django Taggit Serializer Created for the Django REST Framework";
    homepage = https://github.com/glemmaPaul/django-taggit-serializer;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kloenk ];
  };
}