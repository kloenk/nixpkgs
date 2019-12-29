{ stdenv
, pkgs
, lib
, fetchFromGitHub
, makeWrapper
, callPackage
, python3
, database_name ? "netbox"
, database_user ? "netbox"
, database_host ? "localhost"
, database_port ? ""
, database_max-age ? 300
, redis_host ? "localhost"
, redis_port ? 6379
}:

let 
  netbox = stdenv.mkDerivation rec {
    pname = "netbox";
    version = "2.6.9";

    src = fetchFromGitHub {
      owner = "netbox-community";
      repo = "netbox";
      rev = "v${version}";
      sha256 = "0iqdaiqqn5qgxx74ray63xr81n6ma4bhs86nbkb81xcaw84v88bg";
    };

    nativeBuildInputs = [ makeWrapper ];

    doCheck = true;
    dontInstall = true;

    pythonEnv      = python.withPackages (_: runtimePackages);
    pythonCheckEnv = python.withPackages (_: (runtimePackages ++ checkPackages));

    unpackPhase = ''
      srcDir=$out/share/netbox
      mkdir -p $srcDir
      cp -r --no-preserve=mode $src/* $src/LICENSE.txt $srcDir
    '';

    #postPatch = ''
    #  # django-cors-headers 3.x requires a scheme for allowed hosts
    #  substituteInPlace $out/share/paperless/paperless/settings.py \
    #    --replace "localhost:8080" "http://localhost:8080"
    #'';

    buildPhase = ''
      makeWrapper $pythonEnv/bin/python $out/bin/netbox \
        --add-flags $out/share/netbox/netbox/manage.py
      makeWrapper $pythonEnv/bin/python $out/bin/generate_secret_key \
        --add-flags $out/share/netbox/netbox/generate_secret_key.py
      
      # configuration
      cat >$out/share/netbox/netbox/netbox/configuration.py <<EOL
      import os

      ALLOWED_HOSTS = [ '127.0.0.1', os.environ['ALLOWED_HOSTS'] ]

      DATABASE = {
        'NAME': '${database_name}',               # Database name
        'USER': '${database_user}',               # PostgreSQL username
        'PASSWORD': os.environ["DATABASE_PASSWORD"], # PostgreSQL password
        'HOST': '${database_host}',            # Database server
        'PORT': '${toString database_port}',                     # Database port (leave blank for default)
        'CONN_MAX_AGE': ${toString database_max-age},            # Max database connection age
      }

      REDIS = {
        'HOST': '${redis_host}',
        'PORT': ${toString redis_port},
        'PASSWORD': os.environ["REDIS_PASSWORD"],
        'DATABASE': 0,
        'CACHE_DATABASE': 1,
        'DEFAULT_TIMEOUT': 300,
        'SSL': False,
      }

      SECRET_KEY = os.environ["SECRET_KEY"]
      EOL
    '';

    #buildPhase = let
    #  extraBin = lib.makeBinPath [ ];
    #in ''
    #  ${python.interpreter} -m compileall $srcDir
    #  makeWrapper $pythonEnv/bin/python $out/bin/netbox \
    #    --set PATH ${extraBin} --add-flags $out/share/netbox/manage.py
    #'';
    #  # A shell snippet that can be sourced to setup a paperless env
    #  cat > $out/share/paperless/setup-env.sh <<EOF
    #  export PATH="$pythonEnv/bin:${extraBin}''${PATH:+:}$PATH"
    #  export paperlessSrc=$out/share/paperless
    #  EOF


    #passthru = {
    #  withConfig = callPackage ./withConfig.nix {};
    #  inherit python runtimePackages checkPackages tesseract;
    #};

    meta = with lib; {
      description = "An IPAM and DCIM management system";
      homepage = https://netbox.readthedocs.io/en/stable;
      #license = licenses.apache2withPackages;
      maintainers = [ maintainers.kloenk ];
    };
  };

  requirements = import ./requirements.nix { inherit pkgs; };

  python = python3.override rec {
    packageOverrides = self: super: {
      # netbox only supports Django 2.2
      django = python3.pkgs.django_2_2;
      # These are pre-release versions, hence they are private to this pkg
      django_cacheops = self.callPackage ./python-modules/django-cacheops.nix {};
      django-debug-toolbar = self.callPackage ./python-modules/django-debug-toolbar.nix {};
      django-mptt = self.callPackage ./python-modules/django-mptt.nix {};
      #django-prometheus
      django-rq = self.callPackage ./python-modules/django-rq.nix {};
      django-tables2 = self.callPackage ./python-modules/django-tabbles2.nix {};
      django-taggit-serializer = self.callPackage ./python-modules/django-taggit-serializer.nix {};
      django-timezone-field = self.callPackage ./python-modules/django-timezone-field.nix {};
      drf-yasg = self.callPackage ./python-modules/drf-yasg.nix {};
      py-gfm = self.callPackage ./python-modules/py-gfm.nix {};
      markdown = self.callPackage ./python-modules/markdown.nix {};
      before_after = self.callPackage ./python-modules/before-after.nix {};
      django-filter = self.callPackage ./python-modules/django-filter.nix {};
      tox = self.callPackage ./python-modules/tox.nix {};
      django-crispy-forms = self.callPackage ./python-modules/django-crispy-forms.nix {};
      #coreapi = self.callPackage ./requirements.nix {};
      #crispy = self.callPackage ./python-modules/crispy.nix {};
      coreapi = requirements.packages."coreapi";
      django-js-asset = requirements.packages."django-js-asset";
      django-prometheus = requirements.packages."django-prometheus";
    };
  };

  runtimePackages = with python.pkgs; [
    django
    django_cacheops
    django-cors-headers
    django-debug-toolbar
    django-filter
    django-mptt
    django-prometheus
    django-rq
    django-tables2
    django_taggit
    django-taggit-serializer
    django-timezone-field
    djangorestframework
    drf-yasg
    graphviz
    jinja2
    #markdown
    netaddr
    pillow
    psycopg2
    py-gfm
    pycryptodome
    python-dotenv
    django_extensions
    django-crispy-forms
    #crispy
  ];

  checkPackages = with python.pkgs; [

  ];
in
  netbox