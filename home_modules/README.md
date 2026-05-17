## Folder Structure

- **base/**: Essential cross-host programs and configurations
- **hyprland/**: Hyprland WM and tightly coupled services/programs
    - **config/**: Hosts the actual hyprland config
    - **services/**: Background services for hyprland
    - **default.nix**: Defines a custom nixos option for `mainMod` key and installs companion programs
- **overrides/**: Reusable special program configurations. 

Note that the overrides folder is used for special reusable configurations. For host-specific applications which do not require special configuration use the `/users/<username>/home.nix` file instead.
