{
    lib,
    stdenvNoCC,
    fetchurl,
    writeShellScript,

    installFonts,

    minecraft-ttf-bin,
    minecraft-ttf-cache,

    version ? "latest",
    assetsCache ? minecraft-ttf-cache.override { inherit version; },

    # Flags. See https://github.com/tryashtar/minecraft-ttf#optional-parameters for more information.
    identifiers ? [ "default" ],
    resourcePacks ? [ ],
    fontName ? null,
    fontCreated ? null,
    fontModified ? null,
    styles ? [ "regular" ],
    color ? "auto",
    charRange ? "00000-fffff",
    unifontCharRange ? "",
    useUniformFont ? false,
    useJapaneseGlyph ? false
}: stdenvNoCC.mkDerivation {
    # Specify package name and version
    pname = "minecraft-ttf";
    version = "1.7";

    # Declare derivation metadatas
    meta = {
        description = "Pixel-accurate and complete TrueType fonts from Minecraft: Java Edition, "
        + "generated automatically from the latest version of the game";
        homepage = "https://github.com/tryashtar/minecraft-ttf";
        license = lib.licenses.unfree; # This derivation extracts proprietary Mojang game assets
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

        # Generate for every identifiers
        for identifier in ${lib.escapeShellArgs identifiers}; do
            minecraft-ttf generate \
                ${if version == "latest" then "--jar-latest" else "--jar-vanilla ${version}"} \
                --identifier "$identifier" \
                ${lib.optionalString (resourcePacks != [ ]) "--packs ${lib.escapeShellArgs resourcePacks}"} \
                ${lib.optionalString (fontName != null) "--font-name ${lib.escapeShellArg fontName}"} \
                ${lib.optionalString (fontCreated != null) "--font-created ${lib.escapeShellArg fontCreated}"} \
                ${lib.optionalString (fontModified != null) "--font-modified ${lib.escapeShellArg fontModified}"} \
                --styles ${lib.escapeShellArg (lib.concatStringsSep "," styles)} \
                --color ${lib.escapeShellArg color} \
                --chars ${lib.escapeShellArg charRange} \
                --unifont-chars ${lib.escapeShellArg unifontCharRange} \
                ${lib.optionalString useUniformFont "--option-uniform"} \
                ${lib.optionalString useJapaneseGlyph "--option-jp"} \
                --cache ${assetsCache}
        done

        runHook postBuild
    '';
}
