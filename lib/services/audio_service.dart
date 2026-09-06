import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioService extends ChangeNotifier {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedFilePath;

  Duration _recordDuration = Duration.zero;
  Duration _playPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  Timer? _timer;

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  String? get recordedFilePath => _recordedFilePath;
  Duration get recordDuration => _recordDuration;
  Duration get playPosition => _playPosition;
  Duration get totalDuration => _totalDuration;

  AudioService() {
    _initPlayerListeners();
  }

  void _initPlayerListeners() {
    _audioPlayer.onPositionChanged.listen((p) {
      _playPosition = p;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((d) {
      _totalDuration = d;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _playPosition = Duration.zero;
      notifyListeners();
    });
  }

  /// 🎯 اینڈرائیڈ اور iOS کے لیے حقیقی اور محفوظ پرمیشن ہینڈلنگ
  Future<bool> requestPermissions() async {
    if (kIsWeb) return true; // ویب کے لیے ریکارڈ پیکیج بذاتِ خود پرمیشن سنبھالتا ہے

    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
    ].request();

    bool micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    if (!micGranted) {
      if (await Permission.microphone.isPermanentlyDenied) {
        await openAppSettings(); // اگر پرمیشن مستقل بند ہو تو سیٹنگز کھولے گا
      }
      return false;
    }

    return true;
  }

  /// 🎯 کریش فری اور سیف ریکارڈنگ کی شروعات
  Future<bool> startRecording() async {
    try {
      bool hasPermission = await requestPermissions();
      if (!hasPermission) {
        debugPrint("Microphone permission was not granted.");
        return false;
      }

      if (await _audioRecorder.hasPermission()) {
        String path = '';
        if (kIsWeb) {
          path = ''; // ویب کے لیے پاتھ خالی رکھا جاتا ہے
        } else {
          final dir = await getApplicationDocumentsDirectory();
          path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        }

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        _isRecording = true;
        _recordedFilePath = null;
        _recordDuration = Duration.zero;
        _startTimer();
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Audio Recording Error: $e");
    }
    return false;
  }

  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _timer?.cancel();
      _isRecording = false;
      _recordedFilePath = path;
      notifyListeners();
      return path;
    } catch (e) {
      debugPrint("Error stopping recording: $e");
      return null;
    }
  }

  Future<void> togglePlay() async {
    if (_recordedFilePath == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        _isPlaying = false;
      } else {
        if (kIsWeb) {
          await _audioPlayer.play(UrlSource(_recordedFilePath!));
        } else {
          await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
        }
        _isPlaying = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error in Audio Playback: $e");
    }
  }

  void reset() {
    try {
      _audioPlayer.stop();
      _audioRecorder.stop();
      _timer?.cancel();
      _isRecording = false;
      _isPlaying = false;
      _recordedFilePath = null;
      _recordDuration = Duration.zero;
      _playPosition = Duration.zero;
      notifyListeners();
    } catch (e) {
      debugPrint("Error resetting AudioService: $e");
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordDuration += const Duration(seconds: 1);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}