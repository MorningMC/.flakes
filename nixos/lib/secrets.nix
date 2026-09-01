{
    /**
        # Description
        Helper function to construct the public keys to encrypt a secret file according to the target host machine or user.

        # Inputs
        `publicKeys`
            An attribute set where its keys represent either a host name of a machine or a user name, and its values is the public to
            encrypt secrets. In addition to that, a master key with attribute key "master" must present, which will be used to encrypt
            all secrets.

        `keys`
            A literal string "all" to include all public keys, or a list of attribute keys that match the keys in `publicKeys`.

        # Type
        ```
        mkKeys :: AttrSet -> (ListOf String | "all") -> ListOf String
        ```
    */
    mkKeys = publicKeys: keys: if keys == "all" then
        # Return all possible keys
        builtins.attrValues publicKeys
    else
        # Return the master key alongside the respective host keys
        # There are simpler approaches that involves nixpkgs.lib, but we don't have that
        map (index: publicKeys.${index}) (keys ++ [ "master" ]);

    /**
        # Description
        Helper function to construct secret file definitions.

        # Inputs
        `secretDir`
            A string relative path that points the directory that contains secret files.

        `publicKeys`
            A list of public keys used to encrypt secrets.

        `fileNames`
            a list of file names of secrets in `secretDir` that is referred by other parts of this directory.

        # Type
        ```
        mkSecrets :: String -> ListOf String -> ListOf String -> AttrSet
        ```
    */
    mkSecrets = secretDir: publicKeys: fileNames: let
        # Construct the file paths
        filePaths = map (fileName: "${secretDir}/${fileName}") fileNames;

        # Construct the secret file definition
        secretDefinition = {
            inherit publicKeys;
            armor = true; # Ensure files are output in Base64 PEM text (useful for more readable diffs)
        };

        # Construct a list of key-value pairs
        keyValuePairs = map (key: { name = key; value = secretDefinition; }) filePaths;
    in
    # Unfold the list into a attribute set
    builtins.listToAttrs keyValuePairs;
}
