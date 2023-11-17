# 04Academy Khaled Hossameldin Task

This Flutter project is a solution to an interview task consisting of three tasks. The tasks resolve around integrating Firebase Authentication, implementing role-based authorization using Firebase, and incorporating Firebase Cloud Messaging for notifications. Additionally, local notfications are integrated for a seamless user experience.

## Table of Contents

- [Features](#features)
  - [Task A](#task-a-firebase-authentication-and-login-form-validation)
  - [Task B](#task-b-role-based-authorization-with-firestore)
  - [Task C](#task-c-firebase-cloud-messaging-notificaitons)
- [Setup Steps](#setup-steps)
- [Usage](#usage)
- [Tasks Overview](#tasks-overview)
  - [Task A](#task-a-authentication-implementation)
  - [Task B](#task-b-role-based-access-control)
  - [Task C](#task-c-push-notification-integration)
- [Dependencies](#dependencies)

## Features

### Task A: Firebase Authentication and Login Form Validation

- **Firebase Authentication:** Implemented user authentication user Firebase Authentication.
- **Login Form Validation:** Ensured secure login by implementing form validation for user input.

### Task B: Role-Based Authorization with Firestore

- **Firestore Database:** Utilized Firebase Firestore to create a "users" collection with two documents.
- **Role-Based Athorization:** Assigned roles ("admin" and "user") to specific email addresses for role-based access control.

### Task C: Firebase Cloud Messaging Notificaitons

- **Firebase Cloud Messaging:** Integrated Firebase Cloud Messaging for push notifications.
- **Local Notifications:** Implemented local notifications for cases when the app is open as Firebase Messaging does not view notification if the app is open.

### Additional Features

- **Notification Form:** Added a feature to send notifications with a form containing title and body for easy testing.
- **Logout:** Implemented a logout feature to facilitate testing and switching between user and admin roles.

## Setup Steps

1. **Clone the Repository:**

```bash
git clone https://github.com/KhaledHossameldin/04academy-task-flutter.git
```

2. **Navigate to Project Directory:**

```bash
cd 04academy-task-flutter
```

3. **Install Dependencies:**

```bash
flutter pub get
```

4. **Run the App:**

```bash
flutter run
```

## Usage

1. **Login:**

- There are only two accounts:
  - User:
    - user@email.com
    - 123456
  - Admin:
    - admin@email.com
    - 123456

2. **Role-Based Authorization:**

- The text in the Home Screen will change depending whether you logged in with a user or an admin

3. **Notifications:**

- Send notifications using the provided form, which includes title and body fields
- Observe both Firebase Cloud Messaging and local notifications (FCM when the app is in the background and local notifications when the app is open)
- **Note** that receiving notifications will not work with iPhone as it requires APN Key which unfortunately requires an Apple Developer account.

4. **Logout:**

- Use the logout button to logout and return to the login screen to switch between user and roles for testing.

## Tasks Overview

### Task A: Authentication Implementation

- **Objective:** Develop a Flutter login screen with email and password authentication.
  Implement form validation and robust error handling.
  Ensure your code is well-commented.

### Task B: Role-Based Access Control

- **Objective:** Create a Flutter widget displaying content based on user roles (admin, user).
  Use mock data to simulate different user roles.
  Document your approach within the code.

### Task C: Push Notification Integration

- **Objective:** Integrate Firebase Cloud Messaging (FCM) in a sample Flutter application.
  Demonstrate handling of notifications in various app states.
  Include a README.md file detailing setup and usage instructions.

## Dependencies

- [Firebase Authentication](https://pub.dev/packages/firebase_auth)
- [Firebase Firestore](https://pub.dev/packages/cloud_firestore)
- [Firebase Cloud Messaging](https://pub.dev/packages/firebase_messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [BLoC](https://pub.dev/packages/bloc)
