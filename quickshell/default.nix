# We just need to pass down the arguments
{ pkgs, quickshell, script, ... }: script { inherit pkgs quickshell; }
