
---
### [choco://twinkle-tray](choco://twinkle-tray)
To use choco:// protocol URLs, install [(unofficial) choco:// Protocol support ](https://chocolatey.org/packages/choco-protocol-support)

---

Twinkle Tray lets you easily manage the brightness levels of multiple monitors. Even though Windows 10 is capable of adjusting the backlight on most monitors, it typically doesn't support external monitors. Windows 10 also lacks any ability to manage the brightness of multiple monitors. This app inserts a new icon into your system tray, where you can click to have instant access to the brightness levels of all compatible monitors.

## Package Parameters

* `/NoShim` - Opt out of creating a shim, and removes any existing shim.
* `/Start` - Automatically start Twinkle Tray after installation completes.

## Package Notes

This package may create a [shim](https://docs.chocolatey.org/en-us/features/shim) named `twinkletray` to faciliate easier access to the command-line interface. However, `shimgen` will create a GUI shim, which will not wait for the underlying process to exit by default. This may cause issues with displaying console output when using the command-line interface or viewing debug messages. Users requiring this functionality should pass the `--shimgen-waitforexit` switch to ensure the shim behaves correctly.

---

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:
```
choco feature enable -n=useRememberedArgumentsForUpgrades
```

---

When using the `/Start` package parameter, you may see a large `CLIXML` block logged to `stderr`. This is [a known issue](https://github.com/chocolatey/choco/issues/1016) with Chocolatey's `Start-ChocolateyProcessAsAdmin` cmdlet, and is not necessarily indicative of an error condition. Until this is addressed, you should ensure the `failOnStandardError` feature is disabled while installing/upgrading this package.
