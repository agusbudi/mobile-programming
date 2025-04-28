# 06. Firebase

[Previous](/05.%20Form/) | [Main Page](/) | [Next](/07.%20Awesome%20Notifications/)

## Content Outline

- [Forms](#forms)
  - [TextField](#textfield)
  - [TextEditingController](#TextEditingController)
  - [Form Widget](#form-widget)


## 🔥 Setting Up Firebase Console for Your Flutter App

Before you can connect your Flutter app to Firebase, you need to set up your project on the Firebase Console. This process is very straightforward, you’ll only need a Google account.

---

### 🟢 Step 1: Log In to Firebase

To begin, open your web browser and head to the Firebase Console by visiting:

👉 [https://console.firebase.google.com](https://console.firebase.google.com)

Once the page loads, log in using your Google account. If you're already signed into Gmail or other Google services, you’ll probably be logged in automatically. Otherwise, just enter your email and password to continue.

---

### 🟢 Step 2: Create a New Firebase Project

After logging in, you’ll see the Firebase Dashboard. Find the button that says **“Add project”** or **“Create project”** and click on it to begin setting up your new project. 

You’ll be asked to enter a **name** for your project — this can be anything you like, such as `flutter-notes-app`.

On the next screen, you might see options to enable **Google Analytics** and **Gemini**. For now, you can skip these by turning them off. Disabling Google Analytics will make the setup process quicker and simpler.

---

### 🟢 Step 3: Enable Firestore Database

Now that your project is created, it’s time to set up the database. In the left-hand sidebar, click on **Build**, and then select **Firestore Database** from the dropdown menu.

Once you’re on the Firestore page, you’ll see a button that says **“Create database.”** Click on it to begin.

---

### 🟢 Step 4: Choose the Firestore Location

Next, Firebase will ask you to choose a location for your Firestore database. This location determines where your data is stored.

For the best performance, since we're in Southeast Asia, choose **Singapore** or **Jakarta** as the region. 

---

### 🟢 Step 5: Set Security Rules for Firestore

Once your database is created, you’ll be taken to the **Security Rules** screen. Firebase will suggest using **Production Mode**, which means the database will start with stricter access by default. This is a good choice for safety, and you can change the rules later when needed.

To allow your app to start writing to the database during development, you’ll need to change the default rules.

Click on the **“Rules”** tab, and you’ll see a block of code like this:

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

Here’s what to do:

- Change `if false` to `if true`. This will temporarily allow full access while you're building and testing your app.

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

- After editing the rules, click **“Publish”** to save the changes.

You might see a warning that this setting makes your database public. That’s okay for now while we’re still learning.

---

Absolutely! Let's continue with the **Flutter & Android Studio integration** section — keeping the tone friendly and beginner-friendly, with more detailed code snippets and explanations.

---

## 🤖 Connecting Flutter to Firebase (Android Studio Setup)

Now that you’ve finished setting up your Firebase project, it’s time to connect it to your Flutter app. We’ll do this in a few steps: installing the right tools, linking your Firebase project, and adding the necessary packages to your Flutter project. 

---

### 🛠 Step 1: Install Firebase CLI & FlutterFire CLI

To get started, you’ll need to install some tools so that Flutter can connect to Firebase.

Open **Terminal** inside your IDE, while opening your Flutter project. Type these commands one by one:

```bash
npm install -g firebase-tools
```

This installs Firebase CLI globally using Node.js. You only need to do this once.

Next, log into Firebase:

```bash
firebase login
```

After you run this, a browser window will pop up asking you to sign in to your Google account. This is the same account you used to set up your Firebase project earlier.

Then, activate the FlutterFire CLI:

```bash
flutter pub global activate flutterfire_cli
```

And finally, link your Flutter app to the Firebase project using:

```bash
flutterfire configure
```

> 💡 **Tip**: When running `flutterfire configure`, it will ask you to choose a Firebase project from your account. Make sure to pick the same project you created in the Firebase Console.

Once this is done, FlutterFire will automatically generate a file called `firebase_options.dart` in your `lib` folder. This file contains the config info needed to initialize Firebase in your app.

---

### 📦 Step 2: Add Firebase Packages to Flutter

Now let’s add the necessary Firebase packages to your project.

In your terminal, run the following commands:

```bash
flutter pub add firebase_core
flutter pub add cloud_firestore
```

These two packages are essential:

- `firebase_core` helps initialize Firebase in your Flutter app
- `cloud_firestore` lets your app read/write data from Firestore

After adding them, also make sure to run:

```bash
flutter pub get
```

This will make sure the packages are properly downloaded and linked to your app.

---

### ⚠️ Step 3: Fix Android NDK Version (If You See an Error)

Sometimes, you might see an error related to the **NDK version** when you build the app on Android. If that happens, here’s how to fix it.

Go to this file in your Flutter project:

```
android/build.gradle.kts
```

Or sometimes inside:

```
android/app/build.gradle.kts
```

Inside the `android` block, specify the NDK version like this:

```kotlin
android {
    ndkVersion = "27.0.12077973"
    
    // ... other settings
}
```

Save the file, and try running your app again.
