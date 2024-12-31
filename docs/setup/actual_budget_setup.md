# Actual Budget on Raspberry Pi

> Note: this uses `dietpi` which is a Debian-based OS for Raspberry Pi

## Premise

I want to migrate off of managing my finances from an Excel file called `Budget_<YEAR>.xlsx` onto something that's more app-like but also self-hosted. I explored [Maybe Finance](https://maybefinance.com/), which looks snazzy, but is not so full-featured yet.

Thus, based on [this tweet](https://x.com/tom_doerr/status/1855000297170489580) and reviews on Reddit [\[1\]](https://www.reddit.com/r/selfhosted/comments/1frcvvp/personal_finance_tool_maybe/lpc8kej/) [\[2\]](https://www.reddit.com/r/selfhosted/comments/18kihwr/firefly_iii_vs_actual_budget/), I've decided to use [Actual Budget](https://actualbudget.org/).

- [GitHub Repo](https://github.com/actualbudget/actual)
- [Server Repo](https://github.com/actualbudget/actual-server)

## Steps

1. Create a `docker_apps` directory in your `${HOME}` directory if not already created.

```bash
mkdir -p "${HOME}/docker_apps"
```

2. Change into the `docker_apps` directory and clone the server repo: https://github.com/actualbudget/actual-server

```bash
git clone git@github.com:actualbudget/actual-server.git
```
