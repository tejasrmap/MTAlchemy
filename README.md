# MT Alchemy (Kaedae People Development Consultancy)
## Enterprise Cross-Platform LMS, Facilitation E-Store & Executive EQ Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20Hosting-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Live WebApp](https://img.shields.io/badge/Live%20Demo-mtalchemy--aug2026.web.app-10B981?logo=googlechrome&logoColor=white)](https://mtalchemy-aug2026.web.app)
[![Coursework](https://img.shields.io/badge/INTI%20BCSI-NET4207%20Mobile%20Apps-7C3AED)](https://newinti.edu.my)

An enterprise-grade cross-platform application developed for **MT Alchemy** (Kaedae Event Management), a Malaysian people development consultancy specializing in Emotional Intelligence (EQ), leadership development, team resilience, and workplace well-being.

---

###  Key Highlights & Deliverables
- **Live Production URL:** [https://mtalchemy-aug2026.web.app](https://mtalchemy-aug2026.web.app)
- **Firebase Project Console:** `mtalchemy-aug2026`
- **Zero-Trust Security:** Role-Based Access Control (RBAC) across 5 distinct portals.
- **5 Core User Journeys:** LMS Academy, Instant Digital Guides, Physical Facilitation Kits, Employer Corporate Portal & B2B RFP Enquiry Engine.
- **Academic Verification:** Fully complies with INTI NET4207 Coursework Specification (30 Marks Lab Test + Assignment 1 + Final Project).

---

###  Project Architecture
```
MTAlchemy/
├── mt_alchemy_app/
│   ├── lib/
│   │   ├── core/            # Theme, constants, validators & design tokens
│   │   ├── models/          # 8 Business logic entity models
│   │   ├── providers/       # 7 Provider state management controllers
│   │   ├── screens/         # Screens for all 5 journeys, portals & lab test
│   │   ├── services/        # Firebase, Mock DB, Payment & URL Sync
│   │   └── widgets/         # Custom AppBar, Footer, RBAC Guards, StatCards
│   ├── test/                # Unit, security, and responsive aspect-ratio test suites
│   ├── web/                 # PWA manifests, icons, and HTML5 path routing
│   ├── android/             # Native Gradle build scripts
│   └── pubspec.yaml         # Project dependencies and asset declarations
├── NET4207_MTAlchemy_Complete_Report.md
└── README.md
```

---

###  Quick Start
```bash
cd mt_alchemy_app

# Install dependencies
flutter pub get

# Run all test suites
flutter test

# Run web app
flutter run -d chrome
```

---

### 👨‍💻 Author & Coursework Details
- **Student / Developer:** Teja Ganugula ([@tejasrmap](https://github.com/tejasrmap))
- **Program:** Bachelor of Computer Science (Hons) (BCSI)
- **Institution:** Faculty of Engineering and Quantity Surveying (FEQS), INTI International University
- **Module:** NET4207 Cross Platform Mobile Apps Development
