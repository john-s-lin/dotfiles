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
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      zen-browser,
      nix-darwin,
      ...
    }@inputs:
    let
      mkUserConfig =
        {
          username,
          hostKey,
          system,
        }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              system
              username
              hostKey
              ;
          };
          home-manager.users.${username} = {
            imports = [
              ./hosts/${hostKey}/home.nix
            ];
          };
        };

      mkNixosSystem =
        {
          hostKey,
          hostname,
          system,
          username,
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              system
              username
              hostname
              ;
          };
          modules = [
            ./hosts/${hostKey}/configuration.nix
            home-manager.nixosModules.home-manager
            (mkUserConfig { inherit hostKey system username; })
          ];
        };

      mkDarwinSystem =
        {
          hostKey,
          hostname ? null,
          system,
          username,
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs system username;
          };
          modules = [
            ./hosts/${hostKey}/configuration.nix
            home-manager.darwinModules.home-manager
            (mkUserConfig { inherit hostKey system username; })
          ]
          ++ nixpkgs.lib.optional (hostname != null) {
            networking.hostName = hostname;
          };
        };

      mkStandaloneHome =
        {
          homeModule,
          hostKey,
          hostname ? null,
          system,
          username,
          home ? "/home/${username}",
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ homeModule ];
          extraSpecialArgs = {
            inherit
              inputs
              username
              system
              hostname
              hostKey
              home
              ;
          };
        };
    in
    {
      nixosConfigurations = {
        "john-tpd-05" = mkNixosSystem {
          hostKey = "john-tpd-05";
          hostname = "john-tpd-05";
          username = "john";
          system = "x86_64-linux";
        };
      };

      darwinConfigurations = {
        "john-mba-03" = mkDarwinSystem {
          hostKey = "john-mba-03";
          hostname = "john-mba-03";
          system = "aarch64-darwin";
          username = "john";
        };

        "john-mbp-04" = mkDarwinSystem {
          hostKey = "john-mbp-04";
          hostname = "john-mbp-04";
          system = "x86_64-darwin";
          username = "john";
        };

        "work-mbp-01" = mkDarwinSystem {
          hostKey = "work-mbp-01";
          system = "aarch64-darwin";
          username = "johnslin";
        };
      };

      # VPS Home-Manager only
      homeConfigurations = {
        "john@ajax" = mkStandaloneHome {
          homeModule = ./hosts/ajax/john/home.nix;
          hostKey = "ajax";
          hostname = "ajax";
          username = "john";
          system = "aarch64-linux";
        };
        "claw@ajax" = mkStandaloneHome {
          homeModule = ./hosts/ajax/claw/home.nix;
          hostKey = "ajax";
          hostname = "ajax";
          username = "claw";
          system = "aarch64-linux";
        };

        # Raspberry Pi - DietPi Home-Manager only
        "dietpi@apollo" = mkStandaloneHome {
          homeModule = ./hosts/apollo/dietpi/home.nix;
          hostKey = "apollo";
          hostname = "apollo";
          username = "dietpi";
          system = "aarch64-linux";
        };
        "dietpi@atlas" = mkStandaloneHome {
          homeModule = ./hosts/atlas/dietpi/home.nix;
          hostKey = "atlas";
          hostname = "atlas";
          username = "dietpi";
          system = "aarch64-linux";
        };

        "johnslin@nimbus" = mkStandaloneHome {
          homeModule = ./hosts/nimbus/home.nix;
          hostKey = "nimbus";
          username = "johnslin";
          system = "x86_64-linux";
          home =
            let
              h = builtins.getEnv "HOME";
            in
            if h != "" then h else "/home/johnslin";
        };
      };
    };
}
