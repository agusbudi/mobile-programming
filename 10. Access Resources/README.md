# 10 Access Resources

[Previous](/09.%20Connecting%20API%20-%20Machine%20Learning%20Service/) | [Main Page](/) | 

## Content Outline
- [Camera](#camera)
- [GPS](#gps)

in this module we will try how to access and use some of the resources in flutter

## Camera

We can access camera using the [`camera`](https://pub.dev/packages/camera) plugin. It show a live camera preview and allows users to take a picture.

first you must set your depedencies `pubspec.yaml`:
```
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.10.5+7
```

after that you have to add this syntax to your `app/src/main/AndroidManifest.xml`:

```
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

after that you can make your own kind of app or implement this simple code in `main.dart`:

```
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraPreviewScreen(camera: camera),
    );
  }
}

class CameraPreviewScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewScreen({super.key, required this.camera});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Picture saved to ${image.path}')),
      );
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Access')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: takePicture,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
```

![image-1](https://github.com/user-attachments/assets/c9ff3895-0e6d-491b-ad2a-353b5ec2f3c6)


## GPS
We can access location using [`flutter_map`](https://pub.dev/packages/flutter_map) and [`location`](https://pub.dev/packages/location) plugins

first you must to setup your depedencies `pubspec.yaml`:

```
dependencies:
  flutter:
    sdk: flutter
  flutter_map: ^6.2.1
  latlong2: ^0.9.0
  location: ^5.0.3
```

after that add your setup at `app/src/main/AndroidManifest.xml`:

```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" 
```

after that make your own app or implement simple code like this:

```
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracking Map',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapWithLocation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapWithLocation extends StatefulWidget {
  @override
  _MapWithLocationState createState() => _MapWithLocationState();
}

class _MapWithLocationState extends State<MapWithLocation> {
  final Location _location = Location();
  LocationData? _currentLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final hasPermission = await _checkPermission();
    if (!hasPermission) return;

    final loc = await _location.getLocation();
    setState(() {
      _currentLocation = loc;
    });

    // Listen to location changes
    _location.onLocationChanged.listen((newLoc) {
      setState(() => _currentLocation = newLoc);
      _mapController.move(
          LatLng(newLoc.latitude!, newLoc.longitude!), _mapController.zoom);
    });
  }

  Future<bool> _checkPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track My Location"),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(
              _currentLocation!.latitude!, _currentLocation!.longitude!),
          zoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate:
            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 60,
                height: 60,
                point: LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!),
                child: Icon(Icons.my_location,
                    color: Colors.blue, size: 40),
              )
            ],
          ),
        ],
      ),
    );
  }
}
```

![image](https://github.com/user-attachments/assets/33b9c602-8d5e-4633-b2b9-f1db5c82222e)
