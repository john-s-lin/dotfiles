{ pkgs, ... }:
{
  # Fallback coding agent. No secrets in repo: auth with `/login openrouter`
  # (OAuth) or OPENROUTER_API_KEY. Skills come from ~/.agents/skills (agents.nix);
  # global instructions from ~/.pi/agent/AGENTS.md (agents.nix).
  # Local models (Ollama/LM Studio/vLLM): see ~/.pi/agent/models.json in pi docs.
  home.packages = [ pkgs.pi-coding-agent ];
}
