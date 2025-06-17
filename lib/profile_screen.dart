import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'services/database_service.dart';
import 'models/user_model.dart';
import 'recommendations.dart';

// Definición de la paleta de colores como constantes
const Color kBackgroundColor = Color(0xfff0eff4);
const Color kPrimaryColor = Color(0xff004e64);
const Color kAccentColor = Color(0xffed6a5a);
const Color kHighlightColor = Color(0xffffdd4a);
const Color kDarkAccentColor = Color(0xff6b0f1a);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  File? _imageFile;
  String _imageUrl = '';
  UserModel? _user;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Cargar el perfil del usuario
  Future<void> _loadUserProfile() async {
    if (_databaseService.currentUser == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userData = await _databaseService.getUserProfile(
        _databaseService.currentUser!.uid
      );
      
      if (userData != null) {
        setState(() {
          _user = UserModel.fromFirestore(
            userData as dynamic
          );
          _displayNameController.text = _user!.displayName;
          _bioController.text = _user!.bio;
          _imageUrl = _user!.profileImageUrl;
        });
      } else {
        // Si no hay perfil, usar datos del usuario autenticado
        setState(() {
          _displayNameController.text = _databaseService.currentUser!.displayName ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar perfil: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Seleccionar imagen de perfil
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isLoading = true;
        });
        
        // Subir la imagen a Firebase Storage
        try {
          _imageUrl = await _databaseService.uploadImage(_imageFile!, 'profile_images');
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

  // Guardar perfil
  Future<void> _saveProfile() async {
    if (_displayNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un nombre de usuario'),
          backgroundColor: kAccentColor,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _databaseService.updateUserProfile(
        displayName: _displayNameController.text,
        bio: _bioController.text,
        profileImageUrl: _imageUrl,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: kPrimaryColor,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar perfil: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
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
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: kBackgroundColor),
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
                  onPressed: _saveProfile,
                ),
        ],
      ),
      body: _isLoading && _user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Imagen de perfil
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: kPrimaryColor.withOpacity(0.2),
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!) as ImageProvider
                              : _imageUrl.isNotEmpty
                                  ? NetworkImage(_imageUrl) as ImageProvider
                                  : null,
                          child: _imageFile == null && _imageUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: kPrimaryColor,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: kAccentColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Nombre de usuario
                  TextField(
                    controller: _displayNameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de Entrenador',
                      hintText: '¿Cómo quieres que te llamen?',
                      prefixIcon: Icon(Icons.person_outline, color: kPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kHighlightColor, width: 2.0),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Biografía
                  TextField(
                    controller: _bioController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Biografía',
                      hintText: 'Cuéntanos sobre ti...',
                      prefixIcon: Icon(Icons.edit_note, color: kPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kHighlightColor, width: 2.0),
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Estadísticas del usuario
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: kPrimaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Estadísticas de Entrenador',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Estadísticas en formato de tarjetas
                          Row(
                            children: [
                              _buildStatCard('Entradas', '0', Icons.note_alt_outlined, kPrimaryColor),
                              const SizedBox(width: 12),
                              _buildStatCard('Públicas', '0', Icons.public, kAccentColor),
                              const SizedBox(width: 12),
                              _buildStatCard('Programadas', '0', Icons.schedule, kHighlightColor),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Estadísticas adicionales
                          _buildStatItem('Pokémon favorito', _selectedMood.isEmpty ? 'Ninguno' : _selectedPokemon, Icons.catching_pokemon),
                          const Divider(),
                          _buildStatItem('Fecha de registro', DateFormat('dd/MM/yyyy').format(DateTime.now()), Icons.calendar_today),
                          const Divider(),
                          _buildStatItem('Estado de cuenta', 'Activa', Icons.verified_user),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Recomendaciones favoritas
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: kHighlightColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: kDarkAccentColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Mis Favoritos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkAccentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Mensaje para usuarios sin favoritos
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: kDarkAccentColor.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aún no tienes recomendaciones favoritas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Guarda tus libros, películas y canciones favoritas para acceder rápidamente a ellas.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kPrimaryColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Botón para explorar recomendaciones
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Navegar a la pantalla de recomendaciones
                              },
                              icon: const Icon(Icons.explore),
                              label: const Text('Explorar recomendaciones'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kDarkAccentColor,
                                side: BorderSide(color: kDarkAccentColor),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón para cerrar sesión
                  OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kAccentColor,
                      side: BorderSide(color: kAccentColor),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: kPrimaryColor),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kDarkAccentColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // Variables para el estado de ánimo seleccionado
  String get _selectedMood {
    return _user?.displayName?.contains('Energético') == true ? 'Energético' :
           _user?.displayName?.contains('Tranquilo') == true ? 'Tranquilo' :
           _user?.displayName?.contains('Apasionado') == true ? 'Apasionado' :
           _user?.displayName?.contains('Equilibrado') == true ? 'Equilibrado' :
           _user?.displayName?.contains('Relajado') == true ? 'Relajado' :
           _user?.displayName?.contains('Adaptable') == true ? 'Adaptable' : '';
  }
  
  String get _selectedPokemon {
    return _selectedMood == 'Energético' ? 'Pikachu' :
           _selectedMood == 'Tranquilo' ? 'Squirtle' :
           _selectedMood == 'Apasionado' ? 'Charmander' :
           _selectedMood == 'Equilibrado' ? 'Bulbasaur' :
           _selectedMood == 'Relajado' ? 'Snorlax' :
           _selectedMood == 'Adaptable' ? 'Eevee' : '';
  }
}