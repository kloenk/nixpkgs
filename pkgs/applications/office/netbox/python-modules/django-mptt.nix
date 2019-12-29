{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, django-js-asset
}:

buildPythonPackage rec {
  pname = "django-mptt";
  version = "0.10.0";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "django-mptt";
    repo = pname;
    rev = "af75aba730ebca305e2579da3498738bc3600256";
    sha256 = "0zglljzmn3gbqvgf6likk74sblxhr4xrlgwpgqphnq8lwg45l97g";
  };

  propagatedBuildInputs = [ django django-js-asset ];
  checkInputs = [ django ];

  doCheck = false;

  meta = with lib; {
    description = "Utilities for implementing Modified Preorder Tree Traversal with your Django Models and working with trees of Model instances";
    homepage = https://github.com/django-mptt/django-mptt;
    maintainers = with maintainers; [ kloenk ];
  };
}