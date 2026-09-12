{
    lib,
    stdenvNoCC,
    fetchurl,
    writeShellScript,

    installFonts,

    minecraft-ttf-bin,
    minecraft-ttf-cache,

    # Flags. See https://github.com/tryashtar/minecraft-ttf#optional-parameters for more information.
    version ? "latest",
    identifiers ? [ "default" ],
    styles ? [ "regular" ],
    color ? "auto",
    char-range ? "00000-fffff",
    unifont-chars ? "",
    option-uniform ? false,
    option-jp ? false,
    ...
}: stdenvNoCC.mkDerivation {
    # Specify package name and version
    pname = "minecraft-ttf";
    version = "1.6";

    # Declare derivation metadatas
    meta = {
        description = "Pixel-accurate and complete TrueType fonts from Minecraft: Java Edition, "
        + "generated automatically from the latest version of the game";
        homepage = "https://github.com/tryashtar/minecraft-ttf";
        license = lib.licenses.unfreeRedistributable; # This derivation extracts proprietary Mojang game assets
        platforms = lib.platforms.all;
    };

    # This derivation does not have a source
    dontUnpack = true;

    # Declare build-time dependencies
    nativeBuildInputs = [
        minecraft-ttf-bin # The built binary of the source code
        installFonts # Automatic install fonts to the output folder
    ];

    # Generate the font files from provided Minecraft jar executable
    buildPhase = ''
        runHook preBuild

        minecraft-ttf vanilla generate ${lib.escapeShellArg version} \
            --identifiers ${lib.escapeShellArgs identifiers} \
            --styles ${lib.escapeShellArgs styles} \
            --color ${lib.escapeShellArg color} \
            --chars ${lib.escapeShellArg char-range} \
            --unifont-chars ${lib.escapeShellArg unifont-chars} \
            ${lib.optionalString option-uniform "--option-uniform"} \
            ${lib.optionalString option-jp "--option-jp"} \
            --cache ${minecraft-ttf-cache.override { inherit version; }}

        runHook postBuild
    '';
}
