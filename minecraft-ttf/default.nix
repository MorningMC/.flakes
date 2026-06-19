{
	lib,
	stdenvNoCC,
	fetchurl,

	python313,
	installFonts,

	minecraft-ttf,
	version-menifest,
	client-jar ? null,
	agl-aglfn,
	...
}: let
	# Parse the version manifest
	manifest = builtins.fromJSON (builtins.readFile version-menifest);

	# Fetch the latest snapshot Jar executable if clientJar is not specified
	clientJar = if client-jar != null then client-jar else let
		# Get the latest snapshot JSON metadata from the version manifest
		latestSnapshot = lib.findFirst (version: version.id == manifest.latest.snapshot) null manifest.versions;
		versionMetaDerivation = fetchurl { inherit (latestSnapshot) url sha1; };

		# Parse the version metadata
		versionMeta = builtins.fromJSON (builtins.readFile versionMetaDerivation);
	in
	fetchurl { inherit (versionMeta.downloads.client) url sha1; };
in
stdenvNoCC.mkDerivation {
	# Specify package name and version
	pname = "minecraft-ttf";
	version = "1.3";

	# Declare derivation metadatas
	meta = {
		description = "Pixel-accurate and complete TrueType fonts from Minecraft: Java Edition, " +
			"generated automatically from the latest version of the game";
		homepage = "https://github.com/tryashtar/minecraft-ttf";
		#license = lib.licenses.unfreeRedistributable; # This derivation extracts proprietary Mojang game assets
		license = lib.licenses.mit;
		platforms = lib.platforms.all;
	};

	# Declare the source code of the derivation
	src = minecraft-ttf;

	# Declare build-time dependencies
	nativeBuildInputs = [
		# Python environment with bundled required Python packages
		(python313.withPackages (ps: with ps; [ fonttools pillow pygame requests ]))

		# Automatic install fonts to the output folder
		installFonts
	];

	# Copy the required assets to cache to bypass downloads in main.py
	postPatch = ''
		mkdir -p cache

		cp ${version-menifest} cache/manifest.json
		cp ${clientJar} cache/minecraft-${manifest.latest.snapshot}.jar
		cp ${agl-aglfn}/aglfn.txt cache/aglfn.txt
	'';

	# Generate the font files from provided Minecraft Jar executable
	buildPhase = ''
		runHook preBuild
		python main.py
		runHook postBuild
	'';
}
