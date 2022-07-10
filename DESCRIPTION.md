
---
### [choco://twinkle-tray](choco://twinkle-tray)
To use choco:// protocol URLs, install [(unofficial) choco:// Protocol support ](https://chocolatey.org/packages/choco-protocol-support)

---

Twinkle Tray lets you easily manage the brightness levels of multiple monitors. Even though Windows is capable of adjusting the backlight on most monitors, it typically doesn't support external monitors. Windows 10 & 11 also lack any ability to manage the brightness of multiple displays. This app inserts a new icon into your system tray, where you can click to have instant access to the brightness levels of all compatible displays.

![Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-twinkle-tray@ad59227d2bac35585d8e4831082727cc4e4d321b/tt-screenshot-w11.jpg)

## Features
  * Adds brightness sliders to the system tray, similar to the built-in Windows volume flyout.
  * Seamlessly blends in with Windows 10 and Windows 11. Uses your Personalization settings to match your taskbar.
  * Can automatically change monitor brightness depending on the time of day or when idle.
  * Bind hotkeys to adjust the brightness of specific or all displays.
  * Normalize backlight across different monitors.
  * Control DDC/CI features such as contrast.
  * Starts up with Windows.

### Design & Personalization
Twinkle Tray will automatically adjust the look and feel to match your Windows version and preferences. Additional options are available to select the Windows version and theme of your choice.

![Comparison Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-twinkle-tray@ad59227d2bac35585d8e4831082727cc4e4d321b/tt-comparison.jpg)

## Package Parameters

* `/NoShim` - Opt out of creating a shim, and removes any existing shim.
* `/Start` - Automatically start Twinkle Tray after installation completes.

## Package Notes

This package may create a [shim](https://docs.chocolatey.org/en-us/features/shim) named `twinkletray` to facilitate easier access to the command-line interface. However, `shimgen` will create a GUI shim, which will not wait for the underlying process to exit by default. This may cause issues with displaying console output when using the command-line interface or viewing debug messages. Users requiring this functionality should pass the `--shimgen-waitforexit` switch to ensure the shim behaves correctly.

---

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:
```
choco feature enable -n=useRememberedArgumentsForUpgrades
```

---

When using the `/Start` package parameter, you may see a large `CLIXML` block logged to `stderr`. This is [a known issue](https://github.com/chocolatey/choco/issues/1016) with Chocolatey's `Start-ChocolateyProcessAsAdmin` cmdlet, and is not necessarily indicative of an error condition. Until this is addressed, you should ensure the `failOnStandardError` feature is disabled while installing/upgrading this package.
