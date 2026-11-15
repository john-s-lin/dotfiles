# Terminfo Troubleshooting

## Background

Terminal emulators use terminfo databases to advertise their capabilities to applications. Ghostty uses the `xterm-ghostty` terminfo entry, which is included in ncurses 6.5-20241228 and later.

## Problem: Corrupted Terminfo on Older Systems

On systems with older ncurses versions (< 6.5), the `xterm-ghostty` terminfo entry may be compiled incorrectly, leading to:

- Garbled terminal output
- Repeated characters in prompts (especially with Starship)
- Incorrect rendering of special characters and escape sequences

### Root Cause

Ghostty's `shell-integration-features = ssh-terminfo` automatically copies the terminfo entry to remote servers on first SSH connection. However, if the remote system has an older `tic` (terminfo compiler), it may produce a corrupted binary entry.

**Example corruption:**
```bash
# Corrupted (ncurses 6.4):
initc=...\E\,invis=\E[8m,

# Correct (ncurses 6.6+):
initc=...\E\\,
invis=\E[8m,
```

The `initc` and `invis` capabilities get fused together, causing malformed escape sequences.

## Solution: Declarative Terminfo via Home-Manager

For servers managed by home-manager (e.g., `ajax`), the terminfo is provided declaratively from the Nix store, which uses ncurses 6.6+.

### Implementation

In `modules/home/server.nix` (imported via `modules/home/profiles/server.nix` by server hosts such as `ajax`, `dietpi`, and `nimbus`):

```nix
  home.file.".terminfo" = {
    source = "${pkgs.ghostty.terminfo}/share/terminfo";
    recursive = true;
  };
```

This places a correctly-compiled terminfo in `~/.terminfo/`, which takes precedence over the system-wide `/usr/share/terminfo/`.

### Verification

After applying the configuration:

```bash
# Check TERM value
echo $TERM
# Should output: xterm-ghostty

# Verify terminfo is correct
infocmp -x xterm-ghostty | grep initc
# Should end with: \E\\,
# NOT: \E\,invis=...

# Check that terminfo is Nix-managed
ls -la ~/.terminfo/x/xterm-ghostty
# Should be a symlink to /nix/store/.../ghostty-*-terminfo/...

# Test terminal rendering
# Starship prompt should render cleanly without character repeats
```

## Manual Fix (Non-Home-Manager Systems)

If you cannot use home-manager, manually install the correct terminfo from a system with ncurses 6.5+:

```bash
# From a workstation with Ghostty installed:
infocmp -x xterm-ghostty | ssh user@remote-host -- tic -x -o ~/.terminfo -
```

**Note:** This requires the workstation's `infocmp` to output a correct terminfo source. On macOS versions before Sonoma, you may need to install ncurses via Homebrew:

```bash
brew install ncurses
/opt/homebrew/opt/ncurses/bin/infocmp -x xterm-ghostty | ssh user@remote-host -- tic -x -o ~/.terminfo -
```

## Fallback: Use xterm-256color

If the terminfo cannot be fixed, configure SSH to fall back to a compatible TERM value:

```ssh-config
# ~/.ssh/config
Host problematic-server
  SetEnv TERM=xterm-256color
```

Or in Ghostty's configuration:

```
shell-integration-features = ssh-env
```

**Trade-off:** This disables Ghostty-specific features (styled underlines, etc.) but ensures compatibility.

## References

- [Ghostty Terminfo Documentation](https://ghostty.org/docs/help/terminfo)
- [ncurses 6.5 Release Notes](https://invisible-island.net/ncurses/announce.html#h2-overview)
- Related PRs:
  - [#37: Add declarative ghostty terminfo via home-manager](https://github.com/john-s-lin/dotfiles/pull/37)
  - [#36: Disable zellij auto-start for SSH server](https://github.com/john-s-lin/dotfiles/pull/36)
