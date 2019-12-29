{
  lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, django
, ruamel_yaml
, coreapi
, inflection
, six
, packaging
, djangorestframework
}:

buildPythonPackage rec {
  pname = "drf-yasg";
  version = "1.17.0";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "axnsan12";
    repo = pname;
    rev = "13311582ea67da80204176211319b0a715802568";
    sha256 = "16kn9ccj5hm0pi351a67cpcq2rr29f0vdny99ry4mfmjibspxv7b";
  };

  propagatedBuildInputs = [
    django
    ruamel_yaml
    coreapi
    inflection
    six
    packaging
    djangorestframework
  ];
  checkInputs = [ django ];

  doCheck = false;

  meta = with lib; {
    description = "A slick app that supports automatic or manual queryset caching and automatic granular event-driven invalidation";
    homepage = https://github.com/Suor/django-cacheops;
    license = licenses.bsd3;
    maintainers = with maintainers; [ kloenk ];
  };
}