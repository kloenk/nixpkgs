{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, pytz
}:

buildPythonPackage rec {
  pname = "django-timezone-field";
  version = "4.0";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "mfogel";
    repo = pname;
    rev = "915a51a5167dca1f25a2365addc3d74c0ffdf82b";
    sha256 = "0wzkx3y3zpq1mrxml7v9v4n5d13bvd4idm7f7n4v55yyqpdg94ls";
  };

  propagatedBuildInputs = [ django pytz ];
  checkInputs = [ django pytz ];

  doCheck = false;

  meta = with lib; {
    description = "A Django app providing database and form fields for pytz timezone objects";
    homepage = https://github.com/mfogel/django-timezone-field;
    license = licenses.bsd2;
    maintainers = with maintainers; [ kloenk ];
  };
}