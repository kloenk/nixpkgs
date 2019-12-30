{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.netbox;
in
  {
    options = {
      services.netbox = {
        enable = mkEnableOption "netbox";

        port = mkOption {
          type = types.int;
          default = 12220;
          description = "The port to bind the (internal) netbox server to";
        };

        #dataDir = mkOption {
        #  type = types.str;
        #  default = "/var/lib/shelfie";
        #  description = "The directory in which to keep uploaded data";
        #};

        databasePass = mkOption {
          type = types.str;
          description = ''
            password for the database
          '';
        };

        redisPass = mkOption {
          type = types.str;
          description = ''
            password for the redis
          '';
        };

        secret = mkOption {
          type = types.str;
          description = ''
            netbox secret
          '';
        };

        user = mkOption {
          type = types.str;
          default = "netbox";
          description = ''
            User under which netbox runs
            If it is set to "netbox", a user will be created.
          '';
        };

        group = mkOption {
          type = types.str;
          default = "netbox";
          description = ''
            Group under which netbox runs
            If it is set to "netbox", a group will be created.
          '';
        };

        configureNginx = mkEnableOption "Configure nginx as reverse proxy for netbox";

        appDomain = mkOption {
          description = "Domain used to serve netbox";
          type = types.str;
          example = "netbox.example.org";
        };
      };
    };

    config = mkIf cfg.enable {

      #systemd.services.shelfie-init = {
      #  script = ''
      #    mkdir -p ${cfg.dataDir}
      #    chown ${cfg.user}:${cfg.group} ${cfg.dataDir}
      #  '';
      #  serviceConfig = {
      #    Type = "oneshot";
      #  };
      #  after = [ "network.target" ];
      #  wantedBy = [ "multi-user.target" ];
      #};

      systemd.services.netbox = {
        serviceConfig = {
          ExecStartPre = "${pkgs.netbox}/bin/netbox migrate";
          ExecStart = "${pkgs.netbox}/bin/netbox runserver 127.0.0.1:${toString(cfg.port)} --insecure";
          Restart = "always";
          RestartSec = "20s";
          User = cfg.user;
          Group = cfg.group;
        };
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment.DATABASE_PASSWORD = cfg.databasePass;
        environment.REDIS_PASSWORD = cfg.redisPass;
        environment.secret = cfg.secret;

      };

      services.nginx = lib.mkIf cfg.configureNginx {
        enable = true;
        virtualHosts."${cfg.appDomain}" = {
          locations."/".proxyPass = "http://127.0.0.1:${toString(cfg.port)}/";
          locations." = /" = {
            proxyPass = "http://127.0.0.1:${toString(cfg.port)}/";
          };
        };
      };

      users.users.netbox = mkIf (cfg.user == "netbox") {
        isSystemUser = true;
        inherit (cfg) group;
      };

      users.groups.netbox = mkIf (cfg.group == "netbox") { };

    };
  }
