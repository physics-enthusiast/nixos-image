# Prebuilt NixOS Images

This repo builds NixOS disk images of various formats using Github Actions. They can be downloaded [here](https://github.com/physics-enthusiast/nixos-image/releases). The configuration built contains enabled QEMU guest-agent and cloud-init. If a different default configuration is desired: fork this repository, make edits to the contained configuration.nix file and wait for the workflow job to complete. Enable [read and write permissions for all scopes](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#modifying-the-permissions-for-the-github_token) for automated undrafting and setting releases to latest. Without it the builds still work, the associated releases will just be marked as a draft if they ever have to be rerun.

## Release File Naming Scheme
In order to provide a stable download URL for scripts trying to fetch the latest release, the archive containing the image file will be consistently named nixos-<format>.7z, where <format> is a subset of the strings specified by nixos-generators [here](https://github.com/nix-community/nixos-generators/tree/master?tab=readme-ov-file#supported-formats), or one of the following:
format | description
--- | ---
oracle | Oracle Cloud Infrastructure image

The name of the image itself is variable (partly in order to supoort VMMs that require their images to be named a [certain way](https://forum.proxmox.com/threads/error-couldnt-determine-format-and-compression-type.70084/post-324541)), but it is guaranteed to be the only file in the archive. If the image must also be of known name, the archive can be extracted to an empty directory and renamed [like so](https://stackoverflow.com/a/70166130).

## Caveats
- Currently, cloud-init runs, but its capabilities are [limited](https://search.nixos.org/options?channel=23.11&show=services.cloud-init.enable&from=0&size=50&sort=relevance&type=packages&query=cloud-init) by its conflicts with the declarative nature of NixOS. This means that some modules may behave differently compared to the imperative distros. In particular, it seems that setting authorized_keys for non-root users doesn't work.

## Acknowledgements
The configuration built is based on a modified version of voidus' [nixos cloud-init base image](https://discourse.nixos.org/t/a-cloudinit-image-for-use-in-proxmox/27519).
