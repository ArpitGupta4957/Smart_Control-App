<div align="center">

# Atomberg Smart Fan Controller

Beautiful, responsive Flutter app for controlling Atomberg smart fans. Designed to impress at a glance: smooth animations, clean gradients, and an intuitive dashboard. Ships with Mock Mode out of the box, and can connect to real APIs when needed.

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart&logoColor=white)
![Platforms](https://img.shields.io/badge/Platforms-Android%20|%20iOS%20|%20Web-6A5ACD)

</div>

## Highlights

- Elegant dashboard with animated fan cards and status chips
- One-tap controls: power, speed, breeze, and light
- Mock Mode ready by default — no backend required to demo
- Dark mode, Material 3 theming, subtle gradients and motion
- Clean architecture (domain/data/presentation) with Provider

## Screenshots

Add your screenshots here (optional) for extra polish:

![Device List - Grid](assets/images/screenshots/device-list.png)
![Device Control - Details](assets/images/screenshots/device-control.png)

> Tip: Use 1440×900 or device frames for best visual impact.

## Quick Start

1) Install dependencies

```bash
flutter pub get
```

2) Run (Mock Mode)

```bash
# Web
flutter run -d chrome

# Android/iOS
flutter run
```

3) Run tests (optional)

```bash
flutter test
```

## Real API (Optional)

Switch from Mock Mode to live data in a minute:

- In [lib/presentation/screens/device_list_screen.dart](lib/presentation/screens/device_list_screen.dart):
	- Uncomment the provider calls in `initState()` and `_onRefresh()`.
- In [lib/presentation/screens/device_control_screen.dart](lib/presentation/screens/device_control_screen.dart):
	- Uncomment the provider calls in control methods (power/speed/light/breeze).
- Update API settings if needed in [lib/core/constants/api_constants.dart](lib/core/constants/api_constants.dart).

## Tech Stack

- Flutter, Dart, Material 3
- Provider (state), Dio (network), Shared Preferences (storage)
- Shimmer (loading), Animations throughout

## Project Structure (Brief)

```
lib/
	core/         // theme, constants, network utils
	domain/       // entities, repos, usecases
	data/         // services, repositories, models
	presentation/ // screens, widgets, providers, animations
```

## Notes

- Mock Mode is enabled for a fast demo experience (no API keys required).
- Real API can be toggled later without changing UI code.

---

Made with Flutter — crafted for a delightful first impression.
