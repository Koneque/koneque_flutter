import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reown_appkit/reown_appkit.dart';

class DeepLinkHandler {
  static const _eventChannel = EventChannel('com.koneque.app/events');
  static late ReownAppKitModal _appKitModal;

  static void init(ReownAppKitModal appKitModal) {
    if (kIsWeb) return;

    try {
      _appKitModal = appKitModal;
      _eventChannel.receiveBroadcastStream().listen(_onLink, onError: _onError);
    } catch (e) {
      debugPrint('[KonequeApp] DeepLinkHandler init error: $e');
    }
  }

  static void _onLink(dynamic link) async {
    try {
      if (link != null && link is String) {
        debugPrint('[KonequeApp] Received deep link: $link');
        await _appKitModal.dispatchEnvelope(link);
      }
    } catch (e) {
      debugPrint('[KonequeApp] Error processing deep link: $e');
    }
  }

  static void _onError(dynamic error) {
    debugPrint('[KonequeApp] DeepLinkHandler error: $error');
  }
}
