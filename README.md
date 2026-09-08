# Shabab — Attendance & Management App

Flutter rebuild of the 17-screen Figma design, unified into one consistent
design system with full dark **and** light mode.

## Run it

```bash
flutter pub get
flutter run
```

Requires Flutter 3.x (Material 3). No backend is wired up — everything runs
on realistic mock data in `lib/data/mock_data.dart`, held in memory by
`lib/state/app_state.dart`, so you can fully click through every flow.

## Demo logins

The login screen has tap-to-fill buttons for these three accounts:

| Role | Phone |
|---|---|
| Murabbi | 0300 1112223 |
| Park Admin (also a Murabbi) | 0300 2223334 |
| City / IT Masul | 0300 3334445 |

Password field is prefilled and not actually checked (mock auth) — just tap
**Sign In**. Swap `AppState.login()` for a real API call when you have a
backend.

## What's consistent now (vs. the original mockups)

- **One header pattern** (`ScreenHeader`) for every pushed screen: back
  button, title, subtitle, optional trailing action — previously spacing and
  structure varied screen to screen.
- **One card system** (`AppCard`): same radius, border, and padding
  everywhere instead of ad-hoc containers.
- **One status language**: Present/Absent/Late/Leave always use the same
  4 colors and the same `AttendanceStatusSelector`; Marked/Not Marked always
  uses the same `MarkedStatusChip`.
- **One home-header layout** (`HomeGreetingHeader`) shared by all three
  roles — avatar, greeting, role badge, date, theme toggle.
- **One mark-attendance flow** (`MarkAttendanceScreen`) reused for: Murabbi's
  own group, Park Admin's own group, Mark Murabbeen, and the "tap an
  unmarked group" shortcut from All Groups Status — instead of four
  near-duplicate screens.

## Theming

`lib/theme/app_colors.dart` holds every color as a named token; both themes
are built from the same brand hues taken from the splash gradient
(indigo → plum → crimson) and the same semantic status colors
(green/amber/red/blue), so light mode reads as the same brand, just on a
bright surface instead of a dark one. Toggle it from Profile & Settings, or
programmatically via `context.read<AppState>().toggleTheme()`.

## Structure

```
lib/
  theme/          color tokens + ThemeData for dark & light
  models/         AppUser, ParkInfo, GroupInfo, ShababMember, AttendanceStatus
  data/           mock_data.dart — swap for a real API/Firestore layer
  state/          AppState (ChangeNotifier) — auth, theme, attendance
  widgets/        shared UI components used across every screen
  screens/
    shared/       splash, login, role router, mark-attendance, profile
    murabbi/      home, report, leaderboard, shell
    park_admin/   home, all-groups-status, group-detail, report,
                  registration, shell
    city_masul/   home, park-wise-attendance, park-detail, report, shell
```

## Wiring up a real backend

Everything funnels through `AppState` and `MockData`. To connect a backend:

1. Replace `MockData.findUser()` in `AppState.login()` with your auth call.
2. Replace the static lists in `mock_data.dart` with API/Firestore fetches.
3. Replace the in-memory maps in `AppState` (`markGroupAttendance`,
   `markMurabbeenAttendance`, etc.) with writes to your backend, then call
   `notifyListeners()` on success.

No screen talks to `mock_data.dart` directly, so this is a contained change.
