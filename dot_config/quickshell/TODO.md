# TODO

## UI and shared primitives

- Centralize the 150 ms tooltip hover delay in a reusable wrapper.
- Add a shared `withAlpha()` theme palette for common surface colors.
- Add a color picker and an infinitely scrolling wallpaper selector.

## Portability and capability detection

- Detect commands and services (`pactl`, `playerctl`, `iwctl`,
  `bluetoothctl`, `acpi`, `inotifywait`, `jq`, and compositor tools).
- Hide or disable widgets when their backends are unavailable.
- Discover network interfaces and power supplies instead of using
  fixed `wlan0` and `BAT0` paths.
- Discover GPU data through generic `/sys` and `hwmon` paths.
- Show explicit unavailable values instead of fake measurements.
- Isolate compositor-specific behavior behind an adapter if Hyprland
  is not a hard requirement.
- Resolve XDG paths centrally with standard fallbacks.

## Themes and layout

- Define one canonical theme JSON schema.
- Make theme IPC select a named theme explicitly.
- Replace fixed panel and selector dimensions with screen dimensions
  and theme spacing properties.
- Add a theme-level widget registry shared by all themes.

## Runtime reliability

- Add a process wrapper with consistent command and parse errors.
- Debounce bursts of network address and link events.
- Keep wireless scans and ISP speed tests popup-scoped and cancellable.
- Replace media metadata delimiters with structured or escaped data.
- Show visible diagnostics for failed generated files and fallback data.

## Security and threat monitoring

- Add a dedicated threat widget and singleton for:
  - Failed SSH authentication and unusual authentication activity.
  - New listening sockets, network interfaces, and established connections.
  - Failed systemd services and AppArmor/LSM denials.
  - Firewall state changes and listening-port status.
  - Disk-encryption status.
  - Secure Boot and kernel-lockdown state.
  - Unexpected privilege escalation events.
- Show concise event details, such as source, process, address, and time.
- Add update categories such as security, system, and miscellaneous.

## Network

- Add a network QR-code view and captive-portal support.
- Show saved Wi-Fi passwords only after explicit confirmation.
- Add a richer VPN popup with interface, address, endpoint, and rates.

## Power

- Add battery percentage, estimate, health, cycle count, and
  charge-limit information.

## Bootstrap and dotfiles

- Add an installation script for fresh devices.
- Check dependencies and generate portable configuration paths.
- Support dotfiles for all usernames and avoid machine-specific
  absolute paths.
