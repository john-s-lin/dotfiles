{ pkgs, config, ... }:
{
  # Fallback coding agent. No secrets in repo: auth with `/login openrouter`
  # (OAuth) or OPENROUTER_API_KEY. Skills come from ~/.agents/skills (agents.nix);
  # global instructions from ~/.pi/agent/AGENTS.md (agents.nix).
  # Local models (Ollama/LM Studio/vLLM): see pi/models.json in pi docs.
  home.packages = [ pkgs.pi-coding-agent ];

  # Both files are out-of-store symlinks into the dotfiles working tree:
  # - settings.json is written by pi itself (theme, Ctrl+S-saved default model,
  #   lastChangelogVersion), so it must stay writable. Writes show up as repo
  #   changes: commit or discard them as desired.
  # - models.json is not written by pi, but linking it the same way means
  #   manual edits (custom headers, provider overrides) take effect without a
  #   rebuild.
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/modules/home/pi/settings.json";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/modules/home/pi/models.json";

  # Custom theme matching the terminal palette (tokyo-passion in ghostty.nix /
  # alacritty.nix). Out-of-store symlink so editing the repo file hot-reloads
  # in a running pi.
  home.file.".pi/agent/themes/tokyo-passion.json".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/modules/home/pi/themes/tokyo-passion.json";

  # Not managed (pi-owned cache/state): models-store.json, sessions/, auth.json
}
