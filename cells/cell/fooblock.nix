{ inputs, cell }: { foo = "foo"; inherit (cell.barblock) bar; baz = "baz"; }

