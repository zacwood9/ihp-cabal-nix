# See https://ihp.digitallyinduced.com/Guide/package-management.html
{ ihp, additionalNixpkgsOptions, manualOverrides, ... }:
import "${toString ihp}/NixSupport/make-nixpkgs-from-options.nix" {
    ihp = ihp;
    haskellPackagesDir = ./haskell-packages/.;
    additionalNixpkgsOptions = additionalNixpkgsOptions;
    inherit manualOverrides;
}
