{
	lib,
	callPackage,
	pythonInterpreters,

	pyproject-nix,
	uv2nix,
	minecraft-ttf,
	...
}: let
	# Load a uv workspace
	workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = minecraft-ttf; };

	# Find a compatible Python version
	python = lib.head (pyproject-nix.lib.util.filterPythonInterpreters {
		inherit (workspace) requires-python;
		inherit pythonInterpreters;
	});

	# Build the Python package set from the workspace
	pythonBase = callPackage pyproject-nix.build.packages { inherit python; };
	pythonSet = pythonBase.overrideScope (workspace.mkPyprojectOverlay {
		sourcePreference = "wheel"; # Prefer downloading packages as binary wheels
	});
in
pythonSet.mkVirtualEnv "build-env" workspace.deps.default
