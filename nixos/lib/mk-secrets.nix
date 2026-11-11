/**
    # Description
    Helper function to construct secret file definitions.

    # Inputs
    `secretDir`
        A string relative path that points the directory that contains secret files.

    `publicKeys`
        A list of public keys used to encrypt secrets.

    `fileNames`
        A list of file names of secrets in `secretDir` that is referred by other parts of this directory.

    # Type
    ```
    String -> [ String ] -> [ String ] -> AttrSet
    ```
*/
secretDir: publicKeys: fileNames: let
    # Construct the file paths
    filePaths = map (fileName: "${secretDir}/${fileName}") fileNames;

    # Construct a list of key-value pairs
    keyValuePairs = map (name: {
        inherit name;

        # Construct the secret file definition
        value.publicKeys = publicKeys;
        value.armor = true; # Ensure files are output in Base64 PEM text (useful for more readable diffs)
    }) filePaths;
in
# Unfold the list into a attribute set
builtins.listToAttrs keyValuePairs
