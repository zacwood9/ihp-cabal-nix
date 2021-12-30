let
    ihp = builtins.fetchGit {
        url = "https://github.com/digitallyinduced/ihp.git";
        ref = "refs/tags/v0.17.0";
    };
    haskellLib = pkgs.haskell.lib;
    manualOverrides = haskellPackagesNew: haskellPackagesOld:
      {
        # This function is called for building each haskell package.
        # By overriding it here, we can pass in custom settings globally.
        mkDerivation = args: haskellPackagesOld.mkDerivation (args // {
          enableLibraryProfiling = true;
          enableExecutableProfiling = true;
          doCheck = false;
          doHaddock = false;
          doHoogle = false;
        });

        # We don't want to enable profiling for build tools.
        cabal2nix = haskellLib.disableLibraryProfiling (haskellLib.disableExecutableProfiling haskellPackagesOld.cabal2nix);
        hackage2nix = haskellLib.disableLibraryProfiling (haskellLib.disableExecutableProfiling haskellPackagesOld.hackage2nix);

        # Marked broken, but works fine.
        contiguous = haskellLib.unmarkBroken haskellPackagesOld.contiguous;
      };

    additionalNixpkgsOptions = { allowUnfree = true; };

    pkgs = import "${toString ihp}/NixSupport/make-nixpkgs-from-options.nix" {
        inherit ihp manualOverrides additionalNixpkgsOptions;
        haskellPackagesDir = ./Config/nix/haskell-packages/.;
    };

    haskellPackages = pkgs.haskell.packages.ghc8107;
    package = isProd:
      (haskellPackages.callCabal2nixWithOptions
        "App" # cabal file name
        ./.   # source directory
        (if isProd then "--flag Prod" else "")  # cabal flags
        {} # additional options
      ).overrideAttrs (oldAttrs: {
        preBuild = (if (builtins.hasAttr "preBuild" oldAttrs) then oldAttrs.preBuild else "") + "${haskellPackages.ihp}/bin/build-generated-code";
        installPhase = oldAttrs.installPhase + ''
          mkdir -p $out/IHP $out/static

          cp -r $src/static $out
          cp -r ${haskellPackages.ihp}/lib/IHP/static $out/IHP
          '';
      });
in
  if pkgs.lib.inNixShell
    then
      haskellPackages.shellFor {
        packages = p: [
          (package false)
        ];
        buildInputs = with haskellPackages; [
          pkgs.cabal-install
          pkgs.postgresql

          ihp
        ];
        withHoogle = true;
      }
    else
      (package true)
