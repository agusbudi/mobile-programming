# 04. Stateful and Starting the World Time App

[Previous](/03.%20Widgets%20-%20Images,%20Buttons,%20Icons,%20Containers%20&%20Padding,%20Rows,%20Columns/) | [Main Page](/) | [Next](/05.%20Firebase/)

## Content Outline

- [State](#state)  
  - [Key Concepts of State in Flutter](#key-concepts-of-state-in-flutter)  
    - [Stateless vs. Stateful Widgets](#stateless-vs-stateful-widgets)  
    - [How State Works](#how-state-works)  
    - [Types of State](#types-of-state)  
    - [Example: Counter App with StatefulWidget](#example-counter-app-with-statefulwidget)  
    - [Why Is State Important?](#why-is-state-important)  
- [Stateless Widgets](#stateless-widgets)  
  - [Example of a Stateless Widget](#example-of-a-stateless-widget)  
- [Stateful Widgets](#stateful-widgets)  
  - [Example of a Stateful Widget](#example-of-a-stateful-widget)  
- [Comparison: Stateless vs. Stateful Widgets](#comparison-stateless-vs-stateful-widgets)  
- [Example of Stateless vs. Stateful](#example-of-stateless-vs-stateful)  
  - [Stateless Widget Example](#stateless-widget-example)  
  - [Stateful Widget Example](#stateful-widget-example)  
- [Comparison: Stateless App vs. Stateful App](#comparison-stateless-app-vs-stateful-app)  

This updated outline aligns with the structure of the provided Markdown. Let me know if you need any refinements! 🚀

## State

In Flutter, *state* refers to the data or information that a widget uses to determine its appearance and behavior. Simply put, state is what makes an app dynamic and interactive by allowing the user interface (UI) to change in response to user actions or other events.

### Key Concepts of State in Flutter

1. **Stateless vs. Stateful Widgets**
   - **Stateless Widgets**: These widgets do not have any state. They are immutable, meaning their appearance and behavior cannot change after being built. Use them for static UI elements like text or icons.
     - Example: A `Text` widget displaying "Hello, World!" is stateless because it doesn’t change.
   - **Stateful Widgets**: These widgets can change their appearance and behavior during their lifecycle. They are used when the UI needs to update dynamically based on user interaction or other events.
     - Example: A counter app where a button increments a number is stateful.

2. **How State Works**
   - In Flutter, apps are reactive. This means when the state changes, Flutter automatically rebuilds the affected parts of the UI to reflect those changes.
   - For example, if a button changes color when clicked, the state is updated, and Flutter redraws the button with the new color.

3. **Types of State**
   - **Ephemeral State**: This is local to a single widget and doesn’t need to be shared across multiple widgets. It can be managed using `StatefulWidget` and `setState()`.
     - Example: The currently selected tab in a bottom navigation bar.
   - **App State**: This is shared across multiple parts of an app and persists beyond a single widget’s lifecycle. It often requires more advanced state management techniques like `Provider`, `BLoC`, or `Riverpod`.
     - Example: User login status or shopping cart data in an e-commerce app.

---

### Example: Counter App with StatefulWidget

<div align="center">
    <img src="https://github.com/user-attachments/assets/662506e0-0ae1-4a7c-90d6-98ae919e77b0" width="300">
</div>

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterApp(),
    );
  }
}

class CounterApp extends StatefulWidget {
  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State {
  int _counter = 0; // This is the state (data) that changes.

  void _incrementCounter() {
    setState(() {
      _counter++; // Update the state.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pressed the button this many times:'),
            Text('$_counter', style: TextStyle(fontSize: 32)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

**Explanation**:
- `_counter`: This variable holds the current count, which is part of the widget's state.
- `setState()`: This method tells Flutter that the state has changed, prompting it to rebuild the UI with the updated value.

---

### Why Is State Important?
Without state, apps would be static and unable to respond to user interactions. For example:
- A login form needs to update its UI based on whether the user input is valid.
- A music player needs to show whether a song is playing or paused.

---

## **Stateless Widgets**
Stateless widgets are widgets that do not change during their lifetime. They are immutable, meaning once created, their properties cannot be updated. These widgets are ideal for displaying *static content* that does not depend on user interactions or dynamic data.

### Example of a Stateless Widget:

<div align="center">
    <img src="https://github.com/user-attachments/assets/182e0fec-6cd4-4bf3-908c-0c1cb4c3ac88" width="300">
</div>

```dart
import 'package:flutter/material.dart';

class MyStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stateless Widget Example')),
      body: Center(
        child: Text('Hello, World!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyStatelessWidget(),
  ));
}
```
**Explanation**:
- The text "Hello, World!" is static and will not change regardless of user actions.

---

## **Stateful Widgets**
Stateful widgets are widgets that can change their state during their lifecycle. They are mutable and allow the UI to update dynamically in response to user interactions, animations, or external events.

### Example of a Stateful Widget:

<div align="center">
    <img src="https://github.com/user-attachments/assets/c2bb0269-97e6-430e-8bde-e1e029cafab8" width="300">
</div>

```dart
import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++; // Updates the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stateful Widget Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter:', style: TextStyle(fontSize: 24)),
            Text('$_counter', style: TextStyle(fontSize: 48)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: MyStatefulWidget()));
```
**Explanation**:
- The `_counter` variable is part of the widget's state.
- Clicking the button updates `_counter`, and the UI reflects this change.

---

## **Comparison: Stateless vs. Stateful Widgets**

| Feature                  | Stateless Widgets                          | Stateful Widgets                          |
|--------------------------|--------------------------------------------|-------------------------------------------|
| **Mutability**           | Immutable (cannot change after creation). | Mutable (can change during lifecycle).    |
| **Use Case**             | Static UI elements (e.g., text, icons).   | Dynamic UI elements (e.g., forms, counters). |
| **Performance**          | Lightweight and efficient.                | Slightly heavier due to state management. |
| **Examples**             | Displaying fixed text or images.          | Buttons that update counters or animations. |
| **Lifecycle Management** | No state management required.             | Requires `setState()` to manage changes.  |

---

## Example of Stateless vs Stateful Widgets
Here are two examples of a simple app: one using a **Stateless Widget** and the same app as a **Stateful Widget**. Both apps display a button and some text. The difference is how they handle *state* (whether the text changes when the button is pressed).

---

### **Stateless Widget Example**

<div align="center">
    <img src="https://github.com/user-attachments/assets/4a2d4b81-a13e-48c6-9b9a-de473acfe861" width="300">
</div>

This app displays a button and some text. The text does *not* change when the button is pressed because it’s static.

```dart
import 'package:flutter/material.dart';

class StatelessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Stateless App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('This is a Stateless Widget', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20), // Adds some space between widgets
              ElevatedButton(
                onPressed: () {
                  // Button does nothing because state cannot change
                  print('Button Pressed!');
                },
                child: Text('Press Me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(StatelessApp());
```

**Explanation**:
- The text "This is a Stateless Widget" is fixed and does not change, even if the button is pressed.
- The `onPressed` function of the button only prints a message to the console but does not affect the UI.

---

### **Stateful Widget Example**

<div align="center">
    <img src="https://github.com/user-attachments/assets/cc8554c7-2978-454c-93ad-e82bf1e81a9f" width="300">
</div>

This app displays a button and some text. When the button is pressed, the text changes dynamically because it uses *state*.

```dart
import 'package:flutter/material.dart';

class StatefulApp extends StatefulWidget {
  @override
  _StatefulAppState createState() => _StatefulAppState();
}

class _StatefulAppState extends State {
  String _message = 'This is a Stateful Widget'; // Initial state

  void _changeMessage() {
    setState(() {
      _message = 'The Button was Pressed!'; // Update the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Stateful App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_message, style: TextStyle(fontSize: 20)), 
              SizedBox(height: 20), 
              ElevatedButton(
                onPressed: _changeMessage, 
                child: Text('Press Me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(StatefulApp());
```

**Explanation**:
- The `_message` variable holds the current state of the text.
- When the button is pressed, `_changeMessage()` updates `_message` using `setState()`, and Flutter rebuilds the UI to show the new message.

---

### **Comparison: Stateless App vs. Stateful App**

| Feature                 | Stateless App                              | Stateful App                              |
|-------------------------|--------------------------------------------|-------------------------------------------|
| **Behavior**            | The text remains static, even if you press the button. | The text changes dynamically when you press the button. |
| **Code Simplicity**     | Simpler because there’s no state to manage. | Slightly more complex because it manages state with `setState()`. |
| **Interactivity**       | No interactivity beyond pressing the button. | Interactive because pressing the button updates the UI. |

---
