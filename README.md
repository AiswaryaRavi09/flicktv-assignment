# Blinkit Money — Flutter Task

**Candidate:** Aiswarya
**Package:** `flicktv.aiswarya`
**App Name:** Aiswarya



## Features

- Animated wallet onboarding screen with multi-phase choreography
- Dual-cannon confetti burst (left and right)
- Gift card claim screen with input validation
- Dark and Light theme with persistence across restarts
- Responsive scrollable layout for all screen sizes
- Custom wallet icon drawn with `CustomPainter`
- Flutter built-in state management (`ChangeNotifier`, `ValueNotifier`, `InheritedNotifier`)

---

## Screens

### Home
- Multi-stage wallet entry animation
- Feature highlight cards
- Add Money CTA
- Settings shortcut

### Claim Gift Card
- 16-digit gift card code entry
- Input validation and loading state

### Settings
- Dark / Light theme toggle
- Live theme preview
- Theme persists across app restarts


## Project Structure

```
lib/
├── app/
│   └── routes/              
├── core/
│   ├── constants/           
│   ├── theme/               
│   └── utils/              
├── features/
│   ├── home/
│   │   ├── controller/     
│   │   ├── model/          
│   │   └── view/
│   │       ├── home_view.dart
│   │       └── widgets/    
│   ├── gift_card/
│   │   ├── controller/     
│   │   └── view/           
│   └── settings/
│       └── view/            
└── main.dart                


## Assets

| Asset | Purpose |
| --- | --- |
| `assets/fonts/Poppins-*.ttf` | Custom font (Regular → Black weights) |
| `assets/app_icon.png` | Source icon used to generate launcher icons |

---

## Packages

None. The project uses only:

- `flutter` SDK
- `flutter_test` (dev — testing only)
- `flutter_lints` (dev — static analysis only)

---

## Setup & Run

```bash
flutter pub get
flutter run
```

**Minimum SDK:** Android 21 · iOS 12