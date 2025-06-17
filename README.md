# myapp

Nombre (tentativo): Eterna – Your Emotional Library

🎯 PROPÓSITO:
Crear una app o página web que sirva como biblioteca emocional y artística, donde los usuarios puedan escribir y guardar cartas, pensamientos, notas, recuerdos o ideas creativas.
A diferencia de otras apps como Notion o Google Keep, Eterna está pensada para guardar lo que sentimos, no solo lo que hacemos.

👤 TIPO DE USUARIO:
Artistas, escritores o creativos

Personas que usan la escritura como vía emocional

Quienes quieren guardar recuerdos personales

Usuarios que buscan escribirle a un ser querido, a su yo futuro o a alguien que ya no está

💎 DIFERENCIALES CLAVE:
Narrativa emocional:

No hay "nota nueva", sino "¿Qué querés expresar hoy?"

La interfaz guía al usuario con calidez y profundidad

Cartas programadas:

Podés escribir cartas para vos mismo en el futuro (tipo “abrir el 7/11/2026”)

Ideal para propósitos, aniversarios o recuerdos

Diseño visual artístico:

Cada nota o carta puede tener:

Fondo personalizado

Tipografía manuscrita

Ícono de estado emocional (💔, ✨, 🌧)

Música asociada (Spotify API)

Película o libro sugerido

Imagen o GIF de portada

Mapa emocional / calendario emocional:

Visualización de tus entradas emocionales por día, color y tipo de emoción

Modo privado y público:

Cartas pueden ser privadas o públicas

Público puede seguir a otros usuarios (tipo “diarios públicos”)

Notificaciones si una persona a la que seguís publica algo nuevo

Extensión creativa (opcional futuro):

Impresión física de tus cartas en una caja

Recopilación temática (cartas de amor, para uno mismo, etc.)

🔐 AUTENTICACIÓN:
Registro e inicio de sesión con Firebase Auth (email/password, Google, etc.)

Verificación de correo

Posible integración con redes sociales para vincular seguidores (opcional)

🔧 BACKEND:
Firestore como base de datos

Almacenamiento de cartas, metadatos, perfiles, reacciones

Firebase Storage para imágenes de portada o audios

Functions si es necesario para cron jobs (por ejemplo, activar cartas programadas)

📱 FRONTEND:
Se puede desarrollar en:

OPCIÓN 1: Flutter (app móvil)
Pros:

Mayor conexión emocional (escribir desde el celular es más íntimo)

Push notifications para recordar escribir o desbloquear cartas programadas

Mejor UX para quienes ya usan Notas/Keep

OPCIÓN 2: React (web app)
Pros:

Más cómodo para escritores/artistas que prefieren teclado

Más amigable para diseño visual amplio y edición creativa

Mi consejo: empezá por Flutter móvil si querés algo más emocional y artístico.
Luego, escalás a web para sincronizar experiencias.

🧩 COLECCIONES DE FIRESTORE (modelo propuesto):
js
Copy
Edit
users
  └─ userId
       ├─ displayName
       ├─ bio
       ├─ profileImage
       ├─ socialLinks
       └─ settings

notes
  └─ noteId
       ├─ title
       ├─ content
       ├─ userId
       ├─ isPublic
       ├─ emotionTag
       ├─ media (url Spotify/YouTube)
       ├─ scheduledDate (opcional)
       ├─ createdAt
       └─ updatedAt
🪐 SLOGAN (ideas):
“Don’t just save notes — keep what you feel.”

“A house for your soul’s memories.”

“Write for the present, remember for eternity.”

✅ VALOR FINAL:
Esta app no busca productividad, sino memoria emocional.
Una especie de diario digital artístico, íntimo, musical y visual, en donde cada entrada tiene alma.
