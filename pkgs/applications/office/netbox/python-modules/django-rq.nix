{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, redis
, rq
, mock
}:

buildPythonPackage rec {
  pname = "django-rq";
  version = "2.2.0";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "rq";
    repo = pname;
    rev = "f63b984f4bc1be7df39128c98c0ccdd89db0c226";
    sha256 = "16vbl4x0dj6nfw2qqxc3bmcxmp2irk6fwk1hdrzrj2zg3qaplc4r";
  };

  propagatedBuildInputs = [ django redis rq ];
  checkInputs = [ django redis rq mock ];

  doCheck = false;

  meta = with lib; {
    description = "Django integration with RQ, a Redis based Python queuing library";
    homepage = https://github.com/rq/django-rq;
    license = licenses.mit;
    maintainers = with maintainers; [ kloenk ];
  };
}