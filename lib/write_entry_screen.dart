import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'services/database_service.dart';

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
  bool _isLoading = false;
  File? _imageFile;
  String _imageUrl = '';
  DateTime? _scheduledDate;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  // Método para seleccionar una imagen de la galería
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        
        // Mostrar indicador de carga
        setState(() {
          _isLoading = true;
        });
        
        // Subir la imagen a Firebase Storage
        try {
          final databaseService = DatabaseService();
          _imageUrl = await databaseService.uploadImage(_imageFile!, 'entry_images');
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Imagen subida correctamente'),
              backgroundColor: kPrimaryColor,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al subir la imagen: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar la imagen: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // Método para seleccionar una fecha programada
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _scheduledDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: kBackgroundColor,
              onSurface: kPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _scheduledDate) {
      setState(() {
        _scheduledDate = picked;
      });
    }
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
          _isLoading
              ? Container(
                  margin: const EdgeInsets.all(14),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kBackgroundColor),
                    strokeWidth: 2,
                  ),
                )
              : IconButton(
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
            
            // Vista previa de la imagen
            if (_imageFile != null)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(_imageFile!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                        _imageUrl = '';
                      });
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ),
            
            // Indicador de fecha programada
            if (_scheduledDate != null)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kHighlightColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kHighlightColor.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: kDarkAccentColor),
                    const SizedBox(width: 8),
                    Text(
                      'Programado para: ${DateFormat('dd/MM/yyyy').format(_scheduledDate!)}',
                      style: TextStyle(
                        color: kDarkAccentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: kDarkAccentColor),
                      onPressed: () {
                        setState(() {
                          _scheduledDate = null;
                        });
                      },
                      iconSize: 18,
                    ),
                  ],
                ),
              ),
            
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
                  onPressed: _pickImage,
                  tooltip: 'Añadir imagen',
                ),
                
                // Botón para programar
                IconButton(
                  icon: Icon(Icons.schedule_outlined, color: kPrimaryColor),
                  onPressed: () => _selectDate(context),
                  tooltip: _scheduledDate == null 
                      ? 'Programar para el futuro' 
                      : 'Programado para: ${DateFormat('dd/MM/yyyy').format(_scheduledDate!)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEntry() async {
    // Validar campos
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
    
    try {
      // Mostrar indicador de carga
      setState(() {
        _isLoading = true;
      });
      
      // Importar el servicio de base de datos
      final databaseService = DatabaseService();
      
      // Guardar la entrada en Firestore
      await databaseService.saveEntry(
        title: _titleController.text,
        content: _contentController.text,
        entryType: widget.entryType,
        prompt: widget.prompt,
        mood: widget.mood,
        pokemon: widget.pokemon,
        isPublic: _isPublic,
        imageUrl: _imageUrl,
        scheduledDate: _scheduledDate,
      );
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡${widget.entryType} guardada con éxito!'),
          backgroundColor: kPrimaryColor,
        ),
      );
      
      // Volver a la pantalla anterior
      Navigator.pop(context);
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Ocultar indicador de carga
      setState(() {
        _isLoading = false;
      });
    }
  }
}