# Himorogi OS

> 𝑻𝑯𝑰𝑺 𝑾𝑨𝑺 𝑵𝑬𝑽𝑬𝑹 𝑾𝑹𝑰𝑻𝑻𝑬𝑵  
> 𝑻𝑯𝑰𝑺 𝑾𝑨𝑺 𝑵𝑬𝑽𝑬𝑹 𝑺𝑷𝑶𝑲𝑬𝑵  
> 𝑰𝑭 𝒀𝑶𝑼 𝑲𝑵𝑶𝑾, 𝒀𝑶𝑼 𝑲𝑵𝑶𝑾  
> 𝑰𝑭 𝒀𝑶𝑼 𝑫𝑶 𝑵𝑶𝑻, 𝑰𝑻 𝑾𝑨𝑺 𝑵𝑬𝑽𝑬𝑹 𝑻𝑯𝑬𝑹𝑬  

---

## Purpose

Himorogi OS is a small, terminal‑only, RAM‑resident Linux environment for tasks that demand clean execution and verifiable disappearance.  
The system does **one** thing: provide a sharp, unencumbered workspace that boots, operates, and vanishes on command.

---

## System Profile

| Item                    | Detail                                              |
|-------------------------|-----------------------------------------------------|
| Base distribution       | Debian 12 (Bookworm) ― minimal install              |
| Architecture            | x86‑64                                              |
| Boot modes              | BIOS (ISOLINUX) · UEFI (GRUB/EFI)                   |
| Default user            | **root** (no password)                              |
| Persistence             | Optional — second partition, label `persistence`    |
| IPv6                    | Disabled by default (`ipv6.disable=1`, sysctl)      |
| MAC randomisation       | All non‑loopback interfaces randomised at boot      |
| RAM‑only option         | `toram` kernel parameter (copies FS to RAM)         |
| Wipe utility            | `wipe_and_exit.sh` → secure scrub + forced power‑off|

---

## Installed Toolchain (selection)

| Category      | Packages / Binaries                               |
|---------------|---------------------------------------------------|
| Networking    | `nmap`  `netcat-traditional`  `tcpdump`  `iproute2` |
| Wireless      | `aircrack-ng`  `iw`  `wireless-tools`             |
| Proxy / Tor   | `torsocks`  `tor`  `proxychains4`                 |
| Crypto / SSH  | `openssl`  `openssh-client`                       |
| Diagnostics   | `curl`  `wget`  `dig`  `traceroute`               |
| Scripting     | `python3`  `jq`  `ripgrep`                        |
| Management    | `nmcli`  `macchanger`  `lsblk`  `parted`          |
| Misc          | `tmux` (optional)  `micro`  `vim`                 |

*(Exact package set in `build_iso.sh` → `apt install -y …`)*

---

## Helper Scripts

| Script                     | Location                   | Function (one‑line)                                   |
|----------------------------|----------------------------|-------------------------------------------------------|
| `proxy_select.sh`          | `/root/scripts/`           | Quickly switch between direct, Tor, Proxychains       |
| `mount_usb.sh`             | `/root/scripts/`           | Read‑only mount for removable media                   |
| `wipe_and_exit.sh`         | `/usr/local/bin/`          | Secure wipe (see below) + immediate power‑off         |
| `waninfo.sh`               | `/usr/local/bin/`          | Show WAN IP + country at startup                      |
| `randomise_mac.sh`         | `/usr/local/bin/`          | Internal hook for boot‑time MAC randomisation         |
| `wipe` (wrapper)           | `/usr/local/bin/`          | Shorthand → executes `wipe_and_exit.sh`               |

---

### Wipe & Exit Workflow

`wipe_and_exit.sh` executes in the following order:

1. **User / root histories**  
   `~/.bash_history`, `~/.viminfo`, `~/.cache/*`
2. **System logs**  
   `/var/log/*.log`, journald directories, `/var/backups/*`
3. **Temp locations**  
   `/tmp/*`, `/var/tmp/*`, `/run/*`
4. **Sync + multiple `sync` calls**  
   Forces dirty pages to storage (USB media, if persistence was enabled)
5. **Forced power‑off**  
   `poweroff -f` (`systemctl poweroff --force --no-wall` fallback)

Script exits via kernel shutdown; if persistence partition is in use, its overlay is also wiped.

---

## Build & Reproduce

```bash
git clone git@github.com:kiwaku/Himorogi-OS.git
cd Himorogi-OS
sudo ./build_iso.sh     # outputs himorogi-fixed.iso
```
---

## Dependencies

binutils debootstrap squashfs-tools xorriso
isolinux syslinux-utils grub-pc-bin grub-efi-amd64-bin
mtools dosfstools qemu-system-x86 ovmf

---

## Future compatability

Asahi Linux support planned:
A dedicated version of Himorogi based on Asahi Linux is in development, targeting Apple Silicon (M1/M2/M3) systems. This will enable native booting and full functionality on Apple hardware.

---

## Licence

Himorogi OS is provided as‑is, without warranty of any kind. Use, study, modify, and redistribute under the terms of the license above.
