{
  description = "Aporetic Nerd Font - A patched version of Protesilaos' Aporetic font";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
      {
        packages = forAllSystems (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
            {
              default = self.packages.${system}.aporetic-nerd-font;
              
              aporetic-nerd-font = pkgs.stdenvNoCC.mkDerivation {
                pname = "aporetic-nerd-font";
                version = "1.0.0";
                
                src = ./.;
                
                dontBuild = true;
                
                installPhase = ''
              runHook preInstall
              
              install -Dm644 *.ttf -t $out/share/fonts/truetype
              
              runHook postInstall
            '';
                
                meta = with pkgs.lib; {
                  description = "Aporetic Nerd Font - Sans and Serif monospace fonts with Nerd Font icons";
                  homepage = "https://github.com/Echinoidea/Aporetic-Nerd-Font";
                  license = licenses.ofl;
                  platforms = platforms.all;
                  maintainers = [ ];
                };
              };
            });
      };
}
