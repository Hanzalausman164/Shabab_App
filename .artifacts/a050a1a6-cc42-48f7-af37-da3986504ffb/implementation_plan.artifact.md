# Implementation Plan - Logo Integration & Stability Fixes

This plan integrates the new Shabab logo (using SVG for best quality), fixes the "black screen" rendering issue, and modernizes the code by resolving deprecation warnings.

## Proposed Changes

### [Component: Core & Assets]

#### [MODIFY] [pubspec.yaml](file:///D:/Shabab app/shabab_app (1)/shabab_app/pubspec.yaml)
- Add `flutter_svg` dependency.
- Register the `assets/images/` directory.

#### [MODIFY] [main.dart](file:///D:/Shabab app/shabab_app (1)/shabab_app/lib/main.dart)
- Add `WidgetsFlutterBinding.ensureInitialized()` to prevent startup crashes/black screens on some devices.

---

### [Component: UI - Logo Replacement]

#### [MODIFY] [splash_screen.dart](file:///D:/Shabab app/shabab_app (1)/shabab_app/lib/screens/shared/splash_screen.dart)
- Replace the `_LogoMark` (yoga icon) with an `SvgPicture` showing the new Shabab logo.
- Update `withOpacity` to `withValues(alpha: ...)` for cleaner logs.

#### [MODIFY] [login_screen.dart](file:///D:/Shabab app/shabab_app (1)/shabab_app/lib/screens/shared/login_screen.dart)
- Replace the hardcoded `Icon` with the logo `SvgPicture`.
- Update `withOpacity` to `withValues(alpha: ...)` for error messages.

---

### [Component: Global Cleanup]

#### [MODIFY] [Multiple Files]
Replace all instances of `withOpacity(x)` with `withValues(alpha: x)` to resolve Flutter deprecation warnings in:
- `lib/widgets/common_widgets.dart`
- `lib/theme/app_theme.dart`
- `lib/screens/city_masul/park_detail_screen.dart`
- `lib/screens/city_masul/report_screen.dart`
- `lib/screens/murabbi/leaderboard_screen.dart`
- `lib/screens/park_admin/group_attendance_detail_screen.dart`
- `lib/screens/shared/mark_attendance_screen.dart`
- `lib/screens/shared/profile_settings_screen.dart`

## Verification Plan

### Automated Tests
- Run `flutter pub get` to verify dependencies.
- Run `flutter analyze` to ensure no syntax errors.

### Manual Verification
- **Splash Screen:** Verify the new logo appears correctly against the gradient.
- **Login Screen:** Verify the logo appears in the circular header.
- **Rendering:** Confirm the app no longer shows a black screen on startup.
