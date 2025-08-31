# 🔧 Guía de Solución de Problemas - Koneque Marketplace

## ❌ Problema: MetaMask se queda cargando

### 🔍 **Síntomas:**
- Al seleccionar MetaMask, la aplicación se abre pero queda cargando indefinidamente
- La conexión no se completa
- No hay mensajes de error específicos

### ✅ **Soluciones Implementadas:**

#### 1. **Deep Links Configurados**
- ✅ Agregado soporte para esquema `koneque://` en AndroidManifest.xml
- ✅ Configurado manejo de deep links en MainActivity.kt
- ✅ Habilitado OnBackInvokedCallback para mejor navegación

#### 2. **Manejo de Errores Mejorado**
- ✅ Timeouts configurados (30 segundos para modal, 60 segundos para conexión)
- ✅ Mensajes de error específicos y amigables
- ✅ Botón de reintentar conexión
- ✅ Indicadores visuales de estado de conexión

#### 3. **Configuración de Red**
- ✅ Base Sepolia (Chain ID: 84532) configurada como red principal
- ✅ Base Mainnet disponible como opción
- ✅ RPC URLs y exploradores configurados

---

## 🚀 **Pasos para Probar la Conexión:**

### **Paso 1: Verificar MetaMask**
1. Asegúrate de que MetaMask esté instalado en tu dispositivo
2. Abre MetaMask y verifica que esté funcionando
3. Configura la red Base Sepolia en MetaMask:
   - **Nombre:** Base Sepolia
   - **RPC URL:** `https://sepolia.base.org`
   - **Chain ID:** `84532`
   - **Símbolo:** `ETH`
   - **Explorer:** `https://sepolia.basescan.org`

### **Paso 2: Usar la Aplicación**
1. Abrir la aplicación Koneque
2. Tocar el botón "Conectar" en la esquina superior derecha
3. Seleccionar MetaMask de la lista
4. Seguir las instrucciones en MetaMask

### **Paso 3: Si Hay Problemas**
1. **Error de Timeout:** 
   - Reintentar la conexión usando el botón "Reintentar"
   - Verificar conexión a internet
   - Cerrar y abrir MetaMask

2. **Error de Sesión:**
   - Desconectar en la app (si está parcialmente conectado)
   - Limpiar sesiones en MetaMask
   - Intentar conectar nuevamente

3. **Error de Red:**
   - Verificar que MetaMask esté en Base Sepolia
   - Cambiar de red y volver a Base Sepolia
   - Reiniciar MetaMask si es necesario

---

## 🛠️ **Características de Depuración:**

### **Logs Disponibles:**
```
✅ Reown AppKit inicializado exitosamente
🔗 Iniciando conexión de wallet...
⏰ Timeout al abrir modal de wallet
❌ Error conectando wallet: [mensaje específico]
```

### **Estados de la Aplicación:**
- 🔴 **Desconectado:** Sin wallet conectada
- 🟡 **Conectando:** Proceso de conexión en curso
- 🟢 **Conectado:** Wallet conectada exitosamente
- 🔴 **Error:** Error específico mostrado

### **Información de Red:**
- **Red Principal:** Base Sepolia (Testnet)
- **Contratos Desplegados:** ✅ Todos los contratos funcionando
- **IPFS (Pinata):** ✅ Conexión exitosa

---

## 📋 **Checklist de Verificación:**

### **Antes de Conectar:**
- [ ] MetaMask instalado y funcionando
- [ ] Red Base Sepolia configurada
- [ ] Conexión a internet estable
- [ ] Aplicación Koneque actualizada

### **Durante la Conexión:**
- [ ] Modal de wallets se abre correctamente
- [ ] MetaMask aparece en la lista
- [ ] Al tocar MetaMask, la app se abre
- [ ] Aprobar conexión en MetaMask
- [ ] Volver a la aplicación automáticamente

### **Después de Conectar:**
- [ ] Estado cambia a "Wallet Conectada"
- [ ] Dirección de wallet visible
- [ ] Balance ETH mostrado
- [ ] Botones de acción habilitados

---

## 🆘 **Solución de Emergencia:**

Si nada funciona:

1. **Restart Completo:**
   ```bash
   # Cerrar completamente ambas aplicaciones
   # Reiniciar el dispositivo
   # Abrir MetaMask primero
   # Luego abrir Koneque
   ```

2. **Limpiar Datos:**
   - Limpiar caché de MetaMask
   - Reinstalar Koneque si es necesario
   - Reconfigurar red Base Sepolia

3. **Usar Otra Wallet:**
   - Coinbase Wallet también está soportada
   - Trust Wallet como alternativa
   - Wallet nativa del navegador

---

## 📞 **Soporte Técnico:**

### **Información para Reportar:**
- Modelo de dispositivo
- Versión de Android
- Versión de MetaMask
- Logs específicos de error
- Pasos exactos que causaron el problema

### **Logs Útiles:**
```
I/flutter: 🔗 Iniciando conexión de wallet...
I/flutter: ⏰ Timeout al abrir modal de wallet
I/flutter: ❌ Error conectando wallet: [detalles]
```

---

## ✨ **Funcionalidades Disponibles Después de Conectar:**

1. **Marketplace:**
   - Ver productos listados
   - Comprar productos con ETH o tokens
   - Listar tus propios productos

2. **Sistema de Referidos:**
   - Generar códigos de referidos
   - Ganar comisiones por referencias

3. **Gestión de Transacciones:**
   - Ver historial de compras/ventas
   - Confirmar entregas
   - Finalizar transacciones

4. **IPFS Integration:**
   - Subir imágenes de productos
   - Metadatos descentralizados
   - Storage permanente

---

## 🎯 **Próximos Pasos:**

Una vez conectado, puedes:
1. Explorar el marketplace
2. Listar tu primer producto
3. Probar una compra de prueba
4. Usar códigos de referidos
5. Verificar transacciones en [Base Sepolia Explorer](https://sepolia.basescan.org)
