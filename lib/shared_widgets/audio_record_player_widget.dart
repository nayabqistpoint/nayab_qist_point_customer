import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/services/audio_service.dart';

class AudioRecordPlayerWidget extends StatefulWidget {
  final Function(String? audioPath) onAudioChanged;

  const AudioRecordPlayerWidget({
    super.key,
    required this.onAudioChanged,
  });

  @override
  State<AudioRecordPlayerWidget> createState() => _AudioRecordPlayerWidgetState();
}

class _AudioRecordPlayerWidgetState extends State<AudioRecordPlayerWidget> {
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _audioService.addListener(() {
      widget.onAudioChanged(_audioService.recordedFilePath);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          if (_audioService.isRecording) ...[
            const Icon(Icons.fiber_manual_record, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text(
              "ریکارڈ ہو رہا ہے... ${_formatDuration(_audioService.recordDuration)}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 13),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.stop_circle, color: Colors.red, size: 30),
              onPressed: () => _audioService.stopRecording(),
            ),
          ] else if (_audioService.recordedFilePath != null) ...[
            IconButton(
              icon: Icon(
                _audioService.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: Colors.red,
                size: 32,
              ),
              onPressed: () => _audioService.togglePlay(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: _audioService.totalDuration.inMilliseconds > 0
                        ? _audioService.playPosition.inMilliseconds / _audioService.totalDuration.inMilliseconds
                        : 0.0,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_formatDuration(_audioService.playPosition)} / ${_formatDuration(_audioService.totalDuration)}",
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 22),
              onPressed: () {
                _audioService.reset();
                widget.onAudioChanged(null);
              },
            ),
          ] else ...[
            const Icon(Icons.mic_none, color: Colors.grey),
            const SizedBox(width: 8),
            const Text("صوتی پیغام ریکارڈ کریں", style: TextStyle(color: Colors.black54, fontSize: 13)),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 0,
              ),
              onPressed: () async {
                bool started = await _audioService.startRecording();
                if (!started && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("ریکارڈنگ کے لیے مائیکروفون کی اجازت ضروری ہے!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.mic, size: 16),
              label: const Text("ریکارڈ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}