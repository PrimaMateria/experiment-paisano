{
  inputs = {
    paisano = {
      url = "github:divnix/paisano";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = { paisano, self, ... }@inputs:
    paisano.growOn
      {
        inherit inputs;
        systems = [ "x86_64-linux" "aarch64-linux" ];
        cellsFrom = ./cells;
        cellBlocks = [
          {
            name = "fooblock";
            type = "experiment";
          }
          {
            name = "barblock";
            type = "experiment";
          }
        ];
      }
      {
        product = {


          cell = paisano.harvest self [ "cell" ];
          block = paisano.harvest self [ "cell" "fooblock" ];
          foo = paisano.harvest self [ "cell" "fooblock" "foo" ];
          bar = paisano.harvest self [ "cell" "fooblock" "bar" ];

          cellPicked = paisano.pick self [ "cell" ];
          winnow = paisano.winnow
            (field: value: field != "baz" && value !=
              null)
            self [ "cell" "fooblock" ];
        };
      };

  # find . -name "*.nix" | entr -c -s 'nix eval .#product | alejandra --quiet'
  # find . -name "*.nix" | entr -c -s 'nix eval .#product --json | jq'
}

