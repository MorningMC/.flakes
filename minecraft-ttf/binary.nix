{
    lib,
    rustPlatform,
    minecraft-ttf,
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
    sourceRoot = "source/minecraft-ttf";

    # Provide the hash for the Cargo dependencies
    cargoHash = "sha256-RMbj/fyQKOPj/BlToAORvslTaz4yfSFyzj049szId1w=";
}
