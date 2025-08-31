import 'package:privy_flutter/privy_flutter.dart';

/// Servicio de autenticación con Privy.
/// Reemplaza los placeholders de appId/appClientId por tus credenciales reales.
late dynamic privy; // instancia global (dynamic para compatibilidad)

class PrivyService {
  /// Inicializa Privy; si no pasas [config], usa placeholders.
  static Future<void> init({PrivyConfig? config}) async {
    final cfg =
        config ??
        PrivyConfig(
          appId: 'cmeyryhv8006slb0b0tmejj7z',
          appClientId: 'client-WY6PsnVnxnzLaWsimMzALianh8tDpv2As7CdGdPne7bk3',
        );

    final p = Privy.init(config: cfg);
    privy = p;
  }

  static Future<AuthState> getAuthState() async {
    return await privy.getAuthState();
  }

  static Future<dynamic> getCurrentUser() async {
    try {
      final state = await privy.getAuthState();
      return state.user;
    } catch (_) {
      return null;
    }
  }

  /// Enviar OTP o verificar código
  /// - Si [code] es null: envía otp por email
  /// - Si [code] no es null: verifica y devuelve el user
  static Future<dynamic> loginWithEmail(String email, {String? code}) async {
    if (code == null) {
      return await privy.email.sendCode(email);
    }

    final result = await privy.email.loginWithCode(email: email, code: code);
    dynamic user;
    result.fold(
      onSuccess: (u) => user = u,
      onFailure: (err) => throw Exception(err.message),
    );
    return user;
  }

  static Future<void> logout() async {
    await privy.logout();
  }
}
