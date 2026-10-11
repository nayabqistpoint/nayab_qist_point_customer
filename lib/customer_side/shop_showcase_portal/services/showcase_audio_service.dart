// lib/customer_side/shop_showcase_portal/services/showcase_audio_service.dart

class ShowcaseAudioService {
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool togglePlayState() {
    _isPlaying = !_isPlaying;
    return _isPlaying;
  }

  void stop() {
    _isPlaying = false;
  }
}