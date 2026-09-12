{
    lib,
    fetchurl,
    runCommand,

    version-menifest,
    version ? "latest",
    assetBaseUrl ? "https://resources.download.minecraft.net",
    ...
}: let
    # Helper function to parse a JSON file
    readJSON = file: builtins.fromJSON (builtins.readFile file);

    # Helper function to fetch a file from a attribute set containing `url` and `sha1`
    fetch = metadata: fetchurl { inherit (metadata) url sha1; };

    # helper function to format install commands
    install = source: destination: ''
        mkdir -p $(dirname $out/${destination})
        ln -s ${source} $out/${destination}
        echo 'Prefetched ${destination}'
    '';

    # Helper function to format asset install commands
    installAsset = asset: let
        # Extract the first 2 digit of the asset's SHA-1 hash string
        hashPrefix = builtins.substring 0 2 asset.hash;

        # Fetch asset objects required by Mojang's content-addressed storage scheme
        source = fetchurl {
            url = "${assetBaseUrl}/${hashPrefix}/${asset.hash}";
            sha1 = asset.hash;
        };
    in
    install source "assets/objects/${hashPrefix}/${asset.hash}";

    # Parse the version manifest
    manifest = readJSON version-menifest;

    # Infer the target version that needs to be fetched & parse the JSON metadata
    targetVersion = if version == "latest" then manifest.latest.snapshot else version;
    targetVersionContent = lib.findFirst (version: version.id == targetVersion) null manifest.versions;

    # Fetch & parse client JSON metadata
    clientJson = fetch targetVersionContent;
    clientJsonContent = readJSON clientJson;

    # Fetch the client jar executable
    clientJar = fetch clientJsonContent.downloads.client;

    # Fetch & parse the asset index JSON metadata
    assetIndex = fetch clientJsonContent.assetIndex;
    assetIndexContent = readJSON assetIndex;

    # Filter unused assets to prevent massive downloads
    fontObjects = lib.filterAttrs (path: _:
        lib.hasPrefix "minecraft/font/" path || # Font provider definition JSONs
        lib.hasPrefix "minecraft/textures/font/" path # Font textures and Unicode bitmap sheets
    ) assetIndexContent.objects;
in
# Populate the cache derivation
runCommand "minecraft-ttf-cache" { } (
    lib.concatMapStrings installAsset (builtins.attrValues fontObjects)
    + install version-menifest "versions/version_manifest_v2.json"
    + install clientJson "versions/${targetVersion}/${targetVersion}.json"
    + install clientJar "versions/${targetVersion}/${targetVersion}.jar"
    + install assetIndex "assets/indexes/${clientJsonContent.assetIndex.id}.json"
)
