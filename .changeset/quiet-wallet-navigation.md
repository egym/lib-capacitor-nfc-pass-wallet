---
"@egym/capacitor-nfc-pass-wallet": patch
---

Fix BMACG-605: open existing iOS passes in Apple Wallet instead of presenting the add sheet, with an installed-pass URL fallback and explicit navigation errors. Preserve the add flow for missing passes.
