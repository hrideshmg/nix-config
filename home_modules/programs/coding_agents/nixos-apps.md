# Running apps and tools on NixOS

- Prefer launching applications and standalone CLI tools with `nix run`
- If a package does not provide a runnable default app, use `nix shell nixpkgs#<package> -c <command> <args>`.
- Use the project's documented development environment or scripts when the task depends on project-specific dependencies.
