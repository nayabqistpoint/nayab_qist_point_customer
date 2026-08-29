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

  // 🎯 اینڈرائیڈ پرمیشنز کو خودکار اور محفوظ طریقے سے چیک کرنا
  Future<bool> requestPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  // 🎯 کریش فری ریکارڈنگ اسٹارٹ
  Future<bool> startRecording() async {
    try {
      bool hasPermission = await requestPermissions();
      if (!hasPermission) {
        debugPrint("Microphone permission denied.");
        return false;
      }

      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

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
      debugPrint("Safe Audio Recording Error: $e");
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
        await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
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