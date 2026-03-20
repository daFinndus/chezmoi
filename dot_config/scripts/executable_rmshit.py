#! /usr/bin/env python3

import os
import sys
import yaml
import shutil
import subprocess

from pathlib import Path

# This is stolen from here:
# https://github.com/lahwaacz/Scripts/blob/master/rmshit.py

# It is modified though

DEFAULT_CONFIG = """
- ~/.FRD/links.txt                   # FRD
- ~/.FRD/log/app.log                 # FRD
- ~/.QtWebEngineProcess/             # Qt WebEngine cache
- ~/.adobe                           # Flash crap
- ~/.ansible/                        # Ansible cache
- ~/.asy/                            # Asymptote cache
- ~/.bazaar/                         # Bzr insists on creating files
- ~/.bundle/cache/                   # Ruby Bundle cache
- ~/.bzr.log                         # Bazaar log file
- ~/.cabal/logs/                     # Haskell Cabal logs
- ~/.cache/JetBrains/                # JetBrains cache
- ~/.cache/bazel/                    # Bazel build cache
- ~/.cache/chromium/                 # Chromium cache
- ~/.cache/containers/               # Containers cache
- ~/.cache/deno/                     # Deno cache
- ~/.cache/electron/                 # Electron cache
- ~/.cache/fontconfig/               # Font cache
- ~/.cache/go-build/                 # Go build cache
- ~/.cache/google-chrome/            # Google Chrome cache
- ~/.cache/helm/                     # Helm cache
- ~/.cache/librewolf/                # LibreWolf cache
- ~/.cache/mesa_shader_cache/        # Mesa shader cache
- ~/.cache/mesa_shader_cache_db/     # Mesa shader cache DB
- ~/.cache/mozilla/                  # Mozilla cache
- ~/.cache/ms-playwright/            # Playwright cache
- ~/.cache/nvim/                     # Neovim cache
- ~/.cache/obs-studio/               # OBS cache
- ~/.cache/paru/                     # Paru cache
- ~/.cache/pip/                      # Pip cache
- ~/.cache/pnpm/                     # PNPM package manager cache
- ~/.cache/podman/                   # Podman cache
- ~/.cache/pre-commit/               # pre-commit cache
- ~/.cache/pypoetry/                 # Poetry cache
- ~/.cache/spotify/                  # Spotify cache
- ~/.cache/thumbnails/               # Thumbnail cache
- ~/.cache/typescript/               # TypeScript cache
- ~/.cache/yarn/                     # Yarn package manager cache
- ~/.cache/yay/                      # Yay AUR helper cache
- ~/.cache/zed/                      # Zed cache
- ~/.cmake/                          # CMake cache
- ~/.composer/cache/                 # PHP Composer cache
- ~/.config/Code/Cache/              # VSCode cache
- ~/.config/Code/CachedData/         # VSCode cached data
- ~/.config/Code/Service Worker/CacheStorage/   # VSCode service worker cache
- ~/.config/VSCodium/Cache/          # VSCodium cache
- ~/.config/VSCodium/CachedData/     # VSCodium cached data
- ~/.config/discord/Cache/           # Discord cache
- ~/.config/discord/Code Cache/      # Discord code cache
- ~/.config/discord/GPUCache/        # Discord GPU cache
- ~/.config/enchant                  # Spell checker cache
- ~/.config/vesktop/Cache/           # Vesktop cache
- ~/.config/vesktop/Code Cache/      # Vesktop code cache
- ~/.config/vesktop/GPUCache/        # Vesktop GPU cache
- ~/.cpan/build/                     # CPAN build cache
- ~/.dbus                            # D-Bus session files
- ~/.distlib/                        # Contains another empty dir
- ~/.dropbox-dist                    # Dropbox distribution files
- ~/.electron-gyp/                   # Electron native addon build cache
- ~/.esd_auth                        # ESD authentication
- ~/.fltk/                           # FLTK cache
- ~/.gconf                           # GNOME configuration
- ~/.gconfd                          # GNOME configuration daemon
- ~/.gem/specs/                      # Ruby Gem specs cache
- ~/.gnome/                          # GNOME cache
- ~/.go/pkg/mod/cache/               # Go module cache
- ~/.gradle/caches/                  # Gradle build cache
- ~/.gstreamer-0.10                  # GStreamer cache
- ~/.ivy2/cache/                     # Ivy cache
- ~/.java/                           # Java cache and temp files
- ~/.jssc/                           # Java Simple Serial Connector
- ~/.local/share/Steam/logs/         # Steam log files
- ~/.local/share/Trash/              # Trash
- ~/.local/share/gegl-0.2            # GEGL library cache
- ~/.local/share/recently-used.xbel  # Recently used files
- ~/.local/share/vulkan/             # Vulkan cache
- ~/.lesshst                         # less history
- ~/.macromedia                      # Flash crap
- ~/.mozilla/firefox/*/cache2/       # Firefox cache
- ~/.mozilla/firefox/*/startupCache/ # Firefox startup cache
- ~/.node-gyp/                       # Node.js native addon build cache
- ~/.npm/                            # NPM cache
- ~/.npm/_cacache/                   # NPM content-addressable cache
- ~/.nv/                             # NVIDIA cache
- ~/.nvm/.cache/                     # Node Version Manager cache
- ~/.objectdb                        # FRD
- ~/.openjfx/                        # OpenJFX cache
- ~/.oracle_jre_usage/               # Oracle JRE usage data
- ~/.org.jabref.gui.JabRefMain/      # JabRef cache
- ~/.org.jabref.gui.MainApplication/ # JabRef cache
- ~/.parallel                        # GNU Parallel
- ~/.pip/cache/                      # Pip cache (old location)
- ~/.pulse                           # PulseAudio
- ~/.pylint.d/                       # Pylint cache
- ~/.python_history                  # Python REPL history
- ~/.qute_test/                      # Qutebrowser test files
- ~/.qutebrowser/                    # Created empty
- ~/.recently-used                   # Recently used files
- ~/.rediscli_history                # Redis CLI history
- ~/.rustup/tmp/                     # Rustup temporary files
- ~/.sbt/boot/                       # SBT boot cache
- ~/.spicec                          # Contains only log file
- ~/.sqlite_history                  # SQLite history
- ~/.steam/logs/                     # Steam log files
- ~/.swt/                            # Standard Widget Toolkit cache
- ~/.texlive/                        # TeX Live cache
- ~/.thumbnails                      # Image thumbnails cache
- ~/tmp
- ~/.tox/                            # Cache directory for tox
- ~/.var/app/*/cache/                # Flatpak app caches
- ~/.viminfo                         # Sometimes created wrongfully
- ~/.vnc/                            # VNC cache
- ~/.w3m/                            # w3m browser cache
- ~/.wget-hsts                       # wget HSTS cache
- ~/.wine/drive_c/windows/Temp/      # Wine temporary files
- ~/ca2                              # WTF
- ~/ca2~                             # WTF
- ~/nvvp_workspace/                  # Created empty
- ~/unison.log                       # Unison log file
"""

CONFIG_PATH = Path(os.getenv("XDG_CONFIG_HOME", Path.home() / ".config")) / "rmshit.yaml"

# Format size function to convert bytes to human-readable format
def format_size(size: float) -> str:
    for unit in ("B", "KiB", "MiB", "GiB", "TiB"):
        if size < 1024:
            return f"{size:.1f} {unit}"
        size /= 1024
    
    return f"{size:.1f} PiB"

# Get directory size function to calculate total size of files in a directory
def get_dir_size(path: Path) -> int:
    total = 0
    
    try:
        if path.is_file():
            return path.stat().st_size
        for p in path.rglob("*"):
            try:
                if p.is_file():
                    total += p.stat().st_size
            except (OSError, FileNotFoundError):
                continue
    except Exception:
        pass
    
    return total

# Load configuration function to read paths from the config file 
def load_config() -> list[Path]:
    if not CONFIG_PATH.exists():
        CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
        CONFIG_PATH.write_text(DEFAULT_CONFIG.strip() + "\n")

    try:
        raw = yaml.safe_load(CONFIG_PATH.read_text()) or []
    except yaml.YAMLError as e:
        sys.exit(f"YAML parse error in {CONFIG_PATH}: {e}")

    return [Path(os.path.expanduser(str(p))) for p in raw]

# Function to prompt user for yes/no input
def yesno(question: str, default="n") -> bool:
    prompt = f"\n{question} (y/[n]) " if default == "n" else f"{question} ([y]/n) "
    ans = input(prompt).strip().lower()
    
    if not ans:
        ans = default
    
    return ans.startswith("y")

# This is a helper for cleaning up via a command
def run_cleanup_command(name: str, command: list[str], path_to_measure: Path | None = None) -> int:
    before = get_dir_size(path_to_measure) if path_to_measure else 0

    print(f"\nRunning {name}...")
    result = subprocess.run(command, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Failed to run {name}:")

        if result.stderr.strip():
            print(result.stderr.strip())
        
        return 0

    after = get_dir_size(path_to_measure) if path_to_measure else 0
    freed = max(0, before - after)

    print(f"{name} freed {format_size(freed)}.")

    return freed

# This is the main function
def rmshit():
    junk_paths = load_config()
    found = []
    total_size = 0

    print("Scanning for junk files...")

    for p in junk_paths:
        expanded = list(sorted(p.parent.glob(p.name))) if "*" in p.name else [p]
        for path in expanded:
            if path.exists():
                size = get_dir_size(path)
                total_size += size
                found.append((path, size))

    if not found:
        print("No junk found.")
        return

    print("\nFound junk files/directories:")
    
    for path, size in found:
        print(f"  {path}  ({format_size(size)})")

    print(f"\nTotal size: {format_size(total_size)}")

    if not yesno("Remove all?", default="n"):
        print("No file removed.")
        return

    freed = 0

    for path, size in found:
        try:
            if path.is_file() or path.is_symlink():
                path.unlink(missing_ok=True)
            else:
                shutil.rmtree(path, ignore_errors=True)
            freed += size
        except Exception as e:
            print(f"Failed to delete {path}: {e}")

    print("\nNow clearing pacman caches.")

    if yesno("Run paccache cleanup too?", default="n"):
        freed += run_cleanup_command(
            "paccache -r",
            ["sudo", "paccache", "-r"],
            Path("/var/cache/pacman/pkg"),
        )

    if yesno("Remove uninstalled pacman cache too?", default="n"):
        freed += run_cleanup_command(
            "paccache -ruk0",
            ["sudo", "paccache", "-ruk0"],
            Path("/var/cache/pacman/pkg"),
        )

    if yesno("Vacuum journal logs older than 7 days?", default="n"):
        freed += run_cleanup_command(
            "journalctl --vacuum-time=7d",
            ["sudo", "journalctl", "--vacuum-time=7d"],
            Path("/var/log/journal"),
        )

    print(f"\nTotal freed overall: {format_size(freed)}")

if __name__ == "__main__":
    rmshit()
