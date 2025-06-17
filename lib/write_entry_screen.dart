import 'package:flutter/material.dart';

// Definición de la paleta de colores como constantes
const Color kBackgroundColor = Color(0xfff0eff4);
const Color kPrimaryColor = Color(0xff004e64);
const Color kAccentColor = Color(0xffed6a5a);
const Color kHighlightColor = Color(0xffffdd4a);
const Color kDarkAccentColor = Color(0xff6b0f1a);

class WriteEntryScreen extends StatefulWidget {
  final String entryType;
  final String prompt;
  final String mood;
  final String pokemon;

  const WriteEntryScreen({
    Key? key,
    required this.entryType,
    required this.prompt,
    required this.mood,
    required this.pokemon,
  }) : super(key: key);

  @override
  _WriteEntryScreenState createState() => _WriteEntryScreenState();
}

class _WriteEntryScreenState extends State<WriteEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isPublic = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          'Nueva ${widget.entryType}',
          style: const TextStyle(color: kBackgroundColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBackgroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined, color: kBackgroundColor),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del estado de ánimo
            if (widget.mood.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.catching_pokemon, color: kPrimaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Te sientes ${widget.mood} como ${widget.pokemon}',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Prompt o pregunta guía
            if (widget.prompt.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kHighlightColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kHighlightColor.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: kDarkAccentColor),
                        const SizedBox(width: 8),
                        Text(
                          'Inspiración',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kDarkAccentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.prompt,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Campo de título
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
              decoration: InputDecoration(
                hintText: 'Título de tu ${widget.entryType}',
                hintStyle: TextStyle(
                  color: kPrimaryColor.withOpacity(0.6),
                ),
                border: InputBorder.none,
              ),
            ),
            
            const Divider(height: 32),
            
            // Campo de contenido
            TextField(
              controller: _contentController,
              maxLines: null,
              minLines: 10,
              style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Escribe aquí tu ${widget.entryType}...',
                hintStyle: TextStyle(
                  color: kPrimaryColor.withOpacity(0.6),
                ),
                border: InputBorder.none,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Opciones adicionales
            Row(
              children: [
                // Opción de privacidad
                Row(
                  children: [
                    Switch(
                      value: _isPublic,
                      onChanged: (value) {
                        setState(() {
                          _isPublic = value;
                        });
                      },
                      activeColor: kAccentColor,
                    ),
                    Text(
                      _isPublic ? 'Público' : 'Privado',
                      style: TextStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Botón para añadir imagen
                IconButton(
                  icon: Icon(Icons.image_outlined, color: kPrimaryColor),
                  onPressed: () {
                    // Implementar añadir imagen
                  },
                ),
                
                // Botón para programar
                IconButton(
                  icon: Icon(Icons.schedule_outlined, color: kPrimaryColor),
                  onPressed: () {
                    // Implementar programación
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveEntry() {
    // Aquí se implementaría la lógica para guardar la entrada
    // Por ahora, solo mostraremos un mensaje y volveremos atrás
    
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, añade un título a tu entrada'),
          backgroundColor: kAccentColor,
        ),
      );
      return;
    }
    
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, escribe algo en tu entrada'),
          backgroundColor: kAccentColor,
        ),
      );
      return;
    }
    
    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡${widget.entryType} guardada con éxito!'),
        backgroundColor: kPrimaryColor,
      ),
    );
    
    // Volver a la pantalla anterior
    Navigator.pop(context);
  }
}