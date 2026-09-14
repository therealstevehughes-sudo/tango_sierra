import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lastCameraNamePrefsKey = 'evidence_camera_last_selected_name';

/// Live camera preview + capture, Windows + Android (built 2026-09-14).
///
/// image_picker's own camera option only exists on Android/iOS —
/// image_picker_windows explicitly throws UnsupportedError for
/// ImageSource.camera. This screen uses the `camera` package instead,
/// which has a real Windows implementation (camera_windows), so both
/// platforms get the same live-preview-and-capture experience rather than
/// Windows silently having no camera option at all.
///
/// Defaults to the back-facing camera on a device with more than one
/// (a Windows tablet or Android phone/tablet used for evidence photos
/// should point at the kitchen, not the person holding it). On Android,
/// `camera`'s own `lensDirection` is accurate and used directly. On
/// Windows, `camera_windows` hardcodes `lensDirection` to `front` for
/// EVERY camera (an unimplemented TODO in that plugin — Windows has no
/// standard front/back API) — falls back to matching "back"/"rear" in
/// the camera's device name, and if that's also inconclusive, remembers
/// whichever camera the user last picked via the switch-camera button
/// (SharedPreferences) so a one-time manual fix sticks. A switch-camera
/// button cycles through every camera the device reports either way.
///
/// Returns the captured file's path via `Navigator.pop`, or null if the
/// user backs out without capturing. Never throws on "no camera found" —
/// shows a clear message and a way back out to the Upload alternative
/// instead.
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  List<CameraDescription> _cameras = const [];
  int _selectedIndex = 0;
  CameraController? _controller;
  Future<void>? _initializeFuture;
  String? _error;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _init();
  }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = 'No camera was found on this device.');
        return;
      }
      _cameras = cameras;
      await _selectCamera(await _pickDefaultCameraIndex(cameras));
    } catch (e) {
      setState(() => _error = 'Could not start the camera: $e');
    }
  }

  Future<int> _pickDefaultCameraIndex(List<CameraDescription> cameras) async {
    // 1. Real lensDirection (accurate on Android, but camera_windows
    //    hardcodes every camera to `front` — see the class doc comment).
    final byLensDirection = cameras.indexWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    if (byLensDirection != -1) return byLensDirection;

    // 2. Name heuristic — a rear/external camera is often literally named
    //    that, even when lensDirection metadata can't be trusted.
    final byName = cameras.indexWhere(
      (c) =>
          c.name.toLowerCase().contains('back') ||
          c.name.toLowerCase().contains('rear'),
    );
    if (byName != -1) return byName;

    // 3. Whatever the user last picked via the switch-camera button.
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastName = prefs.getString(_lastCameraNamePrefsKey);
      if (lastName != null) {
        final byLastUsed = cameras.indexWhere((c) => c.name == lastName);
        if (byLastUsed != -1) return byLastUsed;
      }
    } catch (_) {
      // Falls through to the plain default below — persistence is a
      // nice-to-have, never a reason to fail startup.
    }

    return 0;
  }

  Future<void> _selectCamera(int index) async {
    final previous = _controller;
    _controller = null;
    if (mounted) setState(() {});
    await previous?.dispose();

    final controller = CameraController(
      _cameras[index],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() {
      _selectedIndex = index;
      _controller = controller;
    });
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    final next = (_selectedIndex + 1) % _cameras.length;
    try {
      await _selectCamera(next);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastCameraNamePrefsKey, _cameras[next].name);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Could not switch camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _capturing) return;
    setState(() => _capturing = true);
    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      Navigator.pop(context, file.path);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _capturing = false;
        _error = 'Could not capture a photo: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Take Photo'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (_cameras.length > 1)
            IconButton(
              icon: const Icon(Icons.cameraswitch_outlined),
              tooltip: 'Switch camera',
              onPressed: _switchCamera,
            ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (_error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.videocam_off,
                      color: Colors.white70,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            );
          }
          final controller = _controller;
          if (snapshot.connectionState != ConnectionState.done ||
              controller == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              Center(child: CameraPreview(controller)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 32,
                child: Center(
                  child: _capturing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : GestureDetector(
                          onTap: _capture,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
