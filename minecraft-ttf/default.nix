{
    lib,
    stdenvNoCC,
    fetchurl,
    writeShellScript,

    pythonBuildEnv,
    installFonts,

    minecraft-ttf,
    version-menifest,
    agl-aglfn,

    # Flags. See https://github.com/tryashtar/minecraft-ttf#optional-parameters for more information.
    version ? "latest",
    identifiers ? [ "minecraft:default" ],
    styles ? [ "regular" ],
    color ? "auto",
    char-range ? "00000-fffff",
    unifont-chars ? "",
    option-uniform ? false,
    option-jp ? false,

    # Build flags. These flags should not affect the final results
    cacheDir ? "cache", # Cache directory
    ...
}: let
    # Parse the version manifest
    manifest = builtins.fromJSON (builtins.readFile version-menifest);

    # Infer the target version that needs to be fetched & parse the JSON metadata
    targetVersion = if version == "latest" then manifest.latest.snapshot else version;
    targetVersionContent = lib.findFirst (version: version.id == targetVersion) null manifest.versions;

    # Fetch & parse client JSON metadata
    clientJson = fetchurl { inherit (targetVersionContent) url sha1; };
    clientJsonContent = builtins.fromJSON (builtins.readFile clientJson);

    # Fetch the client jar executable
    clientJar = fetchurl { inherit (clientJsonContent.downloads.client) url sha1; };

    # Fetch & parse the asset index JSON metadata
    assetIndex = fetchurl { inherit (clientJsonContent.assetIndex) url sha1; };
    assetIndexContent = builtins.fromJSON (builtins.readFile assetIndex);

    # Helper function to format asset install commands
    installAsset = asset: let
        # Extract the first 2 digit of the asset's SHA-1 hash string
        hashPrefix = builtins.substring 0 2 asset.hash;

        # Fetch asset objects required by Mojang's content-addressed storage scheme
        source = fetchurl {
            url = "https://resources.download.minecraft.net/${hashPrefix}/${asset.hash}";
            sha1 = asset.hash;
        };

        # Format the destination path
        destination = "${cacheDir}/assets/objects/${hashPrefix}/${asset.hash}";
    in
    "install -DT ${source} ${destination}";

    # Filter unused assets to prevent massive downloads
    fontObjects = lib.filterAttrs (path: _:
        lib.hasPrefix "minecraft/font/" path || # Font provider definition JSONs
        lib.hasPrefix "minecraft/textures/font/" path # Font textures and Unicode bitmap sheets
    ) assetIndexContent.objects;

    # Populate the asset objects directory in postPatch stage
    # Writing the commands to a shell scripts prevents bash argument exceeds the operating system's argument buffer size
    postPatchAssetsContent = lib.concatMapStringsSep "\n" installAsset (builtins.attrValues fontObjects);
    postPatchAssets = writeShellScript "post-patch-assets" postPatchAssetsContent;
in
stdenvNoCC.mkDerivation {
    # Specify package name and version
    pname = "minecraft-ttf";
    version = "1.5";

    # Declare derivation metadatas
    meta = {
        description = "Pixel-accurate and complete TrueType fonts from Minecraft: Java Edition, " +
            "generated automatically from the latest version of the game";
        homepage = "https://github.com/tryashtar/minecraft-ttf";
        license = lib.licenses.unfreeRedistributable; # This derivation extracts proprietary Mojang game assets
        platforms = lib.platforms.all;
    };

    # Declare the source code of the derivation
    src = minecraft-ttf;

    # Declare build-time dependencies
    nativeBuildInputs = [
        # Python build environment generated from pyproject.toml and uv.lock
        pythonBuildEnv

        # Automatic install fonts to the output folder
        installFonts
    ];

    # Copy the required assets to cache to bypass downloads
    postPatch = ''
        install -DT ${version-menifest}    ${cacheDir}/versions/version_manifest_v2.json
        install -DT ${clientJson}          ${cacheDir}/versions/${targetVersion}/${targetVersion}.json
        install -DT ${clientJar}           ${cacheDir}/versions/${targetVersion}/${targetVersion}.jar
        install -DT ${assetIndex}          ${cacheDir}/assets/indexes/${clientJsonContent.assetIndex.id}.json
        install -DT ${agl-aglfn}/aglfn.txt ${cacheDir}/aglfn.txt

        # Populate the asset objects directory
        ${postPatchAssets}
    '';

    # Generate the font files from provided Minecraft jar executable
    buildPhase = ''
        runHook preBuild

        python src/main.py vanilla generate ${lib.escapeShellArg targetVersion} \
            --identifiers ${lib.escapeShellArgs identifiers} \
            --styles ${lib.escapeShellArgs styles} \
            --color ${lib.escapeShellArg color} \
            --chars ${lib.escapeShellArg char-range} \
            --unifont-chars ${lib.escapeShellArg unifont-chars} \
            ${lib.optionalString option-uniform "--option-uniform"} \
            ${lib.optionalString option-jp "--option-jp"} \
            --cache ${lib.escapeShellArg cacheDir}

        runHook postBuild
    '';
}
