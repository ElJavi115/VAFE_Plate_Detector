# VAFE — Sistema de detección de placas y gestión de incidencias

VAFE es un sistema móvil + backend para **identificar vehículos mediante lectura automática de placas** y **gestionar incidencias** relacionadas con control vehicular. La idea central es reducir el trabajo manual: el operador apunta la cámara a la matrícula, el sistema reconoce la placa y recupera los datos asociados (propietario/vehículo) desde una base de datos; además permite levantar reportes con evidencia y ubicación para su revisión.

Este proyecto fue desarrollado como una solución aplicada a un entorno institucional (control de acceso y orden vehicular), pero la arquitectura es reutilizable para escenarios similares.

---

## ¿Qué hace?

El sistema cubre dos frentes:

**1) Detección y lectura de placa**
La app móvil captura una imagen, detecta la región donde está la placa y delega la lectura de caracteres al backend. Si la placa existe en la base de datos, se muestran los datos del propietario y del vehículo para acelerar la verificación.

**2) Gestión de incidencias**
Los usuarios pueden crear incidencias con descripción, evidencia fotográfica y coordenadas (latitud/longitud). Un administrador revisa cada incidencia y decide aprobar o rechazar, disparando notificaciones por correo y actualizando el estado del usuario reportado.

---

## Arquitectura (alto nivel)

La solución está separada en tres piezas principales:

**Aplicación móvil (Flutter)**
- Inicio de sesión y navegación por módulos (usuarios, cámara, incidencias).
- Captura de foto y ejecución del detector de placas en el dispositivo.
- Creación de incidencias con fotos, descripción y ubicación.
- Consumo de la API para OCR y consulta de datos.

**Modelo en dispositivo: detección de placa**
- Detector entrenado con **Ultralytics YOLOv8** y exportado a **TFLite** para ejecutarse en móvil.
- El modelo devuelve bounding boxes; la app selecciona la mejor detección y **recorta la ROI** (la placa).

**Backend (FastAPI)**
- Endpoint para recibir la imagen recortada (multipart/form-data).
- OCR con **PaddleOCR** + postprocesamiento (normalización y filtrado) para obtener la cadena final de la placa.
- Consulta en **PostgreSQL** para cruzar placa ↔ vehículo ↔ propietario.
- Envío de correos (notificaciones) usando **SendGrid**.

## Roles y permisos

La aplicación maneja dos perfiles:

**Administrador**
Tiene control completo del sistema: gestión de usuarios/vehículos, acceso a todas las incidencias y capacidad de aprobar/rechazar reportes.

**Usuario**
Puede crear incidencias y consultar únicamente sus propios reportes (además de tener acceso a la cámara para escaneo, según la configuración del sistema).

---

## Incidencias: aprobación, notificaciones y bloqueo

Al crear una incidencia se captura:
- placa (por escaneo o búsqueda manual),
- datos asociados (si existe en BD),
- descripción,
- evidencia fotográfica,
- latitud/longitud.

Luego un administrador revisa:
- Si **rechaza**, la incidencia queda como rechazada y se notifica al reportante por correo.
- Si **aprueba**, la incidencia se marca como aprobada, se notifica al reportante y al reportado, y se incrementa el contador de incidencias del usuario afectado.

Regla de negocio: al acumular **3 incidencias**, el usuario cambia a estatus **Bloqueado**.

---

## Tecnologías

- **Mobile:** Flutter (cámara, manejo de imágenes, TFLite)
- **IA / Visión:** YOLOv8 (detección) + TFLite (ejecución en móvil), PaddleOCR (lectura de caracteres)
- **Backend:** FastAPI + SQLAlchemy + Pydantic
- **Base de datos:** PostgreSQL
- **Infra:** Docker / docker-compose
- **Notificaciones:** SendGrid (email)

Notas rápidas:
- Las credenciales (ej. API keys de correo) se manejan mediante variables de entorno (`.env`) para evitar exponer secretos.

---

## Métricas del detector (dataset de validación)

En la evaluación del detector de placas se reportaron métricas altas (precisión ~0.99, recall ~0.997, mAP@0.5 ~0.995). Considera estas cifras como referencia del entrenamiento/validación usado en el proyecto.

---

## Demo

- Video demo: (https://drive.google.com/file/d/1uN21LLpd6ZVo3sK-3gGFet3lF7uWZdUX/view?usp=drive_link)

---