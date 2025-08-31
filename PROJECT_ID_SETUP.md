# Configuración Rápida - Project ID de Reown

## 🚨 ACCIÓN REQUERIDA: Obtener Project ID

### Paso 1: Crear Proyecto en Reown Dashboard

1. **Ve a:** https://dashboard.reown.com/
2. **Regístrate** con tu email (es gratis)
3. **Crea nuevo proyecto:**
   - Project Name: `Koneque Marketplace`
   - Description: `Decentralized marketplace app`
   - Project Type: `App` 
4. **Copia tu Project ID** (será algo como: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`)

### Paso 2: Configurar en tu App

**Opción A: Usando dart-define (Recomendado)**
```bash
flutter run --dart-define=PROJECT_ID=tu_project_id_aqui
```

**Opción B: Hardcodeado en el código**
Edita `lib/services/reown_service.dart` línea 9-13:
```dart
static const String _projectId = String.fromEnvironment(
  'PROJECT_ID',
  defaultValue: 'TU_PROJECT_ID_REAL_AQUI', // ← Cambiar esto
);
```

### Paso 3: Probar

```bash
# Con tu Project ID real
flutter run --dart-define=PROJECT_ID=abc123...

# O simplemente
flutter run
```

## 🔍 ¿Cómo saber si funciona?

- ✅ **Funcionando:** App inicia normalmente, botón "Conectar con Wallet" funciona
- ❌ **Error:** Pantalla naranja con mensaje "Project ID requerido"

## 📱 Resultados Esperados

1. **Sin Project ID:** Pantalla de configuración con instrucciones
2. **Con Project ID válido:** App funciona, puedes conectar MetaMask/Trust Wallet
3. **Con Project ID inválido:** Error específico de Reown

---

**⏰ Tiempo estimado:** 5 minutos para crear cuenta + copiar Project ID
