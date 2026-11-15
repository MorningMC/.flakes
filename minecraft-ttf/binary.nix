{
    lib,
    rustPlatform,

    pkg-config,
    zstd,
    aws-lc,

    minecraft-ttf
}: rustPlatform.buildRustPackage (finalAttrs: {
    # Specify package name and version
    pname = "minecraft-ttf-bin";
    version = "1.7";

    # Declare derivation metadatas
    meta = {
        description = "Pixel-accurate and complete TrueType fonts from Minecraft: Java Edition, "
        + "generated automatically from the latest version of the game";
        homepage = "https://github.com/tryashtar/minecraft-ttf";
        license = lib.licenses.unfree; # The upstream is unlicensed, default to ARR
        platforms = lib.platforms.all;
        mainProgram = "minecraft-ttf";
    };

    # Declare the source code of the derivation
    src = minecraft-ttf;

    # Specify the path to the Cargo manifest
    cargoRoot = "minecraft-ttf";
    buildAndTestSubdir = finalAttrs.cargoRoot;

    # Specify Cargo lock file
    cargoLock.lockFile = "${minecraft-ttf}/${finalAttrs.cargoRoot}/Cargo.lock";

    # Declare build-time dependencies
    nativeBuildInputs = [
        pkg-config
    ];

    # Declare runtime dependencies
    buildInputs = [
        zstd
        aws-lc
    ];
})
