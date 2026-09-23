import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'local_media_helper.dart';
import 'app_permission_service.dart';

class GlobalAudioService {
  static final AudioRecorder _recorder = AudioRecorder();
  static final AudioPlayer _player = AudioPlayer();

  static String audioPath = '';
  static bool isRecording = false;
  static bool isPlaying = false;
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;

  static StreamSubscription<Duration>? _durationSub;
  static StreamSubscription<Duration>? _positionSub;
  static StreamSubscription<PlayerState>? _stateSub;
  static Timer? _recordTimer;
  static int recordSeconds = 0;

  static String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$m:$s';
  }

  static String formatSeconds(int totalSec) {
    final m = (totalSec ~/ 60).toString().padLeft(2, '0');
    final s = (totalSec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// محفوظ ریکارڈنگ شروع یا بند کرنا
  static Future<void> toggleRecord({required VoidCallback onUpdate}) async {
    try {
      if (!isRecording) {
        final hasPerm = await AppPermissionService.requestAudioPermission();
        if (!hasPerm) {
          debugPrint('⚠️ مائیکروفون کی اجازت نہیں ملی');
          return;
        }

        String? targetPath;
        if (!kIsWeb) {
          final tempDir = await getTemporaryDirectory();
          targetPath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        }

        recordSeconds = 0;
        _recordTimer?.cancel();
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          recordSeconds++;
          onUpdate();
        });

        // براؤزر اور موبائل دونوں کے لیے محفوظ ریکارڈ انیشیلائزیشن
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 64000,
            sampleRate: 44100,
          ),
          path: targetPath ?? '',
        );

        isRecording = true;
        audioPath = '';
        duration = Duration.zero;
        position = Duration.zero;
      } else {
        _recordTimer?.cancel();
        final recordedPath = await _recorder.stop();
        isRecording = false;

        if (recordedPath != null && recordedPath.isNotEmpty) {
          if (kIsWeb) {
            audioPath = recordedPath;
          } else {
            audioPath = await LocalMediaHelper.savePermanently(
              recordedPath,
              subFolder: 'audio_records',
            );
          }
          _initPlayerListeners(onUpdate);
        }
      }
    } catch (e) {
      _recordTimer?.cancel();
      isRecording = false;
      debugPrint('❌ ریکارڈنگ ایرر: $e');
    }
    onUpdate();
  }

  static void _initPlayerListeners(VoidCallback onUpdate) {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _stateSub?.cancel();

    _durationSub = _player.onDurationChanged.listen((d) {
      duration = d;
      onUpdate();
    });

    _positionSub = _player.onPositionChanged.listen((p) {
      position = p;
      onUpdate();
    });

    _stateSub = _player.onPlayerStateChanged.listen((state) {
      isPlaying = (state == PlayerState.playing);
      if (state == PlayerState.completed) {
        position = Duration.zero;
      }
      onUpdate();
    });
  }

  /// پلے اور پاز ٹوگل
  static Future<void> togglePlay({required VoidCallback onUpdate}) async {
    if (audioPath.isEmpty) return;

    try {
      if (isPlaying) {
        await _player.pause();
      } else {
        final Source source = kIsWeb ? UrlSource(audioPath) : DeviceFileSource(audioPath);
        await _player.play(source);
      }
    } catch (e) {
      debugPrint('❌ آڈیو پلے ایرر: $e');
    }
    onUpdate();
  }

  /// آڈیو ڈیلیٹ کرنا
  static void deleteAudio({required VoidCallback onUpdate}) {
    try {
      _player.stop();
    } catch (_) {}
    audioPath = '';
    isPlaying = false;
    duration = Duration.zero;
    position = Duration.zero;
    recordSeconds = 0;
    onUpdate();
  }

  static void dispose() {
    _recordTimer?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _stateSub?.cancel();
    _recorder.dispose();
    _player.dispose();
  }
}