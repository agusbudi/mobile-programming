# 07. Awesome Notifications

[Previous](/06.%20Firebase/) | [Main Page](/) | [Next](/08.%20Firebase%20Auth/)

## Mobile Notifications

To use notifications in our app, we can use the `awesome_notifications` package. This package provides a simple and easy way to create and manage notifications in our app.

### Step 1: Add Dependency

Add the `awesome_notifications` using the following command:

```bash
flutter pub add awesome_notifications:^0.7.4+1
```

After adding the dependency, we need to modify the `android/app/build.gradle` file to include the following lines:

```groovy
android {
  ...
  compileSdkVersion 34 // change the compileSdkVersion to 34
  ...

  defaultConfig {
    ...
    minSdkVersion 23 // change the minSdkVersion to 23
    targetSdkVersion 33 // change the targetSdkVersion to 33
  }
}
```

### Step 2: Configure Permissions

To use notifications in our app, we need to configure the permissions in the `AndroidManifest.xml` file. Open the `android/app/src/main/AndroidManifest.xml` file and add the following lines:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Add these two lines -->
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY"/>

    <application
        android:label="notification_demo"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
...
```

### Step 3: Create Notification Service

Create a new file called `notification_service.dart` in the `lib/services` folder.

We will create a `NotificationService` class that will handle the initialization and display of notifications.

Below is the code for initializing the notification service.

```dart
static Future<void> initializeNotification() async {
  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: true,
        criticalAlerts: true,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic notifications group',
      )
    ],
    debug: true,
  );

  // Request notification permissions
  await AwesomeNotifications().isNotificationAllowed().then(
    (isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    },
  );

  // Set notification listeners
  await AwesomeNotifications().setListeners(
    onActionReceivedMethod: _onActionReceivedMethod,
    onNotificationCreatedMethod: _onNotificationCreateMethod,
    onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
    onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
  );
}

// Listeners

static Future<void> _onNotificationCreateMethod(
  ReceivedNotification receivedNotification,
) async {
  debugPrint('Notification created: ${receivedNotification.title}');
}

static Future<void> _onNotificationDisplayedMethod(
  ReceivedNotification receivedNotification,
) async {
  debugPrint('Notification displayed: ${receivedNotification.title}');
}

static Future<void> _onDismissActionReceivedMethod(
  ReceivedNotification receivedNotification,
) async {
  debugPrint('Notification dismissed: ${receivedNotification.title}');
}

static Future<void> _onActionReceivedMethod(
  ReceivedNotification receivedNotification,
) async {
  debugPrint('Notification action received: ${receivedNotification.title}');
}
```

To create a notification, we will create a method called `createNotification` in the `NotificationService` class.

```dart
static Future<void> createNotification({
  required final int id,
  required final String title,
  required final String body,
  final String? summary,
  final Map<String, String>? payload,
  final ActionType actionType = ActionType.Default,
  final NotificationLayout notificationLayout = NotificationLayout.Default,
  final NotificationCategory? category,
  final String? bigPicture,
  final List<NotificationActionButton>? actionButtons,
  final bool scheduled = false,
  final Duration? interval,
}) async {
  assert(!scheduled || (scheduled && interval != null));

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: title,
      body: body,
      actionType: actionType,
      notificationLayout: notificationLayout,
      summary: summary,
      category: category,
      payload: payload,
      bigPicture: bigPicture,
    ),
    actionButtons: actionButtons,
    schedule: scheduled
        ? NotificationInterval(
            interval: interval,
            timeZone:
                await AwesomeNotifications().getLocalTimeZoneIdentifier(),
            preciseAlarm: true,
          )
        : null,
  );
}
```

### Step 4: Create Home Screen

Create a new file called `home_screen.dart` in the `lib/screens` folder.
We will create a simple UI which consists of buttons to create notifications.

```dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notification_demo/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Placeholder for the notification buttons
        ],
      ),
    );
  }
}
```

These are the buttons we will create to test the notifications.

#### Default Notification

To create a default notification, we will create a button that will call the `createNotification` method in the `NotificationService` class.

```dart
OutlinedButton(
  onPressed: () async {
    await NotificationService.createNotification(
      id: 1,
      title: 'Default Notification',
      body: 'This is the body of the notification',
      summary: 'Small summary',
    );
  },
  child: const Text('Default Notification'),
)
```

#### Notification with Summary

To create a notification with a summary, we will create a button that will call the `createNotification` method in the `NotificationService` class and change the `notificationLayout` to `NotificationLayout.Inbox`.

```dart
OutlinedButton(
  onPressed: () async {
    await NotificationService.createNotification(
      id: 2,
      title: 'Notification with Summary',
      body: 'This is the body of the notification',
      summary: 'Small summary',
      notificationLayout: NotificationLayout.Inbox,
    );
  },
  child: const Text('Notification with Summary'),
)
```

#### Progress Bar Notification

To create a progress bar notification, we will create a button that will call the `createNotification` method in the `NotificationService` class and change the `notificationLayout` to `NotificationLayout.ProgressBar`.

```dart
OutlinedButton(
  onPressed: () async {
    await NotificationService.createNotification(
      id: 3,
      title: 'Progress Bar Notification',
      body: 'This is the body of the notification',
      summary: 'Small summary',
      notificationLayout: NotificationLayout.ProgressBar,
    );
  },
  child: const Text('Progress Bar Notification'),
)
```

#### Message Notification

To create a message notification, we will create a button that will call the `createNotification` method in the `NotificationService` class and change the `notificationLayout` to `NotificationLayout.Messaging`.

```dart
OutlinedButton(
  onPressed: () async {
    await NotificationService.createNotification(
      id: 4,
      title: 'Message Notification',
      body: 'This is the body of the notification',
      summary: 'Small summary',
      notificationLayout: NotificationLayout.Messaging,
    );
  },
  child: const Text('Message Notification'),
)
```

#### Big Image Notification

To create a big image notification, we will create a button that will call the `createNotification` method in the `NotificationService` class and change the `notificationLayout` to `NotificationLayout.BigPicture`.

```dart
OutlinedButton(
  onPressed: () async {
    await NotificationService.createNotification(
      id: 5,
      title: 'Big Image Notification',
      body: 'This is the body of the notification',
      summary: 'Small summary',
      notificationLayout: NotificationLayout.BigPicture,
      bigPicture: 'https://picsum.photos/300/200',
    );
  },
  child: const Text('Big Image Notification'),
)
```

#### Action Button Notification

To create a notification with action buttons, we will create a button that will call the `createNotification` method in the `NotificationService` class and add action buttons to the notification.

```dart
OutlinedButton(
  onPressed: () async {
    await NotificationService.createNotification(
      id: 5,
      title: 'Action Button Notification',
      body: 'This is the body of the notification',
      payload: {'navigate': 'true'},
      actionButtons: [
        NotificationActionButton(
          key: 'action_button',
          label: 'Click me',
          actionType: ActionType.Default,
        )
      ],
    );
  },
  child: const Text('Action Button Notification'),
)
```

We need to handle the action button in the `_onActionReceivedMethod` method in the `NotificationService` class. Change the method to the following:

```dart
static Future<void> _onActionReceivedMethod(
  ReceivedNotification receivedNotification,
) async {
  debugPrint('Notification action received');
  final payload = receivedNotification.payload;
  if (payload == null) return;
  if (payload['navigate'] == 'true') {
    debugPrint(MyApp.navigatorKey.currentContext.toString());
    Navigator.push(
      MyApp.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => const SecondScreen(),
      ),
    );
  }
}
```

We also need to add the `second_screen.dart` file to handle the navigation. Create a new file called `second_screen.dart` in the `lib/screens` folder.

```dart
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text('This is the second screen from the notification!'),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Scheduled Notification

To create a scheduled notification, we will create a button that will call the `createNotification` method in the `NotificationService` class and set the `scheduled` parameter to `true` and the `interval` parameter to the desired interval.

```dart
OutlinedButton(
  onPressed: () async {
    await NotificationService.createNotification(
      id: 5,
      title: 'Scheduled Notification',
      body: 'This is the body of the notification',
      scheduled: true,
      interval: 5,
    );
  },
  child: const Text('Scheduled Notification'),
)
```

### Step 5: Main Function

Finally, we need to modify the `main.dart` file to initialize the notification service and run the app.

```dart
import 'package:flutter/material.dart';
import 'package:notification_app/screens/home_screen.dart';
import 'package:notification_app/screens/second_screen.dart';
import 'package:notification_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      routes: {
        'home': (context) => const HomeScreen(),
        'second': (context) => const SecondScreen(),
      },
      initialRoute: 'home',
      navigatorKey: navigatorKey,
    );
  }
}
```

Here are the result of the notifications we created:

<div align="center">
   <img src="https://github.com/user-attachments/assets/84541519-2322-4307-abb0-10cfb40b6cd3" width="300"/>
   <img src="https://github.com/user-attachments/assets/f448ba90-9dcd-495c-9cc1-5fd48ee61629" width="300"/>
   <img src="https://github.com/user-attachments/assets/d8d6b992-83d9-492a-9f8a-56b7f6a14200" width="300"/>
   <img src="https://github.com/user-attachments/assets/d2ab6a63-0c5d-4730-afd6-899180d38b41" width="300"/>
   <img src="https://github.com/user-attachments/assets/77240039-bd06-4615-9cfe-b4c8644f61cc" width="300"/>
   <img src="https://github.com/user-attachments/assets/6e34f1c5-0852-446b-a455-002482f01218" width="300"/>
   <img src="https://github.com/user-attachments/assets/8196f52c-3613-4851-9f18-b49530617019" width="300"/>
   <img src="https://github.com/user-attachments/assets/8a3604d9-ab72-4549-9249-6882dc77d3a6" width="300"/>
</div>
