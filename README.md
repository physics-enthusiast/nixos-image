# IMPORTANT NOTE
Due to the recent [xz backdoor incident](https://discourse.nixos.org/t/cve-2024-3094-malicious-code-in-xz-5-6-0-and-5-6-1-tarballs/42405?u=lun), all releases containing [this commit](https://github.com/NixOS/nixpkgs/commit/5c7c19cc7ef416b2f4a154263c6d04a50bbac86c) have been taken down. It is [currently thought](https://discourse.nixos.org/t/cve-2024-3094-malicious-code-in-xz-5-6-0-and-5-6-1-tarballs/42405/11) that NixOS does not cause the backdoor to actually trigger, but out of an abundance of caution any release containing the malicious code has been removed ~~, and new releases will not be produced until the [PR reverting the relevant commit](https://github.com/NixOS/nixpkgs/pull/300028) makes its way into `nixos-unstable`. Its progress can be tracked [here](https://nixpk.gs/pr-tracker.html?pr=300028).~~ PR has been merged, releases are resuming.

# Prebuilt NixOS Images

This repo builds NixOS disk images of various formats using Github Actions. They can be downloaded [here](https://github.com/physics-enthusiast/nixos-image/releases). The configuration built contains the respective guest agent of the cloud provider/virtual machine manager (where relevant) and cloud-init (for archives without -nocloud). If a different default configuration is desired: fork this repository, make edits to one of the flakes and wait for the workflow job to complete. Enable [read and write permissions for all scopes](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#modifying-the-permissions-for-the-github_token) for automated undrafting and setting releases to latest. Without it the builds still work, the associated releases will just be marked as a draft if they ever have to be rerun.

## Release File Naming Scheme
In order to provide a stable download URL for scripts trying to fetch the latest release, the archive containing the image file will be consistently named `nixos-<format>-<configuration>.7z`, where <format> is a subset of the strings specified by nixos-generators [here](https://github.com/nix-community/nixos-generators/tree/master?tab=readme-ov-file#supported-formats), or one of the following:
format | description
--- | ---
oracle | Oracle Cloud Infrastructure image

Currently available configurations are:
configuration | description
--- | ---
nocloud | Base configuration with openssh and systemd-networkd
default | cloud-init enabled
graphical | LXDE enabled and root password set to "nixos" to allow for interactive login

Configuration files can be found in the `configurations` folder. `-<configuration>` in the archive name is ommited for the default configuration for download link consistency reasons (it was the first and formerly the only configuration).
The name of the image itself is variable (partly in order to supoort VMMs that require their images to be named a [certain way](https://forum.proxmox.com/threads/error-couldnt-determine-format-and-compression-type.70084/post-324541)), but it is guaranteed to be the only file in the archive. If the image must also be of known name, the archive can be extracted to an empty directory and renamed [like so](https://stackoverflow.com/a/70166130).

## Caveats
- Currently, cloud-init runs, but its capabilities are [limited](https://search.nixos.org/options?channel=23.11&show=services.cloud-init.enable&from=0&size=50&sort=relevance&type=packages&query=cloud-init) by its conflicts with the declarative nature of NixOS. This means that some modules may behave differently compared to the imperative distros. In particular, it seems that setting authorized_keys for non-root users doesn't work.
- All configs are built with the `nixos-unstable` branch of nixpkgs. `nixos-rebuild` cannot downgrade the system back to `nixos-23.11` and before due to [this change](https://github.com/NixOS/nixpkgs/pull/278609#issuecomment-1880310532). Images built from the stable branch are coming soon.

## Acknowledgements
The configuration built is based on a modified version of voidus' [nixos cloud-init base image](https://discourse.nixos.org/t/a-cloudinit-image-for-use-in-proxmox/27519).
