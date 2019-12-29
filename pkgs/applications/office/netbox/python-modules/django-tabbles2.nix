{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
}:

buildPythonPackage rec {
  pname = "django-tables2";
  version = "2.2.1";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "jieter";
    repo = pname;
    rev = "c0b989486e042325a2c22fbe80d2c61d13181ba4";
    sha256 = "1azr6grffs69m2pgdq84w8i93xlym2wmirix44r7cgmcp8yhyi5w";
  };

  propagatedBuildInputs = [ django ];
  checkInputs = [ django ];

  doCheck = false;

  meta = with lib; {
    description = "simplifies the task of turning sets of data into HTML tables";
    homepage = https://github.com/jieter/django-tables2;
    maintainers = with maintainers; [ kloenk ];
  };
}