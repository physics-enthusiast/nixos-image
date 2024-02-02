# Prebuilt NixOS Images

This repo builds NixOS disk images of various formats using Github Actions. They can be downloaded [here](https://github.com/physics-enthusiast/nixos-image/releases). in The configuration built contains enabled QEMU guest-agent and cloud-init. If a different default configuration is desired: fork this repository, make edits to the contained configuration.nix file and wait for the workflow job to complete. Enable [read and write permissions for all scopes](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#modifying-the-permissions-for-the-github_token) for automated undrafting and setting releases to latest. Without it the builds still work, the associated releases will just be marked as a draft if they ever have to be rerun.

## Caveats
- Currently, cloud-init runs, but its capabilities are [limited](https://search.nixos.org/options?channel=23.11&show=services.cloud-init.enable&from=0&size=50&sort=relevance&type=packages&query=cloud-init) by its conflicts with the declarative nature of NixOS. This means that some modules may behave differently compared to the imperative distros. For instance, it appears to be incapable of setting ssh_authorized_keys for any user that is not root, and for reasons unknown to me decides to silently place them in root instead.

## Acknowledgements
The configuration built is based on a modified version of voidus' [nixos cloud-init base image](https://discourse.nixos.org/t/a-cloudinit-image-for-use-in-proxmox/27519).
