# Scaffold & AppBar Widgets

[Back](README.md)

With the Flutter application ready, we can start to make our application by using widgets. Prepare the program as follows to continue.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Text("Hey MOBILE"),
  ));
}
```

## Scaffold

Scaffold class widget is a basic Material Design visual layout structure. It allows to setup the AppBar, FloatingActionButton, and more. We can start by using `Scaffold()` on our `MaterialApp()`

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(),
  ));
}
```

We can move on to setup the appbar and the body

## AppBar

We use `appBar` property from Scaffold to setup our AppBar. The value of this `appBar` is an `AppBar` Widget. `AppBar` Widget has some properties like the following diagram.

![Appbar](images/appbar.png)
