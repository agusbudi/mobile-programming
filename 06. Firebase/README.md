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

<p align="center">
  <img src="https://github.com/user-attachments/assets/d88a3ad8-8c75-4433-baa3-8e508940abfc" height="350"/>
</p>

You’ll be asked to enter a **name** for your project — this can be anything you like, such as `flutter-notes-app`.

<p align="center">
  <img src="https://github.com/user-attachments/assets/c268cc5e-7c53-475c-af71-932515f1db7b" height="350"/>
</p>

On the next screen, you might see options to enable **Google Analytics** and **Gemini**. For now, you can skip these by turning them off. Disabling Google Analytics will make the setup process quicker and simpler.

<p align="center">
  <img src="https://github.com/user-attachments/assets/89d10039-9c3b-48d8-89e1-77dcf15a5663" height="350"/>
  <img src="https://github.com/user-attachments/assets/b5c4fb03-9a56-4a26-81e5-0b58b9ab9568" height="350"/>
</p>

---

### 🟢 Step 3: Enable Firestore Database

Now that your project is created, it’s time to set up the database. In the left-hand sidebar, click on **Build**, and then select **Firestore Database** from the dropdown menu.

<p align="center">
  <img src="https://github.com/user-attachments/assets/180fe48f-df31-45d8-89e2-07d585dcb813" height="350"/>
</p>

Once you’re on the Firestore page, you’ll see a button that says **“Create database.”** Click on it to begin.

<p align="center">
  <img src="https://github.com/user-attachments/assets/c280124f-8ff5-42ae-a1ab-be0fa59afe99" height="350"/>
</p>

---

### 🟢 Step 4: Choose the Firestore Location

Next, Firebase will ask you to choose a location for your Firestore database. This location determines where your data is stored. For the best performance, since we're in Southeast Asia, choose **Singapore** or **Jakarta** as the region. 

<p align="center">
  <img src="https://github.com/user-attachments/assets/0697f005-9f2a-4727-a31e-ef3da3103e4f" height="350"/>
</p>

---

### 🟢 Step 5: Set Security Rules for Firestore

Once your database is created, you’ll be taken to the **Security Rules** screen. Firebase will suggest using **Production Mode**, which means the database will start with stricter access by default. This is a good choice for safety, and you can change the rules later when needed.

<p align="center">
  <img src="https://github.com/user-attachments/assets/1f9d7dd0-315c-473c-8a85-2b0491f70689" height="350"/>
</p>

To allow your app to start writing to the database during development, you’ll need to change the default rules. Click on the **“Rules”** tab, and you’ll see a block of code like this:

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

After editing the rules, click **“Publish”** to save the changes. You might see a warning that this setting makes your database public. That’s okay for now while we’re still learning.

<p align="center">
  <img src="https://github.com/user-attachments/assets/beefb6a2-7681-4d10-95a3-5873fe356b75" height="350"/>
</p>

---

## 🤖 Connecting Flutter to Firebase (Android Studio Setup)

Now that you’ve finished setting up your Firebase project, it’s time to connect it to your Flutter app. We’ll do this in a few steps: installing the right tools, linking your Firebase project, and adding the necessary packages to your Flutter project. 

---

### 🛠 Step 1: Install Firebase CLI & FlutterFire CLI

To get started, you’ll need to install some tools so that Flutter can connect to Firebase. Open **Terminal** inside your IDE, while opening your Flutter project. Type these commands one by one:

```bash
npm install -g firebase-tools
```

This installs Firebase CLI globally using Node.js. You only need to do this once.

Next, log into Firebase:

```bash
firebase login
```

After you run this, a browser window will pop up asking you to sign in to your Google account. This is the same account you used to set up your Firebase project earlier. Then, activate the FlutterFire CLI:

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

Sometimes, you might see an error related to the **NDK version** when you build the app on Android. If that happens, here’s how to fix it. Go to this file in your Flutter project:

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

---

## 🧩 Writing Simple CRUD with Flutter + Firebase

<div align="center">

  <a href="https://youtu.be/iQOvD0y-xnw" target="_blank">
    <img src="https://img.youtube.com/vi/iQOvD0y-xnw/hqdefault.jpg" alt="Watch the tutorial" width="480">
  </a>

  <p>
    📺 <a href="https://youtu.be/iQOvD0y-xnw" target="_blank">
      Watch the full reference tutorial on YouTube
    </a>
  </p>

</div>

Once our project is connected to Firebase, we can start writing the actual code for the app. In this section, we’re going to build a simple note-taking app using Flutter and Firebase Firestore. The app will let users add, view, edit, and delete short notes, and all of this will be saved to the cloud using Firebase. Thanks to Firestore’s real-time database updates, changes should appear instantly. 

<p align="center">
  <img src="https://github.com/user-attachments/assets/41d34f1d-9159-448b-8172-238648002c2e" height="500"/>
</p>

This project is made up of three main Dart files:

- `main.dart` → App entry point and Firebase setup
- `home_page.dart` → The UI and logic for interacting with notes
- `firestore.dart` → The service class that handles Firestore operations

---

### 🚀 `main.dart`: Setting Up the App

This is where your Flutter app starts running. The most important part here is **initializing Firebase** properly before rendering any UI.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

- `WidgetsFlutterBinding.ensureInitialized();` makes sure that Flutter is ready before Firebase initializes.
- `Firebase.initializeApp(...)` connects our app to Firebase using settings from `firebase_options.dart` (this file is auto-generated when you run `flutterfire configure`).
- Then we launch the app with `runApp`.

The UI starts with this simple widget:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
```

We’re using `HomePage()` as the first screen, which is where our notes will show up.

---

### 🏠 `home_page.dart`: The Notes UI

This is the main page where users can add, update, and delete notes. Let’s look at the key parts.

---

#### 🔗 Connecting to Firestore

First, we create an instance of our service class:

```dart
final FirestoreService firestoreService = FirestoreService();
```

We’ll use this to call `addNote`, `updateNote`, and `deleteNote` methods later.

---

#### ✍️ The Add/Update Dialog

Whenever the user wants to add or update a note, we open a dialog box:

```dart
void openNoteBox({String? docID, String? existingText}) {
  textController.text = existingText ?? '';

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(docID == null ? 'Add Note' : 'Update Note'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Enter your note here'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final text = textController.text.trim();
              Navigator.pop(context);

              // Decide whether to add or update
              if (docID == null) {
                firestoreService.addNote(text);
              } else {
                firestoreService.updateNote(docID, text);
              }
              // Reset the form
              textController.clear(); 
            }
          },
          child: Text(docID == null ? 'Add' : 'Update'),
        ),
      ],
    ),
  ).then((_) {
    // Reset if user taps outside dialog
    textController.clear(); 
  });
}
```

Here’s what it does:

- Shows a dialog with a text field.
- If it’s an **update**, it fills in the old note text.
- When submitted, it either calls `addNote()` or `updateNote()` depending on whether a `docID` was passed.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d24ae2d5-7f7f-4d2c-b119-1290e581440e" height="500"/>
  <img src="https://github.com/user-attachments/assets/edcef6df-2dcd-4656-be11-297de77dec22" height="500"/>
</p>

---

#### 📝 Displaying Notes

We use a `StreamBuilder` to **automatically update the list of notes**:

```dart
body: StreamBuilder(
  stream: firestoreService.getNotesStream(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      List notesList = snapshot.data!.docs;
```

- `getNotesStream()` gives us live updates from Firestore.
- Every time a note is added, updated, or deleted, the UI will refresh.

Inside the list builder:

```dart
return ListView.builder(
  itemCount: notesList.length,
  itemBuilder: (context, index) {
    DocumentSnapshot document = notesList[index];
    String docID = document.id;
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String noteText = data['note'];
```

We extract the note text and document ID so we can display it and know which one to update or delete. Each note looks like this:

<p align="center">
  <img src="https://github.com/user-attachments/assets/3bd69f74-3207-41aa-9130-a1647c79e563"/>
</p>

```dart
return ListTile(
  title: Text(noteText),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => openNoteBox(docID: docID, existingText: noteText),
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => firestoreService.deleteNote(docID),
      ),
    ],
  ),
);
```

It simply consists of:
- The note's text.
- One button to edit.
- One button to delete.

---

### 🔧 `firestore.dart`: Firebase Service Code

This file handles communication to Firestore, so we don’t clutter the UI code. 

---

#### 📌 Add a Note

```dart
Future<void> addNote(String note) {
  return notes.add({
    'note': note,
    'timestamp': Timestamp.now(),
  });
}
```

- Adds a new note to the `notes` collection.
- Also stores the current timestamp so we can sort later.

---

#### 🔁 Get Notes as a Stream

```dart
Stream<QuerySnapshot> getNotesStream() {
  return notes.orderBy('timestamp', descending: true).snapshots();
}
```

- This gives us real-time updates whenever the data changes.

---

#### ✏️ Update a Note

```dart
Future<void> updateNote(String docID, String newNote) {
  return notes.doc(docID).update({
    'note': newNote,
    'timestamp': Timestamp.now(),
  });
}
```

- Updates the text and updates the timestamp (so the note moves to the top).

---

#### 🗑 Delete a Note

```dart
Future<void> deleteNote(String docID) {
  return notes.doc(docID).delete();
}
```

- Deletes the note with the given document ID.
