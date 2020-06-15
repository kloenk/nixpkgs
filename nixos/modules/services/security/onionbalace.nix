{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.services.onionbalance;
in {
  options = {
    services.onionbalance = {
      enable = mkEnableOption "Onionbalance load balancer";

      settings = {
        type = types.attrs;
        default = { };
        example = {
          services = [{
            instances = [{
              address =
                "wmilwokvqistssclrjdi5arzrctn6bznkwmosvfyobmyv2fc3idbpwyd.onion";
              name = "node1";
            }];
            key =
              "/run/secrets/mvfqbrdcl2ldfkcr5q4577z6c6crujtj2bwfcvbfwlxvz3e53gg46sid.key";
          }];
        };
        description = ''
          Config file for onionbalance <xlink:href="https://onionbalance.readthedocs.io/en/latest">https://onionbalance.readthedocs.io/en/latest</link>.'';
      };

      verbosity = mkOption {
        type = types.enum [ "debug" "info" "warning" "error" "critical" ];
        default = "info";
        description = "Minimum verbosity level for logging.";
      };

      tor.controlPort = mkOption {
        type = types.port;
        default = config.services.tor.controlPort;
        description = "Tor controller port";
      };
    };
  };

  # implementation
  config = mkIf cfg.enable {

    services.tor.enable = true;

    systemd.services.onionbalance = {
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" "tor.service" ];

      serviceConfig = {
        User = "onionbalance";
        Group = "onionbalance";
      };

      script = let
        configFile =
          pkgs.writeText "config.json" (builtins.toJSON cfg.settings);
      in ''
        ${pkgs.onionbalance}/bin/onionbalance -v ${cfg.verbosity} -c ${configFile} -p ${
          toString cfg.tor.controlPort
        }
      '';
    };

    users.users.onionbalance = {
      description = "onionbalance Daemon User";
      createHome = false;
      extraGroups = [ "tor" ];
    };
  };
}
