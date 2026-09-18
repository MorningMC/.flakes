{
    lib,
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
}
