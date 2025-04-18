Greetings!

Welcome to my project.

Requirements:
- Linux based operating system.
- `gpg` Installed.
- `hexdump` Installed.
- `perl` Installed.
- `cat` Installed.

Concept:
A proof of concept to showcase increasing security of an already encrypted message.
Securely converts PGP encrypted messages to manipulated hex string.

Features:
- The sensitive message/text will be written in memory and not saved to disk and thus prevents data recovery.
- Supports image file encryption (under development)
- Reducing message size (under development)
- Reliable usage without any room for human error.

How to use:
- Install on a Linux-based operating system.
- locate the `Testng.sh` file to a directory in which you have saved the public keys
- `chmod +x Testing.sh`
- `./Testing.sh`
