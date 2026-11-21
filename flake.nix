# flake.nix
{
  description = "Infra for NixOS and nix-darwin on MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      zen-browser,
      nix-darwin,
      noctalia,
      ...
    }@inputs:
    let
      # hostDir is the directory under ./hosts that holds the host's
      # configuration.nix/home.nix; hostName is the flake key and the machine's
      # hostname. They differ on the Raspberry Pis, which share hosts/dietpi.
      mkUserConfig =
        { hostDir, username }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = { inherit inputs username; };
          home-manager.users.${username} = {
            imports = [ ./hosts/${hostDir}/home.nix ];
            home.stateVersion = nixpkgs.lib.mkDefault "25.05";
          };
        };

      mkNixosSystem =
        {
          hostDir,
          hostname,
          username,
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username hostname; };
          modules = [
            ./modules/cache.nix
            ./hosts/${hostDir}/configuration.nix
            home-manager.nixosModules.home-manager
            (mkUserConfig { inherit hostDir username; })
          ];
        };

      mkDarwinSystem =
        {
          hostDir,
          hostname ? null,
          system,
          username,
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = [
            ./modules/cache.nix
            ./hosts/${hostDir}/configuration.nix
            home-manager.darwinModules.home-manager
            (mkUserConfig { inherit hostDir username; })
          ]
          ++ nixpkgs.lib.optional (hostname != null) {
            networking.hostName = hostname;
          };
        };

      mkStandaloneHome =
        {
          hostDir,
          hostName,
          system,
          username,
          home ? "/home/${username}",
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./modules/cache.nix
            ./hosts/${hostDir}/home.nix
            {
              nix.package = nixpkgs.lib.mkDefault nixpkgs.legacyPackages.${system}.nix;
              home.username = username;
              home.homeDirectory = home;
              home.stateVersion = nixpkgs.lib.mkDefault "25.05";
            }
          ];
          extraSpecialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations = {
        "john-tpd-05" = mkNixosSystem {
          hostDir = "john-tpd-05";
          hostname = "john-tpd-05";
          username = "john";
        };
      };

      darwinConfigurations = {
        "john-mba-03" = mkDarwinSystem {
          hostDir = "john-mba-03";
          hostname = "john-mba-03";
          system = "aarch64-darwin";
          username = "john";
        };

        # No hostname: work-mbp-01 keeps the hostname IT assigned.
        "work-mbp-01" = mkDarwinSystem {
          hostDir = "work-mbp-01";
          system = "aarch64-darwin";
          username = "johnslin";
        };
      };

      # Keys are "${username}@${hostName}".
      homeConfigurations = builtins.listToAttrs (
        map
          (host: {
            name = "${host.username}@${host.hostName}";
            value = mkStandaloneHome host;
          })
          [
            {
              hostDir = "ajax";
              hostName = "ajax";
              username = "john";
              system = "aarch64-linux";
            }
            {
              hostDir = "dietpi";
              hostName = "apollo";
              username = "dietpi";
              system = "aarch64-linux";
            }
            {
              hostDir = "dietpi";
              hostName = "atlas";
              username = "dietpi";
              system = "aarch64-linux";
            }
            {
              hostDir = "nimbus";
              hostName = "nimbus";
              username = "johnslin";
              system = "x86_64-linux";
              # Work-managed cloudtop: HOME is not /home/johnslin.
              home =
                let
                  h = builtins.getEnv "HOME";
                in
                if h != "" then h else "/home/johnslin";
            }
          ]
      );
    };
}
