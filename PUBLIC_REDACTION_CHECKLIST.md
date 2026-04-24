# Public Redaction Checklist

Use this checklist before publishing documentation, screenshots, logs, file trees, diagnostic output, recovery notes, or build updates to the public repository.

The goal is to preserve useful technical lessons while avoiding unnecessary exposure of private, device-specific, account-specific, or operationally sensitive details.

## Before Publishing

| Check | Complete | Notes |
|---|---|---|
| Device serial numbers removed or redacted |  |  |
| IMEI / MEID / SIM / carrier identifiers removed |  |  |
| Personal file paths removed or generalized |  |  |
| Usernames removed unless intentionally public |  |  |
| Email addresses removed |  |  |
| Phone numbers removed |  |  |
| Physical addresses removed |  |  |
| Credentials, tokens, API keys, cookies, and session data removed |  |  |
| Private download links removed |  |  |
| Screenshots reviewed for personal tabs, account names, bookmarks, and notifications |  |  |
| Precise private GPS coordinates removed |  |  |
| Recovery logs reviewed for unique hardware identifiers |  |  |
| Local network names, IPs, and device names removed unless intentionally documented |  |  |
| Proprietary or copyrighted files not committed directly unless allowed |  |  |
| Large binary files reviewed before commit |  |  |
| Public comparison claims are defensible and not overstated |  |  |
| Known limitations are documented honestly |  |  |

## Search Commands

Run these from the repository root before publishing:

```bash
grep -RInE "Serial|serial|SN:|S/N|IMEI|MEID|/Users/|Jason|token|apikey|api_key|password|secret|private|credential|cookie|session" . --exclude-dir=.git --exclude=files.zip