# generated using pypi2nix tool (version: 2.0.0)
# See more at: https://github.com/nix-community/pypi2nix
#
# COMMAND:
#   pypi2nix -e coreapi -e django-js-asset -e django_prometheus
#

{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python3;
  };

  commonBuildInputs = [];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreterWithPackages = selectPkgsFn: pythonPackages.buildPythonPackage {
        name = "python3-interpreter";
        buildInputs = [ makeWrapper ] ++ (selectPkgsFn pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (selectPkgsFn pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };

      interpreter = interpreterWithPackages builtins.attrValues;
    in {
      __old = pythonPackages;
      inherit interpreter;
      inherit interpreterWithPackages;
      mkDerivation = args: pythonPackages.buildPythonPackage (args // {
        nativeBuildInputs = (args.nativeBuildInputs or []) ++ args.buildInputs;
      });
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "certifi" = python.mkDerivation {
      name = "certifi-2019.11.28";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz";
        sha256 = "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://certifi.io/";
        license = licenses.mpl20;
        description = "Python package for providing Mozilla's CA Bundle.";
      };
    };

    "chardet" = python.mkDerivation {
      name = "chardet-3.0.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz";
        sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/chardet/chardet";
        license = licenses.lgpl2;
        description = "Universal encoding detector for Python 2 and 3";
      };
    };

    "coreapi" = python.mkDerivation {
      name = "coreapi-2.3.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ca/f2/5fc0d91a0c40b477b016c0f77d9d419ba25fc47cc11a96c825875ddce5a6/coreapi-2.3.3.tar.gz";
        sha256 = "46145fcc1f7017c076a2ef684969b641d18a2991051fddec9458ad3f78ffc1cb";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."coreschema"
        self."itypes"
        self."requests"
        self."uritemplate"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/core-api/python-client";
        license = licenses.bsdOriginal;
        description = "Python client library for Core API.";
      };
    };

    "coreschema" = python.mkDerivation {
      name = "coreschema-0.0.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/93/08/1d105a70104e078718421e6c555b8b293259e7fc92f7e9a04869947f198f/coreschema-0.0.4.tar.gz";
        sha256 = "9503506007d482ab0867ba14724b93c18a33b22b6d19fb419ef2d239dd4a1607";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."jinja2"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/core-api/python-coreschema";
        license = licenses.bsdOriginal;
        description = "Core Schema.";
      };
    };

    "django-js-asset" = python.mkDerivation {
      name = "django-js-asset-1.2.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/81/d9/bbb15cf960142220a7a5ca38f2cbddd3ef6ad19f9efc6024670d44b43968/django-js-asset-1.2.2.tar.gz";
        sha256 = "c163ae80d2e0b22d8fb598047cd0dcef31f81830e127cfecae278ad574167260";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/matthiask/django-js-asset/";
        license = licenses.bsdOriginal;
        description = "script tag with additional attributes for django.forms.Media";
      };
    };

    "django-prometheus" = python.mkDerivation {
      name = "django-prometheus-1.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/08/fa/b4bba5fba8a383ec1ebc95ddb738203d07514ca87bf13e81d27fbe30542b/django-prometheus-1.1.0.tar.gz";
        sha256 = "bb2d4f8acd681fa5787df77e7482391017f0090c70473bccd2aa7cad327800ad";
};
      doCheck = false;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."prometheus-client"
        pkgs.python37Packages.pytestrunner
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/korfuri/django-prometheus";
        license = licenses.asl20;
        description = "Django middlewares to monitor your application with Prometheus.io.";
      };
    };

    "idna" = python.mkDerivation {
      name = "idna-2.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz";
        sha256 = "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };

    "itypes" = python.mkDerivation {
      name = "itypes-1.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d3/24/5e511590f95582efe64b8ad2f6dadd85c5563c9dcf40171ea5a70adbf5a9/itypes-1.1.0.tar.gz";
        sha256 = "c6e77bb9fd68a4bfeb9d958fea421802282451a25bac4913ec94db82a899c073";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/tomchristie/itypes";
        license = licenses.bsdOriginal;
        description = "Simple immutable types for python.";
      };
    };

    "jinja2" = python.mkDerivation {
      name = "jinja2-2.10.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/7b/db/1d037ccd626d05a7a47a1b81ea73775614af83c2b3e53d86a0bb41d8d799/Jinja2-2.10.3.tar.gz";
        sha256 = "9fe95f19286cfefaa917656583d020be14e7859c6b0252588391e47db34527de";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."markupsafe"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/jinja/";
        license = licenses.bsdOriginal;
        description = "A very fast and expressive template engine.";
      };
    };

    "markupsafe" = pkgs.python37Packages.markupsafe;

    "requests" = pkgs.python37Packages.requests;

    "prometheus-client" = python.mkDerivation {
      name = "prometheus-client-0.7.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b3/23/41a5a24b502d35a4ad50a5bb7202a5e1d9a0364d0c12f56db3dbf7aca76d/prometheus_client-0.7.1.tar.gz";
        sha256 = "71cd24a2b3eb335cb800c7159f423df1bd4dcd5171b234be15e3f31ec9f622da";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/prometheus/client_python";
        license = licenses.asl20;
        description = "Python client for the Prometheus monitoring system.";
      };
    };

    "uritemplate" = python.mkDerivation {
      name = "uritemplate-3.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz";
        sha256 = "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://uritemplate.readthedocs.org";
        license = licenses.bsdOriginal;
        description = "URI templates";
      };
    };

    "urllib3" = python.mkDerivation {
      name = "urllib3-1.25.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ad/fc/54d62fa4fc6e675678f9519e677dfc29b8964278d75333cf142892caf015/urllib3-1.25.7.tar.gz";
        sha256 = "f3c5fd51747d450d4dcf6f923c81f78f811aab8205fda64b0aba34a4e48b0745";
};
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://urllib3.readthedocs.io/";
        license = licenses.mit;
        description = "HTTP library with thread-safe connection pooling, file post, and more.";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  localOverrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [
        (let src = pkgs.fetchFromGitHub { owner = "nix-community"; repo = "pypi2nix-overrides"; rev = "db87933d87d9b3943cf636a49f16b76c9ea66db7"; sha256 = "1phiqh72dyg7qhkv15kdg4gjkx8rkywvs41j7liz5faj66ijlpv6"; } ; in import "${src}/overrides.nix" { inherit pkgs python; })
  ];
  paramOverrides = [
    (overrides { inherit pkgs python; })
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [localOverrides] else [] ) ++ commonOverrides ++ paramOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )