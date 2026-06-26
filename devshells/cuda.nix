{ nixpkgs }:

let
  system = "x86_64-linux";

  pkgsCuda = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      cudaSupport = true;
      cudaCapabilities = [ "8.6" ]; # RTX 3060
    };
  };
in
pkgsCuda.mkShell {
  packages = [
    pkgsCuda.cudaPackages.cuda_nvcc
    pkgsCuda.cudaPackages.cuda_cudart
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
  '';
}
