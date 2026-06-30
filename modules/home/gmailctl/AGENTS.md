# Gmailctl Agent Instructions

## Prohibitions

- Under no circumstances may you run `gmailctl apply`, as that command is irreversible.

## Guidance

- The remote filter is the single source of truth. Use `gmailctl diff` or `gmailctl download` to grok the differences between remote and local filter configs.
- Use `gmailctl debug` to check if the updated local filter passes syntax
- `gmailctl help` for a full list of valid commands

## Config Path

The `config.jsonnet` file gets symlinked to `${HOME}/.gmailctl` via nix home-manager. For validation before nix rebuild gets applied, pass in the `--config` flag to point to this directory.

Example: `gmailctl --config /Users/john/.dotfiles/modules/home/gmailctl debug`

## Label Colors

Gmail API only allows a predefined set of colors for labels. Custom hex colors will be rejected with error `Label color #XXXXXX is not on the allowed color palette`.

### Allowed Colors

**Grayscale:**

- `#000000` (black)
- `#434343` (dark gray)
- `#666666` (gray)
- `#999999` (medium gray)
- `#cccccc` (light gray)
- `#efefef` (very light gray)
- `#f3f3f3` (near white)
- `#ffffff` (white)

**Vibrant Colors:**

- `#fb4c2f` (red)
- `#ffad47` (orange)
- `#fad165` (yellow)
- `#16a766` (green)
- `#43d692` (mint)
- `#4a86e8` (blue)
- `#a479e2` (purple)
- `#f691b3` (pink)

**Additional Colors:**

- `#f6c5be`, `#ffe6c7`, `#fef1d1`, `#b9e4d0`, `#c6f3de`, `#c9daf8`, `#e4d7f5`, `#fcdee8`, `#efa093`, `#ffd6a2`, `#fce8b3`, `#89d3b2`, `#a0eac9`, `#a4c2f4`, `#d0bcf1`, `#fbc8d9`, `#e66550`, `#ffbc6b`, `#fcda83`, `#44b984`, `#68dfa9`

### Usage in Config

When defining labels in `config.jsonnet`, use the named entries from the local `colors` map. Do not inline hex values in each label unless adding a new named color first:

```jsonnet
labels: [
  {
    name: 'banking/cibc',
    color: colors.orange,
  },
  {
    name: 'banking/chase',
    color: colors.orange,
  },
],
```

If you add a new entry to the `colors` map, use only colors from the allowed set or colors returned by `gmailctl download`.

### Troubleshooting

If you get the error `Label color #XXXXXX is not on the allowed color palette`:

1. Check the Gmail API documentation: https://developers.google.com/gmail/api/v1/reference/users/labels#resource
1. Replace the invalid color with one from the allowed set above
1. Re-run `gmailctl debug` to validate before applying

**Downloaded colors are valid:** When using `gmailctl download`, the colors returned are those already configured in Gmail UI and are guaranteed to be valid. Do not change downloaded colors - they represent the actual working palette from your Gmail account.
