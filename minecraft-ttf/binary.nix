{
    lib,
    fetchpatch,
    rustPlatform,

    minecraft-ttf,

    # Override options
    manifestPath ? "minecraft-ttf", # Specify the path to the Cargo.toml & Cargo.lock file relative to repository root
    ...
}: rustPlatform.buildRustPackage {
    # Specify package name and version
    pname = "minecraft-ttf-bin";
    version = "1.6";

    # Declare derivation metadatas
    meta = {
        description = "Pixel-accurate and complete TrueType fonts from Minecraft: Java Edition, "
        + "generated automatically from the latest version of the game";
        homepage = "https://github.com/tryashtar/minecraft-ttf";
        license = lib.licenses.unfreeRedistributable; # This derivation extracts proprietary Mojang game assets
        platforms = lib.platforms.all;
        mainProgram = "minecraft-ttf";
    };

    # Declare the source code of the derivation
    src = minecraft-ttf;

    # Specify the path to the Cargo manifest
    cargoRoot = manifestPath;
    buildAndTestSubdir = manifestPath;

    # Specify Cargo lock file
    cargoLock.lockFile = "${minecraft-ttf}/${manifestPath}/Cargo.lock";

    # Temporarily fix tryashtar/minecraft-ttf#6
    patches = [
        # Apply patch in Pull Request tryashtar/minecraft-ttf#7 before it merges to upstream
        (fetchpatch {
            url = "https://github.com/tryashtar/minecraft-ttf/pull/7.patch";
            hash = "sha256-z4qG4ygOtVT1t6V/Pc1JkSvbXye7ZSiJ9btj9OonPgw=";
        })
    ];
}
