# pharmasage

Pharmasage is a Flutter-based pharmacy and store management system with role-based access for **Admin/Owner**, **Branch Managers**, and **Vendors**. It provides end‑to‑end workflows for inventory, purchasing, sales, returns, vendor management, and analytics, backed by Firebase.

## Table of Contents

- **Overview**
- **Features**
- **Tech Stack**
- **Project Structure**
- **Getting Started**
- **Configuration**
- **Core Flows**
- **Building & Release**
- **Troubleshooting**

## Overview

Pharmasage digitizes the daily operations of a pharmacy / retail store. It helps administrators and vendors collaborate on:

- Managing branches and branch managers
- Maintaining product and inventory data
- Handling purchase orders, sales, and returns
- Tracking vendor products and orders
- Viewing key metrics and statistics via dashboards

The app is built with Flutter using Provider for state management and Firebase (Auth, Firestore, Storage) for backend services.

## Features

- **Role-based access and onboarding**
  - Role selection screen (`RoleSelectionScreen`) for Admin/Owner and Vendor.
  - Persisted role using `SharedPreferences` for seamless return to the correct flow.
  - Different dashboards and navigation flows based on role.

- **Authentication & User Profiles**
  - Firebase Authentication integration.
  - User data stored in Cloud Firestore under a `Users` collection.
  - Role-aware profile loading via `AdminProvider` (distinguishes Pharmacist / Vendor / Branch Manager profiles).
  - Profile images stored in Firebase Storage and managed inside the app.

- **Admin / Owner Console**
  - Main dashboard (`Dashboard`, `MainDashboard`) with a navigation drawer.
  - Manage **Shop Settings** (configuration related to the pharmacy or shop).
  - Manage **Branch Managers** (listing, assigning, and viewing branch manager details).
  - Access to store dashboards (`storeDashboard`) per branch.

- **Vendor Portal**
  - Dedicated vendor dashboard (`VendorDashboard`) with its own drawer and pages.
  - **Products management** (`vendorProducts`) for managing vendor-side product catalog.
  - **Orders** views for received orders (`ReceivedOrders`) and accepted orders (`AcceptedOrders`).

- **Store & Operations Management**
  - Store dashboard (`storeDashboard`) that links to:
    - Branch Manager page
    - Employees management page
    - Inventory page
    - Purchase page
    - Sales page
    - Returns page
    - Orders details
    - Vendors and vendor product expiry report
    - Statistics / analytics screens

- **Inventory, Sales & Returns**
  - Inventory and stock handling pages (`InventoryPage`, related controllers/providers).
  - POS‑related flows (e.g. `POSSplash`, `POSProvider`, `CartProvider`, `InventoryCartProvider`).
  - Returns managed via `ReturnProvider` and dedicated UI screens.

- **Analytics & Reporting**
  - Statistics screens (`Satistics.dart`) with charts using `fl_chart`.
  - PDF and report generation leveraging `pdf` and `syncfusion_flutter_pdf`.

- **User Experience Enhancements**
  - Rich theming (`theme.dart`), custom fonts (OpenSans), and shared UI components.
  - Reusable widgets such as custom drawers (`Utils/widgets/Drawer.dart`).
  - Toasts, motion toasts, and spinners (`motion_toast`, `fluttertoast`, `flutter_spinkit`) for better feedback.

## Tech Stack

- **Framework**: Flutter (Dart), Material Design
- **State Management**: `provider`
- **Backend**: Firebase
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `firebase_storage`
- **Local & Device**
  - `shared_preferences` for local role/user settings
  - `sqflite` for local persistence and caching
  - `path_provider`, `open_file`, `permission_handler` for file and storage access
- **Media & Files**
  - `image_picker` and `file_picker` for images and files
  - `pdf`, `syncfusion_flutter_pdf` for PDF creation
- **UI & UX**
  - `google_fonts` for typography
  - `badges`, `fl_chart`, `dotted_border`, `page_transition`, `motion_toast`, `flutter_spinkit`
- **Networking**: `http`

## Project Structure (high level)

Key directories and files:

- **`lib/main.dart`**
  - App entry point.
  - Initializes Firebase using `firebase_options.dart`.
  - Registers all `ChangeNotifierProvider`s (Admin, Product, Store, Employee, Cart, POS, InventoryCart, Return).
  - Wraps the app in `MaterialApp` with the custom theme and initial `SplashScreen`.

- **`lib/Controller/Provider`**
  - Business logic and app‑wide state:
    - `Authprovider.dart` (`AdminProvider`) for auth, role, and profile handling.
    - `ProductProvider.dart`, `StoreProvider.dart`, `EmployeeProvider.dart`, `CartProvider.dart`, `POSProvider.dart`, `InventoryCartProvider.dart`, `ReturnProvider.dart`, etc.

- **`lib/View`**
  - UI screens and flows:
    - Entry & navigation: `SplashScreen.dart`, `MainScreen.dart`, `RoleSelection.dart`.
    - Dashboards: `Dashboard.dart`, `VendorDashboard.dart`, `StoreDashboard.dart`, `Maindashboard.dart`.
    - Operations: `BranchManagerPage.dart`, `EmployeesPage.dart`, `InventoryPage.dart`, `PurchasePage.dart`, `SalesPage.dart`, `ReturnsPage.dart`, `OrdersDetails.dart`, `VendorsPage.dart`, `Vendors/ProductExpiryReport.dart`, `Vendors/PvendorsProduct.dart`, `Vendors/ReceivedOrders.dart`, `Vendors/AcceptedOrders.dart`.

- **`lib/Constants`**
  - Shared utilities such as `CommonFunctions.dart` for helpers (spacing, pop‑up menus, etc.).

- **`lib/Utils`**
  - `theme.dart`, `colors.dart`, and shared widgets such as `widgets/Drawer.dart`.

- **`assets/`**
  - Images and icons (referenced in `pubspec.yaml`):
    - `assets/images/`
    - `assets/Icons/`
  - Fonts: `assets/fonts/OpenSans-Regular.ttf`.

## Getting Started

### Prerequisites

- Flutter SDK `>= 3.1.0 < 4.0.0` installed and configured.
- Dart SDK that matches the Flutter channel.
- A configured **Firebase project** (Web / Android / iOS as needed).

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd pharmasage-master
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Pharmasage uses `firebase_core`, `firebase_auth`, `cloud_firestore`, and `firebase_storage`.

1. Create a Firebase project from the Firebase console.
2. Add your desired platforms (Android, iOS, Web, etc.).
3. Use **FlutterFire CLI** to generate `firebase_options.dart`:

   ```bash
   flutterfire configure
   ```

4. Ensure `lib/firebase_options.dart` exists and matches your Firebase project.
5. Check that `main.dart` is calling `Firebase.initializeApp` with `DefaultFirebaseOptions.currentPlatform`.

### 4. Run the app

```bash
flutter run
```

Choose the appropriate target device (emulator or physical device).

## Configuration

- **Firebase**
  - All keys and configuration are handled through `firebase_options.dart` (generated by FlutterFire).
  - Ensure the `google-services.json` / `GoogleService-Info.plist` files are added to the appropriate platform folders if building for Android/iOS.

- **Assets & Fonts**
  - Image and icon assets are configured in `pubspec.yaml` under the `flutter.assets` section.
  - The OpenSans font is configured under `flutter.fonts`.

- **Permissions**
  - The app uses camera/gallery and file access through `image_picker`, `file_picker`, and `permission_handler`.
  - Make sure to add the appropriate permissions for Android and iOS in `AndroidManifest.xml` and `Info.plist` respectively.

## Core Flows

### Authentication & Role Selection

1. User opens the app and sees the `SplashScreen`.
2. Navigation moves to `MainScreen`, which checks a stored `userRole` from `SharedPreferences`.
3. If a role is already stored, the user is redirected to the appropriate login/dashboard screen.
4. If not, the `RoleSelectionScreen` is shown:
   - Selecting **Admin** updates the role (via `UserHandler` / `vendorServices.dart` and `AdminProvider`) and opens the `Dashboard`.
   - Selecting **Vendor** updates the role and opens the `VendorDashboard`.

### Admin Dashboard

- Top‑level navigation through a drawer with:
  - **Dashboard** (`MainDashboard`)
  - **Shop Setting**
  - **Branch Managers**
- Profile avatar and main menu via `CommonFunctions.showMainPopupMenu`.

### Vendor Dashboard

- Drawer navigation with:
  - **Products** (vendor product catalog)
  - **Orders** (received orders)
  - **Accepted Orders**
- Vendor profile avatar loaded from Firestore / Storage.

### Store & POS Operations

- Store dashboard links to:
  - Inventory management
  - Employees and branch managers
  - Purchase and sales flows (POS)
  - Returns, orders, vendors, and expiry reports
  - Statistics / analytics pages

## Building & Release

Build commands (examples):

- **Android APK**:

  ```bash
  flutter build apk --release
  ```

- **Android App Bundle**:

  ```bash
  flutter build appbundle --release
  ```

- **Web** (if configured):

  ```bash
  flutter build web --release
  ```

Make sure Firebase is configured for each target platform before releasing.

## Troubleshooting

- **Firebase initialization errors**
  - Confirm `firebase_options.dart` exists and is imported in `main.dart`.
  - Ensure platform configuration (Android/iOS/Web) is complete in the Firebase console.

- **Missing assets (red screens / image not found)**
  - Verify images exist in `assets/images/` or `assets/Icons/`.
  - Ensure paths are correct in `pubspec.yaml` and that `flutter pub get` has been run.

- **Permission issues (camera/gallery/files)**
  - Check that runtime permissions are granted on device.
  - Confirm Android/iOS platform permission entries are present.

- **Build failures after dependency changes**
  - Run `flutter clean` followed by `flutter pub get`.
  - Make sure your Flutter SDK version satisfies the constraint in `pubspec.yaml`.

