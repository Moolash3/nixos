{
  description = "NixOS: Hyprland (illogical-impulse) + NVIDIA + Mullvad";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # end-4's "Illogical Impulse" Hyprland dotfiles, packaged as a home-manager module.
    illogical-flake = {
      url = "github:Moolash3/illogical-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate Nix. NOTE: deliberately NO `inputs.nixpkgs.follows = "nixpkgs"`
    # here — Determinate recommends against it because following nixpkgs causes
    # cache misses for artifacts that would otherwise come from FlakeHub Cache.
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  outputs = { self, nixpkgs, home-manager, illogical-flake, determinate, ... }@inputs:
    let
      system = "x86_64-linux";

      # CHANGE THESE TWO to match your machine.
      username = "enfer";
      hostname = "nixos";
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        # Pass flake inputs + username down to the modules and to home.nix.
        specialArgs = { inherit inputs username hostname; };

        modules = [
          ./configuration.nix

          # Determinate Nix: replaces NixOS-managed upstream Nix with Determinate
          # Nix and manages Nix configuration itself.
          determinate.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs username; };
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    };
}
