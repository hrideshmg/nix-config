# Running apps and tools on NixOS

- Prefer launching applications and standalone CLI tools with `nix run`
- If a package does not provide a runnable default app, use `nix shell nixpkgs#<package> -c <command> <args>`.
- Use the project's documented development environment or scripts when the task depends on project-specific dependencies.

# Exa research tools

- Use Exa web search freely whenever current web information or source discovery is useful; prefer it for single questions and focused lookups.
- Exa Agent runs are expensive. Use an Exa Agent only when the task genuinely requires multi-step, cross-source research, structured list-building/enrichment, or verification that cannot be done efficiently with a focused search and a few page fetches.
- Do not use Exa Agent for routine web searches, one-off lookups, or simply because a question involves multiple sources; search and fetch those sources directly instead.
