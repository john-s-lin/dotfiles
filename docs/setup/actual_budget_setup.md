# Actual Budget on Raspberry Pi

> Note: this uses `dietpi` which is a Debian-based OS for Raspberry Pi

## Premise

I want to migrate off of managing my finances from an Excel file called `Budget_<YEAR>.xlsx` onto something that's more app-like but also self-hosted. I explored [Maybe Finance](https://maybefinance.com/), which looks snazzy, but is not so full-featured yet.

Thus, based on [this tweet](https://x.com/tom_doerr/status/1855000297170489580) and reviews on Reddit [\[1\]](https://www.reddit.com/r/selfhosted/comments/1frcvvp/personal_finance_tool_maybe/lpc8kej/) [\[2\]](https://www.reddit.com/r/selfhosted/comments/18kihwr/firefly_iii_vs_actual_budget/), I've decided to use [Actual Budget](https://actualbudget.org/).

- [GitHub Repo](https://github.com/actualbudget/actual)
- [Server Repo](https://github.com/actualbudget/actual-server)

## Steps

### 1. Create a `docker_apps` directory in your `${HOME}` directory if not already created.

```bash
mkdir -p "${HOME}/docker_apps"
```

### 2. Change into the `docker_apps` directory and clone the server repo: https://github.com/actualbudget/actual-server

```bash
git clone git@github.com:actualbudget/actual-server.git
```

### 3. Update the `docker-compose.yml` to target your specified image.

I'm using `latest-alpine`.

```yml
image: docker.io/actualbudget/actual-server:latest-alpine
---
environment:
  - ACTUAL_PORT=5006
  - ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB=20
  - ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SYNC_SIZE_LIMIT_MB=50
  - ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB=20
```

### 4. Start the container and test to see if you have access to it.

You'll reach an error requiring you to have `SHARED_BUFFER_ARRAY` and needing an HTTPS certificate. We'll deal with that later.

```bash
docker compose up -d
```

Check you can reach the Actual Budget program by going to

```bash
# Remember we set 5006 as the port exposed for Actual
<URL_TO_RASPBERRY_PI>:5006
```

### 5. Enable `tailscale` on your Raspberry Pi.

This should have been done already when setting up your Pi in [dietpi_setup.md](./dietpi/dietpi_setup.md). If you have not created an account on https://tailscale.com, do so as well. Then, to connect your Raspberry Pi to your `tailscale` account, run

```bash
sudo tailscale up
```

Copy the `url` to a browser and boom! You're connected.

### 6. Generate a Tailscale HTTPS certificate and key

In your Tailscale account, go to `DNS >> HTTPS Certificates >> Enable HTTPS` if not already enabled.

Then on your Raspberry Pi, generate a HTTPS certificate using `tailscale cert` with the `HOSTNAME` provided by your machine. Either run the command below an Tailscale will tell you, or replace `hostname.tails-scales.ts.net` with the actual `HOSTNAME` provided in the dropdown menu in the `Machines` tab in your Admin page on Tailscale.

```bash
tailscale cert --cert-file=cert.pem --key-file=key.pem hostname.tails-scales.ts.net
```

### 7. Store the key and certificate in `/config.json`

Ref: https://actualbudget.org/docs/config/https#2-configure-actual-to-use-the-certificate

Change into your mounted data directory as seen in `docker-compose.yml`

```bash
cd actual-data/
```

Then set the certificate and key files in `config.json`.

```json
{
  "https": {
    "key": "/data/key.pem",
    "cert": "/data/cert.pem"
  }
}
```

### 8. Access Actual Server again, this time prepending `https://`

This time, you can access Actual Budget at

```bash
https://<URL_TO_RASPBERRY_PI>:5006
```

You should now have access to Actual Budget! Since I don't want to pay a subscription to sync my bank info, I'm gonna add it manually.
