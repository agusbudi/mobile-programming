# Creating a Flutter App

[Back](README.md)

## Content Outline

- [Creating a Flutter App](#creating-a-flutter-app)
  - [Android Studio](#android-studio)
    - [1. Creating a Virtual Device](#1-creating-a-virtual-device)
    - [2. Installing the Flutter Plugin](#2-installing-the-flutter-plugin)
    - [3. Starting a Flutter Application](#3-starting-a-flutter-application)
    - [4. Run the Project](#4-run-the-project)
  - [Visual Studio Code](#visual-studio-code)
    - [1. Starting a Flutter Application](#1-starting-a-flutter-application)
  - [First program](#first-program)
  - [Note](#note)

After installing Flutter in [01. Introduction & Setup](s/01.%20Introduction%20&%20Setup/), we can start creating our first Flutter application. There are two IDEs (Integrated Development Environments) that can be used to build a Flutter app: Android Studio and Visual Studio Code.

## Android Studio

Android Studio is a popular IDE for mobile app development. After installing [Android Studio](https://developer.android.com/studio?gad_source=1&gclid=Cj0KCQiA2oW-BhC2ARIsADSIAWoAPGSFYZetK8lZ7chW-gRH1ND2PYcij3Ty7qLUqhh3ljrh3Oc-4DoaAo2qEALw_wcB&gclsrc=aw.ds), its interface will look like this:

![img](images/new-window.png)

### 1. Creating a Virtual Device

One option to preview the application interface is by using a Virtual Device (Emulator). The first step is to find the **Virtual Device Manager** menu as shown below:

![VDM](images/VDM.png)

Then, we will add a new Virtual Device by selecting the **Create Virtual Device** option.

![Create Virtual Device](images/create_VD.png)

Next, choose the appropriate phone hardware based on your needs.

![Choose](images/choose_VD.png)

Then, select the Android OS version.

![Android version](images/android_VD.png)

Finally, name your Android Virtual Device and press **Finish**.

![AVD name](images/AVD_name.png)

Once the Virtual Device setup is complete, it will be ready for use as an emulator.

### 2. Installing the Flutter Plugin

The next step is to install the Flutter Plugin in Android Studio to enable Flutter development. Navigate to the **Plugins** page → Marketplace → Search for `Flutter`.

![Flutter Plugin](images/plugininstall.png)

Install the plugin so that the `New Flutter Project` option appears.

![New Flutter Project](images/new_flutter_project_created.png)

### 3. Starting a Flutter Application

You can create your first Flutter application by selecting **New Flutter Project**.

![New Flutter Project](images/new_flutter_project_created.png)

Then, locate the previously installed Flutter SDK.

![Flutter SDK](images/locate_SDK.png)

Next, configure the `Project Name`, `Project Location`, `Description`, and `Organization Name`.

![Flutter New App](images/create_app.png)

Once everything is set up, the editor interface will appear as follows:

![Start page](images/start_page.png)

#### 4. Run the Project

We need to start up the emulator by pressing play button on `Device Manager`

![StartVD](images/start-vd.png)

We can try to run project by pressing the play green button on the top right or next to `main()` function.

![StartApp](images/vd-play.png)

The application will be shown as follows

![app](images/app.png)

## Visual Studio Code

### 1. Starting a Flutter Application

In Visual Studio Code, make sure you have installed the `Flutter` extension.

![Vscode](images/start-vscode.png)

To create a new Flutter project, press `Ctrl + Shift + P` and search for `Flutter: New Project`.

![New Project](images/new_project_vscode.png)

Then, select `Application` and choose the project storage location.

![Application](images/project-app-vscode.png)

Finally, enter the name of the project you want to create.

![Name vscode](images/name-vscode.png)

The project structure will be created and displayed as follows:

![Start page](images/start_page_vscode.png)

You can see a code snippet that is ready to be tested. However, before running the application, you need an Android phone or an emulator.

One way to set up an emulator is by creating a [Virtual Device](#1-creating-a-virtual-device) in Android Studio. Then, in Visual Studio Code, press `Ctrl + Shift + P` and search for `Flutter: Launch Emulator`.

![launch emulator](images/launch-emulator.png)

Next, select the emulator you want to use.

![Emulator](images/emulator_select_vscode.png)

Once launched, the Android Virtual Device emulator will appear.

![Emulator](images/emulator_vscode.png)

To run the application, you can type `flutter run` in the terminal or press `Run` on the `main()` function. This will install the application on the Android device and display it on the screen.

![Alt text](images/app-vscode.png)

## First Program

Create a simple program by using `void main()` function as follows

```dart
import 'package:flutter/material.dart'; // Material Design package

void main() {
  runApp(MaterialApp(
    home: Text("Hey MOBILE"),
  ));
}
```

We use `runApp` to run application with `MaterialApp` for using its Material Design.
To give a text on our `MaterialApp`, we need to use `Text()` widget. Run and see the result!

## Note

If there is an error while running the application, try change the gradle version on `android\gradle\wrapper\gradle-wrapper.properties` based on the Java version used on Flutter by typing `flutter doctor --verbose` on terminal.

```
distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-all.zip
```

Check the gradle version on
https://docs.gradle.org/current/userguide/compatibility.html#java
