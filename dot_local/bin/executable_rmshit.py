#!/usr/bin/env python3

# Interactive junk cleaner for common cache and temporary paths.

# This is stolen from here:
# https://github.com/lahwaacz/Scripts/blob/master/rmshit.py

# It is modified though

import os
import shutil
import subprocess
import sys
from collections.abc import Callable
from glob import glob
from pathlib import Path

import yaml

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

RED = "\033[38;2;220;50;50m"
YELLOW = "\033[38;2;220;180;0m"
GREEN = "\033[38;2;50;200;50m"
BLUE = "\033[38;2;50;120;220m"
RESET = "\033[0m"


def log_step(message: str) -> None:
    print(f"\n{BLUE}[*]{RESET} {message}")


def log_success(message: str) -> None:
    print(f"{GREEN}[+]{RESET} {message}")


def log_warn(message: str) -> None:
    print(f"{YELLOW}[!]{RESET} {message}")


def log_error(message: str) -> None:
    print(f"{RED}[-]{RESET} {message}")


XDG_CACHE_HOME = Path(os.getenv("XDG_CACHE_HOME", Path.home() / ".cache"))
CONFIG_PATH = XDG_CACHE_HOME / "rmshit" / "rmshit.yaml"
CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)


# Convert a byte count to a human-readable binary unit string.
def format_size(size: float) -> str:
    for unit in ("B", "KiB", "MiB", "GiB", "TiB"):
        if size < 1024:
            return f"{size:.1f} {unit}"
        size /= 1024

    return f"{size:.1f} PiB"


# Return total file size for a file or recursively for a directory.
def get_dir_size(path: Path) -> int:
    total = 0

    try:
        if path.is_file():
            return path.stat().st_size
        for entry in path.rglob("*"):
            try:
                if entry.is_file():
                    total += entry.stat().st_size
            except (OSError, FileNotFoundError):
                continue
    except OSError:
        pass

    return total


def get_free_space(path: Path) -> int:
    """Return free bytes on the filesystem containing path."""
    try:
        return shutil.disk_usage(path).free
    except OSError:
        return 0


# Load cleanup paths from YAML config, creating default config if missing.
def load_config() -> list[Path]:
    if not CONFIG_PATH.exists():
        CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
        try:
            CONFIG_PATH.write_text(DEFAULT_CONFIG.strip() + "\n")
        except OSError as e:
            sys.exit(f"Unable to create {CONFIG_PATH}: {e}")

    try:
        raw = yaml.safe_load(CONFIG_PATH.read_text()) or []
    except OSError as e:
        sys.exit(f"Unable to read {CONFIG_PATH}: {e}")
    except yaml.YAMLError as e:
        sys.exit(f"YAML parse error in {CONFIG_PATH}: {e}")

    if not isinstance(raw, list):
        sys.exit(f"Expected a list of paths in {CONFIG_PATH}.")

    paths: list[Path] = []
    for entry in raw:
        if not isinstance(entry, str) or not entry.strip():
            sys.exit(f"Every entry in {CONFIG_PATH} must be a non-empty path.")
        paths.append(Path(os.path.expanduser(entry)))

    return paths


# Ask a yes/no question and return True when the answer starts with 'y'.
def yesno(question: str, default: str = "n") -> bool:
    prompt = f"\n{question} (y/[n]) " if default == "n" else f"{question} ([y]/n) "
    ans = input(prompt).strip().lower()

    if not ans:
        ans = default

    return ans.startswith("y")


def run_cleanup_command(
    name: str,
    command: list[str],
    path_to_measure: Path | None = None,
    show_output: bool = False,
) -> int:
    before = get_free_space(path_to_measure) if path_to_measure else 0

    log_step(f"Running {name}...")
    if show_output:
        print()
    try:
        # Keep stderr attached so sudo can show its password prompt and errors.
        result = subprocess.run(
            command,
            stdout=None if show_output else subprocess.DEVNULL,
            text=True,
        )
    except OSError as e:
        log_error(f"Unable to run {name}: {e}")
        return 0

    if show_output:
        print()

    if result.returncode != 0:
        log_error(f"{name} failed with exit code {result.returncode}.")
        return 0

    after = get_free_space(path_to_measure) if path_to_measure else 0
    freed = max(0, before - after)

    log_success(f"{name} freed {format_size(freed)}.")

    return freed


def expand_glob(path: Path) -> list[Path]:
    if not any(char in str(path) for char in "*?["):
        return [path]
    return sorted(Path(match) for match in glob(str(path)))


def scan_junk_paths(junk_paths: list[Path]) -> list[tuple[Path, int]]:
    found: list[tuple[Path, int]] = []

    for junk_path in junk_paths:
        for path in expand_glob(junk_path):
            if not path.exists():
                continue
            size = get_dir_size(path)
            found.append((path, size))

    return found


def delete_paths(found: list[tuple[Path, int]]) -> int:
    freed = 0

    for path, _ in found:
        before = get_free_space(path)
        try:
            if path.is_file() or path.is_symlink():
                path.unlink(missing_ok=True)
            else:
                shutil.rmtree(path)
            freed += max(0, get_free_space(path.parent) - before)
        except PermissionError:
            log_warn(f"Insufficient permissions for {path}; retrying with sudo.")
            result = subprocess.run(
                ["sudo", "rm", "-rf", "--", str(path)],
                check=False,
            )
            if result.returncode == 0 and not path.exists():
                freed += max(0, get_free_space(path.parent) - before)
            else:
                log_error(f"Failed to delete {path}.")
        except OSError as e:
            log_error(f"Failed to delete {path}: {e}")

    return freed


def remove_orphaned_packages() -> int:
    try:
        result = subprocess.run(
            ["pacman", "-Qtdq"],
            capture_output=True,
            text=True,
            check=False,
        )
    except OSError as e:
        log_error(f"Unable to query orphaned packages: {e}")
        return 0

    packages = result.stdout.split()
    if not packages:
        if result.returncode not in (0, 1):
            log_error("Failed to query orphaned packages.")
            if result.stderr.strip():
                log_error(result.stderr.strip())
        else:
            log_success("No orphaned packages found.")
        return 0

    log_step(f"Removing {len(packages)} orphaned package(s)...")
    return run_cleanup_command(
        "orphaned package removal",
        ["sudo", "pacman", "-Rns", "--noconfirm", *packages],
    )


def wait_for_keypress(prompt: str = "Press any key to exit...") -> None:
    print(f"\n{prompt}", end="", flush=True)

    if sys.stdin.isatty():
        try:
            import termios
            import tty

            fd = sys.stdin.fileno()
            old = termios.tcgetattr(fd)
            try:
                tty.setraw(fd)
                sys.stdin.read(1)
            finally:
                termios.tcsetattr(fd, termios.TCSADRAIN, old)
        except Exception:
            input()
    else:
        input()

    print()


# Scan configured junk paths, prompt, and delete selected targets.
def rmshit() -> None:
    junk_paths = load_config()
    total_size = 0

    log_step("Scanning for junk files...")
    found = scan_junk_paths(junk_paths)

    if found:
        log_step("Found junk files/directories:")

        for path, size in found:
            print(f"  {path}  ({format_size(size)})")
            total_size += size

        log_step(f"Total size: {format_size(total_size)}")

        if yesno("Remove all?", default="n"):
            total_size = delete_paths(found)
        else:
            log_warn("No file removed.")
    else:
        log_warn("No junk found.")

    cleanup_actions: list[tuple[str, Callable[[], int]]] = [
        ("Remove orphaned packages?", remove_orphaned_packages),
        (
            "Remove all pacman package caches?",
            lambda: run_cleanup_command(
                "pacman cache cleanup",
                ["sudo", "pacman", "-Scc", "--noconfirm"],
                Path("/var/cache/pacman/pkg"),
            ),
        ),
        (
            "Remove uninstalled pacman packages from the cache?",
            lambda: run_cleanup_command(
                "paccache cleanup",
                ["sudo", "paccache", "-r", "-u", "-k", "0"],
                Path("/var/cache/pacman/pkg"),
            ),
        ),
        (
            "Vacuum journal logs older than 7 days?",
            lambda: run_cleanup_command(
                "journal cleanup",
                ["sudo", "journalctl", "--vacuum-time=7d"],
                Path("/var/log/journal"),
                show_output=True,
            ),
        ),
    ]

    freed = total_size
    for question, cleanup in cleanup_actions:
        if yesno(question):
            freed += cleanup()

    log_step("Finished cleanup.")
    log_success(f"Total freed overall: {format_size(freed)}")


if __name__ == "__main__":
    try:
        rmshit()
    finally:
        wait_for_keypress()
