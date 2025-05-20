# 11. Connecting API - Machine Learning Service: Flutter + FastAPI Integration: Predict Insurance Cost via Mobile App

## 🎯 What You’ll Build

In this module, you’ll build a **Flutter mobile app** that connects to a **FastAPI backend** hosted on Hugging Face Spaces. You’ll send user input (age, BMI, etc.) and get back a prediction of insurance cost.

<p align="center">
  <img src="https://github.com/user-attachments/assets/2a64941a-4da3-4159-8678-3881c3c47b09" height="350"/>
</p>

---

## 🧱 Tools Used

- Flutter (Frontend Mobile App)
    
- FastAPI (Backend API)
    
- Hugging Face Spaces (API Hosting)
    
- HTTP Requests with JSON
    

---

## ✅ Step 1: Create a New Flutter Project

1. Open **Android Studio**
    
2. Choose **"New Flutter Project"** → Select **"Flutter Application"**
    
3. Name your project, e.g., `insurance_predictor_app`
    
4. Click **Finish**
    
---

## 🔌 Step 2: Add the HTTP Package

In order to make HTTP requests (send data to the API and get a response), we need to install the package first. Open your terminal and run 

```yaml
flutter pub add http
```

Then run this command in your terminal:

```bash
flutter pub get
```

This will download the package and make it available to your project.

---
## 📦 Step 3: Create Model Classes

### File: `lib/models/insurance_model.dart`

```dart
// This class is for the request data you send to the API
class InsuranceRequest {
  final int age, sex, smoker, children, region;
  final double bmi;

  InsuranceRequest({
    required this.age,
    required this.sex,
    required this.smoker,
    required this.bmi,
    required this.children,
    required this.region,
  });

  // Converts values to key-value pairs as expected by the API
  Map<String, String> toFormData() {
    return {
      'age': age.toString(),
      'sex': sex.toString(),
      'smoker': smoker.toString(),
      'bmi': bmi.toString(),
      'children': children.toString(),
      'region': region.toString(),
    };
  }
}

// This class is for the response data you receive from the API
class InsuranceResponse {
  final int age, children;
  final String sex, smoker, region;
  final double bmi, insuranceCost;

  InsuranceResponse({
    required this.age,
    required this.sex,
    required this.smoker,
    required this.bmi,
    required this.children,
    required this.region,
    required this.insuranceCost,
  });

  // Converts JSON response to Dart object
  factory InsuranceResponse.fromJson(Map<String, dynamic> json) {
    return InsuranceResponse(
      age: json['age'],
      sex: json['sex'],
      smoker: json['smoker'],
      bmi: json['bmi'],
      children: json['children'],
      region: json['region'],
      insuranceCost: json['insurance_cost'],
    );
  }
}
```

| Class               | Purpose                             |
| ------------------- | ----------------------------------- |
| `InsuranceRequest`  | Represents the **data you send**    |
| `toFormData()`      | Converts it into a format for POST  |
| `InsuranceResponse` | Represents the **data you receive** |
| `fromJson()`        | Converts JSON → Dart object         |

---

When we work with APIs, we usually need to send and receive data. To make it easier and cleaner, we create **model classes**.

In this step, you're defining **two Dart classes**:

### 1. `InsuranceRequest`

This class helps you **prepare the data you want to send** to the API.

```dart
class InsuranceRequest {
  final int age;
  final int sex;
  final int smoker;
  final double bmi;
  final int children;
  final int region;
```

These are the **6 fields** the API needs to predict insurance cost. We use `int` and `double` because that's what the backend expects.

#### Constructor

```dart
InsuranceRequest({
  required this.age,
  required this.sex,
  required this.smoker,
  required this.bmi,
  required this.children,
  required this.region,
});
```

This is how you create a `InsuranceRequest` object like this:

```dart
InsuranceRequest(
  age: 25,
  sex: 1,
  smoker: 0,
  bmi: 23.5,
  children: 2,
  region: 3,
)
```

#### toFormData Method

```dart
Map<String, String> toFormData() {
  return {
    'age': age.toString(),
    'sex': sex.toString(),
    'smoker': smoker.toString(),
    'bmi': bmi.toString(),
    'children': children.toString(),
    'region': region.toString(),
  };
}
```

The FastAPI backend expects **form-encoded strings**, not numbers. This method converts all the fields into strings and puts them in a format that `http.post()` understands.

---

### 2. `InsuranceResponse`

This class handles the **response** sent back by the API after you submit the form.

```dart
class InsuranceResponse {
  final int age;
  final String sex;
  final String smoker;
  final double bmi;
  final int children;
  final String region;
  final double insuranceCost;
```

These fields match the **JSON response** returned by the backend. The insurance cost is returned along with human-readable values (like `"Male"` instead of `1`).

#### Constructor

```dart
InsuranceResponse({
  required this.age,
  required this.sex,
  required this.smoker,
  required this.bmi,
  required this.children,
  required this.region,
  required this.insuranceCost,
});
```

Just like the request class, this lets you create a Dart object that holds all the data from the response.

#### fromJson Factory

```dart
factory InsuranceResponse.fromJson(Map<String, dynamic> json) {
  return InsuranceResponse(
    age: json['age'],
    sex: json['sex'],
    smoker: json['smoker'],
    bmi: json['bmi'],
    children: json['children'],
    region: json['region'],
    insuranceCost: json['insurance_cost'],
  );
}
```

This method takes a **Map (JSON)** and turns it into a Dart object. It's super useful because you’ll be getting JSON data from the API, and this function will convert it to a Dart-friendly format in one line.

---

## 🌐 Step 4: Write the API Call Function

### File: `lib/services/api_service.dart`

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/insurance_model.dart';

class ApiService {
  // Change this to your actual API URL
  static const String _url = "https://hilmizr-pdst-regression-be-vclass.hf.space/predict";

  static Future<InsuranceResponse?> predictInsuranceCost(InsuranceRequest request) async {
    try {
      var response = await http.post(
        Uri.parse(_url),
        body: request.toFormData(), // Send the form data
      );

      if (response.statusCode == 200) {
        // Decode the JSON and convert it to Dart object
        final data = json.decode(response.body);
        return InsuranceResponse.fromJson(data);
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }
}
```

|Part|What it Does|
|---|---|
|`http.post()`|Sends data to the API|
|`request.toFormData()`|Converts Dart object to form format|
|`response.statusCode == 200`|Checks if the response is OK|
|`json.decode(response.body)`|Converts response string to Map|
|`fromJson()`|Converts Map to Dart object (`InsuranceResponse`)|

### ✅ What’s the Purpose?

We want to:

- Send the user’s form input (age, BMI, etc.) to the API
    
- Receive a prediction back (insurance cost)
    
- Convert the response into a Dart object we can use in the UI
    

---

### 🔍 Packages

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/insurance_model.dart';
```

- `http`: lets us send web requests (like `POST` and `GET`)
    
- `convert`: helps us turn JSON (from the API) into Dart objects
    
- `insurance_model.dart`: we import the request and response models
    

---

### 🧠 The API Service Class

```dart
class ApiService {
  static const String _url = "https://hilmizr-pdst-regression-be-vclass.hf.space/predict";
```

- This class holds functions related to the API.
    
- `_url` is the endpoint where we’ll send the data. Replace this with your own URL if needed.
    

---

### 📤 The Function: `predictInsuranceCost`

```dart
static Future<InsuranceResponse?> predictInsuranceCost(InsuranceRequest request) async {
```

- This function is `async` because it waits for a response from the internet.
    
- It returns a `Future`, which means you’ll get the result _later_ (after the API responds).
    
- It takes in a `InsuranceRequest` object (your form input).
    

---

### ✉️ Sending the POST Request

```dart
var response = await http.post(
  Uri.parse(_url),
  body: request.toFormData(),
);
```

- This sends a **POST** request to the API URL.
    
- `body:` contains the form data (converted using `toFormData()` method).
    
- `await` pauses the function until we get a response.
    

---

### ✅ Handling the Response

```dart
if (response.statusCode == 200) {
  final data = json.decode(response.body);
  return InsuranceResponse.fromJson(data);
}
```

- If the status code is `200`, that means success!
    
- `json.decode()` converts the raw response into a Dart `Map`.
    
- `InsuranceResponse.fromJson()` turns that `Map` into a Dart object.
    

You can now use the returned `InsuranceResponse` object to display results in your app.

---

### ❌ Handling Errors

```dart
else {
  print("Error: ${response.statusCode}");
  return null;
}
```

- If the API fails, we print the error and return `null`.
    
- Your app can check for `null` and show a message to the user.
    

---

## 🖼️ Step 5: Build the App UI

### File: `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'models/insurance_model.dart';
import 'services/api_service.dart';

void main() {
  runApp(MaterialApp(home: InsuranceFormScreen()));
}

class InsuranceFormScreen extends StatefulWidget {
  @override
  _InsuranceFormScreenState createState() => _InsuranceFormScreenState();
}

class _InsuranceFormScreenState extends State<InsuranceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ageController = TextEditingController();
  final bmiController = TextEditingController();
  final childrenController = TextEditingController();

  int sex = 1, smoker = 0, region = 0;
  InsuranceResponse? result;

  // When the form is submitted
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var request = InsuranceRequest(
        age: int.parse(ageController.text),
        sex: sex,
        smoker: smoker,
        bmi: double.parse(bmiController.text),
        children: int.parse(childrenController.text),
        region: region,
      );

      var response = await ApiService.predictInsuranceCost(request);
      setState(() {
        result = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Insurance Cost Predictor")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // AGE
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter age" : null,
              ),

              // SEX DROPDOWN
              DropdownButtonFormField(
                value: sex,
                decoration: InputDecoration(labelText: "Sex"),
                items: [
                  DropdownMenuItem(value: 1, child: Text("Male")),
                  DropdownMenuItem(value: 0, child: Text("Female")),
                ],
                onChanged: (val) => setState(() => sex = val!),
              ),

              // SMOKER DROPDOWN
              DropdownButtonFormField(
                value: smoker,
                decoration: InputDecoration(labelText: "Smoker"),
                items: [
                  DropdownMenuItem(value: 1, child: Text("Yes")),
                  DropdownMenuItem(value: 0, child: Text("No")),
                ],
                onChanged: (val) => setState(() => smoker = val!),
              ),

              // BMI
              TextFormField(
                controller: bmiController,
                decoration: InputDecoration(labelText: "BMI"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter BMI" : null,
              ),

              // CHILDREN
              TextFormField(
                controller: childrenController,
                decoration: InputDecoration(labelText: "Children"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter number of children" : null,
              ),

              // REGION
              DropdownButtonFormField(
                value: region,
                decoration: InputDecoration(labelText: "Region"),
                items: [
                  DropdownMenuItem(value: 0, child: Text("Northeast")),
                  DropdownMenuItem(value: 1, child: Text("Northwest")),
                  DropdownMenuItem(value: 2, child: Text("Southeast")),
                  DropdownMenuItem(value: 3, child: Text("Southwest")),
                ],
                onChanged: (val) => setState(() => region = val!),
              ),

              SizedBox(height: 20),

              // BUTTON
              ElevatedButton(onPressed: _submitForm, child: Text("Predict")),

              // RESULT
              if (result != null) ...[
                SizedBox(height: 20),
                Text("Result: \$${result!.insuranceCost.toStringAsFixed(2)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Age: ${result!.age}"),
                Text("Sex: ${result!.sex}"),
                Text("Smoker: ${result!.smoker}"),
                Text("BMI: ${result!.bmi}"),
                Text("Children: ${result!.children}"),
                Text("Region: ${result!.region}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
``` 

| Section                   | What It Does                                |
| ------------------------- | ------------------------------------------- |
| `TextEditingController`   | Grabs text from user input                  |
| `DropdownButtonFormField` | Lets user choose from options               |
| `_submitForm()`           | Converts input → request → sends to API     |
| `result != null`          | If response exists, show the predicted cost |

---

### 🧱 `InsuranceFormScreen`: The Main Form Page

We use a **StatefulWidget** here because the form fields and result will change (dynamic data).

```dart
class InsuranceFormScreen extends StatefulWidget {
  @override
  _InsuranceFormScreenState createState() => _InsuranceFormScreenState();
}
```

---

### 🧠 Inside `_InsuranceFormScreenState`

#### 🛠 Controllers and State Variables

```dart
final _formKey = GlobalKey<FormState>();
final ageController = TextEditingController();
final bmiController = TextEditingController();
final childrenController = TextEditingController();
int sex = 1;
int smoker = 0;
int region = 0;
InsuranceResponse? result;
```

- `TextEditingController` is used to get the user’s input from text fields.
    
- `sex`, `smoker`, `region` are dropdown values (selected using `DropdownButtonFormField`).
    
- `result` will hold the prediction from the backend once we get it.
    

---

### 📤 `void _submitForm()` – Sending Data to the API

```dart
void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    var request = InsuranceRequest(
      age: int.parse(ageController.text),
      sex: sex,
      smoker: smoker,
      bmi: double.parse(bmiController.text),
      children: int.parse(childrenController.text),
      region: region,
    );

    var response = await ApiService.predictInsuranceCost(request);
    setState(() {
      result = response;
    });
  }
}
```

- This function is called when the user taps the "Predict" button.
    
- It creates a `InsuranceRequest` object from the input.
    
- Then it calls the API and saves the result in `result`.
    
- `setState()` tells Flutter to update the screen with the new data.
    

---
### ✍️ The Input Fields

Each input is either a `TextFormField` or `DropdownButtonFormField`:

#### Example:

```dart
TextFormField(
  controller: ageController,
  decoration: InputDecoration(labelText: "Age"),
  keyboardType: TextInputType.number,
  validator: (value) => value!.isEmpty ? "Enter age" : null,
),
```

- `controller` captures the value
    
- `validator` checks that it's not empty
    

For dropdowns like sex:

```dart
DropdownButtonFormField(
  value: sex,
  decoration: InputDecoration(labelText: "Sex"),
  items: [
    DropdownMenuItem(value: 1, child: Text("Male")),
    DropdownMenuItem(value: 0, child: Text("Female")),
  ],
  onChanged: (val) => setState(() => sex = val!),
),
```

- `items`: what shows up in the dropdown
    
- `onChanged`: updates the value when selected
    

---

### 📲 Submit Button

```dart
ElevatedButton(
  onPressed: _submitForm,
  child: Text("Predict Insurance Cost"),
),
```

When tapped, it runs `_submitForm()` which talks to the backend.

---

### 📊 Displaying the Result

```dart
if (result != null)
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Estimated Cost: \$${result!.insuranceCost.toStringAsFixed(2)} USD", ...),
      Text("Age: ${result!.age}"),
      ...
    ],
  )
```

- If the prediction is ready, we show it.
    
- The data is taken from `result`, which is a `InsuranceResponse` object.

---

## 🛠️ Tips & Troubleshooting

- If the API doesn't respond, open it once in a browser to wake it up.
- Make sure your BMI uses a dot (`23.4` not `23,4`)
- Watch for typos in field names—backend expects specific keys.

---

## 🎥 Additional References: AI API Integration in Flutter

Here are some video tutorials that show how to integrate AI or API services into Flutter apps. 

| Video                                                                                                   | Description                                                                                                                                                          |
| ------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [![Video 1](https://img.youtube.com/vi/cXxB_mzOShI/0.jpg)](https://www.youtube.com/watch?v=cXxB_mzOShI) | **Add Any AI to Flutter in 5 Minutes (ChatGPT, Claude, Gemini)**<br>In this video, you learn how to quickly integrate any AI model—including ChatGPT, Claude, or Gemini—into your Flutter app using the OpenRouter API, with step-by-step guidance on setup, API key management, and switching between different AI models for testing and deployment. |
| [![Video 2](https://img.youtube.com/vi/26BTR8yR3-M/0.jpg)](https://www.youtube.com/watch?v=26BTR8yR3-M) | **(Claude API) 📱 Image-to-Text App • Flutter Tutorial**<br>This video is a step-by-step Flutter tutorial demonstrating how to build an AI-powered image-to-text app using Anthropic’s Claude API, guiding viewers through setting up image picking, API integration, permissions, and UI so users can take or select a photo and receive an AI-generated description of the image.    |
| [![Video 3](https://img.youtube.com/vi/nv76JCWIZc0/0.jpg)](https://www.youtube.com/watch?v=nv76JCWIZc0) | **📱 AI Chat Bot • Claude x Flutter Tutorial**<br>This video provides a step-by-step tutorial on building an AI chat app in Flutter using Anthropic's Claude API, demonstrating how to integrate the API and use the Provider package for state management.   |

---
