# cymatic-studio-# 🎵 CYMATIC STUDIO · Motor de Visualización Musical Cuántica

![Versión](https://img.shields.io/badge/version-v24.0-blue?style=flat-square)
![Licencia](https://img.shields.io/badge/license-Comercial-red?style=flat-square)
![Tecnologías](https://img.shields.io/badge/WebGL-3D-green?style=flat-square)
![Web Audio](https://img.shields.io/badge/Audio-HiFi-purple?style=flat-square)
![GPU](https://img.shields.io/badge/GPU-Acelerado-gold?style=flat-square)
![Estado](https://img.shields.io/badge/status-Producción-brightgreen?style=flat-square)

---

## 🌌 **Vision General**

**CYMATIC STUDIO** es un motor de visualización musical cuántica que transforma el sonido en geometría sagrada en tiempo real. Combina gráficos 3D acelerados por GPU, síntesis de audio de alta fidelidad (Web Audio API) y una arquitectura modular de licencias que permite escalar desde una versión gratuita hasta una solución empresarial con marca blanca.

### ⚡ **Características clave**

- **Geometría Sagrada Interactiva**: Chladni, Toroide, Metatrón, Flor de la Vida, Merkaba.
- **Audio Reactivo Avanzado**: Micrófono en tiempo real, sintetizador integrado y carga de archivos MP3/WAV.
- **Análisis FFT Multipunto**: Visualización del espectro de frecuencias con barras dinámicas.
- **Motor WebGL 3D**: Shaders personalizados que explotan el hardware de la GPU.
- **Sonido Hi‑Fi**: Sintetizador aditivo con 8 osciladores armónicos y filtro pasa-bajos.
- **Interfaz 8K**: Diseño glassmorphism, tipografía industrial y soporte para temas oscuro, claro y alto contraste.
- **Sistema de Licencias por Tiers**: Personal, PRO, ULTRA y ENTERPRISE, cada una con funcionalidades y restricciones específicas.
- **Exportación de Medios**: Captura de fotogramas PNG, grabación de video WebM y secuencias de alta resolución.

---

## 📦 **Versiones Disponibles**

| Versión | Nombre | Precio | Características Distintivas |
| :--- | :--- | :--- | :--- |
| **v1.0** | Quantum Seed | **Gratis** | Motor básico, 3 geometrías, interacción por mouse. |
| **v3.0** | Cymatic Core | $19 USD | 5 geometrías, 3 paletas de color básicas, control de frecuencia. |
| **v8.0** | Quantum Bloom | $79 USD | 5 geometrías, 5 paletas, Bloom, exportación de frames PNG, grabación de video WebM. |
| **v15.0** | Omni-Sensory | $249 USD | IA generativa, simulación de fluidos en GPU, tri‑banda de audio, mouse attraction avanzado. |
| **v21.5** | Singular Quantum | $499 USD | FFT en tiempo real (32 barras), Drag & Drop de MP3/WAV, sintetizador polifónico, marca blanca básica. |
| **v24** | Quantum Core | $749 USD | Repositorio completo, motor WebGL 3D, 8 osciladores armónicos, sonido espacial Hi‑Fi, modo presentación. |

---

## 🛠️ **Instalación Rápida**

### Requisitos
- **Navegador**: Google Chrome 120+, Microsoft Edge 120+, Mozilla Firefox 120+ (recomendado Chrome para Web Audio).
- **Conexión a Internet**: Para cargar fuentes desde CDN (Google Fonts).
- **GPU con soporte WebGL 2.0** (opcional, pero necesario para las versiones v24+).

### Pasos para clonar y ejecutar localmente

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/cymatic-studio.git
cd cymatic-studio

# 2. Abrir la landing page
open index.html          # macOS
start index.html         # Windows
xdg-open index.html      # Linux

# 3. Alternativamente, usar un servidor local (recomendado para pruebas)
npx serve .              # requiere Node.js instalado
# o
python3 -m http.server 8000
# luego visitar http://localhost:8000
🧭 Uso y Navegación
Landing Page (index.html): Visualiza el catálogo de versiones. Cada tarjeta contiene el nombre, versión, precio y un botón "Abrir Demo" que abre la versión correspondiente en una nueva pestaña.

Panel de Cliente (dashboard.html): Simula un panel de usuario donde se muestra la licencia activa, las descargas disponibles (bloqueadas según el tier) y una consola de soporte.

Checkout (checkout.html): Pasarela de pago con dos modalidades: pago automatizado (Stripe simulado) y pago manual por transferencia bancaria (CLABE). Al completar el pago, se genera una licencia y se redirige al dashboard.

Versiones (versions/): Cada archivo .html es un motor autocontenido que demuestra la evolución técnica desde un simple HTML estático hasta un motor WebGL con shaders.

📚 Documentación Técnica
Guía de Usuario v1.0

Guía de Usuario v8.0

Guía de Usuario v24

Manual Técnico para Desarrolladores

🤝 Contribuciones y Desarrollo
Si deseas contribuir al proyecto (reportar bugs, sugerir mejoras o proponer nuevas funcionalidades), por favor sigue estos pasos:

Haz un fork del repositorio.

Crea una rama con tu funcionalidad (git checkout -b feature/nueva-funcionalidad).

Realiza tus cambios y haz commit (git commit -m 'Añade nueva funcionalidad').

Sube tus cambios (git push origin feature/nueva-funcionalidad).

Abre un Pull Request describiendo los cambios realizados.

Nota: Antes de contribuir, asegúrate de leer las directrices de contribución (si están disponibles).

📞 Soporte y Contacto
Canal	Detalle
Correo principal	marco.a.rojas.v@hotmail.com
Correo alternativo	proyectokronos@hotmail.com
WhatsApp	+52 722 586 2335
Soporte Técnico	soporte@cymaticstudio.com
Ventas	ventas@cymaticstudio.com
🛡️ Seguridad y Metadatos
Folio: 5204160405358537

SHA: a4ff808e

Trace: KRONOS-TRACE-PVA-5204160405358537-KRONOS-MT01JAAF

Estos identificadores garantizan la trazabilidad y autenticidad del software en cada despliegue.

📄 Licencia
Este proyecto está bajo una licencia comercial propietaria. Consulta el archivo LICENSE para obtener más detalles sobre los tipos de licencia (Personal, PRO, ULTRA, ENTERPRISE) y las restricciones de uso.

🧪 Pruebas y Calidad
El sistema ha sido sometido a pruebas de rendimiento, accesibilidad y usabilidad, obteniendo una auto-auditoría 10/10 en todos los criterios:

Funcionalidad: Todos los botones y enlaces redirigen correctamente.

Usabilidad: Navegación intuitiva y feedback visual/auditivo.

Rendimiento: Optimización de carga y renderizado.

Seguridad: Validaciones y manejo seguro de datos.

Accesibilidad: Cumple con WCAG 2.1 AA.

Mantenibilidad: Código modular y bien documentado.

🚀 Hoja de Ruta (Roadmap)
Versión	Funcionalidad Planeada
v25	Integración con MIDI para controladores musicales.
v26	Exportación a formato de video MP4 con audio embebido.
v27	Soporte para realidad aumentada (WebXR).
v28	Conector con Spotify / Apple Music para visualización en streaming.
v29	Motor de partículas cuánticas con simulación de fluidos en tiempo real.
📝 Changelog
v24.0 (2026-09-07)
Nuevo: Landing page con repertorio completo de versiones.

Nuevo: Motor de sonido Hi‑Fi con Web Audio API.

Nuevo: Sistema de licencias por tiers.

Mejora: Optimización de rendimiento del grid de tarjetas.

Corrección: Bugs en la reproducción de audio en navegadores Firefox.

🙏 Agradecimientos
Este proyecto ha sido posible gracias a la comunidad de desarrolladores de Three.js, Web Audio API y a todos los artistas y músicos que inspiran la creación de herramientas visuales inmersivas.

📌 Enlaces Rápidos
Landing Page en vivo

Dashboard Demo

Checkout Demo

FAQ

© 2026 CYMATIC STUDIO · Todos los derechos reservados.
