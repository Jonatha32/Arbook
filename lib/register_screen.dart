import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Definición de la paleta de colores como constantes
const Color kBackgroundColor = Color(0xfff0eff4);
const Color kPrimaryColor = Color(0xff004e64);
const Color kAccentColor = Color(0xffed6a5a);
const Color kHighlightColor = Color(0xffffdd4a);
const Color kDarkAccentColor = Color(0xff6b0f1a);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  String _repeatPassword = '';
  String _errorMessage = '';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;
  String _selectedStarter = 'Ninguno';

  // Lista de Pokémon iniciales
  final List<Map<String, dynamic>> _starters = [
    {'name': 'Bulbasaur', 'type': 'Planta', 'color': Colors.green},
    {'name': 'Charmander', 'type': 'Fuego', 'color': kAccentColor},
    {'name': 'Squirtle', 'type': 'Agua', 'color': Colors.blue},
  ];

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        
        // Actualizar el nombre de usuario
        await userCredential.user!.updateDisplayName(_username);
        
        // Opcional: Enviar email de verificación
        await userCredential.user!.sendEmailVerification();
        
        // Registro exitoso
        print('Usuario registrado: ${userCredential.user!.email}');
        
        // Mostrar mensaje de éxito antes de volver a la pantalla de login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Felicidades! Tu viaje Pokémon ha comenzado. Verifica tu email.'),
            backgroundColor: kPrimaryColor,
          ),
        );
        
        // Volver a la pantalla de login
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'weak-password':
            message = 'La contraseña es demasiado débil para proteger a tus Pokémon.';
            break;
          case 'email-already-in-use':
            message = 'Ya existe un entrenador con este email.';
            break;
          case 'invalid-email':
            message = 'El formato del email no es válido.';
            break;
          default:
            message = 'Error al registrar entrenador: ${e.message ?? 'desconocido'}';
        }
        setState(() {
          _errorMessage = message;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Ocurrió un error inesperado: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
          'Registro de Entrenador',
          style: TextStyle(color: kBackgroundColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBackgroundColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Título principal
                  Text(
                    'Comienza tu Aventura',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kDarkAccentColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  // Subtítulo
                  Text(
                    'Captura tus emociones como un verdadero entrenador',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Selección de Pokémon inicial
                  Text(
                    'Elige tu Pokémon inicial:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Opciones de Pokémon inicial
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _starters.map((starter) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStarter = starter['name'];
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: starter['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: _selectedStarter == starter['name']
                                      ? starter['color']
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.asset(
                                    'assets/${starter['name'].toLowerCase()}.jpg',
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              starter['type'],
                              style: TextStyle(
                                fontSize: 12,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Campo de nombre de usuario
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nombre de Entrenador',
                      hintText: '¿Cómo te llaman en el mundo Pokémon?',
                      prefixIcon: Icon(Icons.person_outline, color: kPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kHighlightColor, width: 2.0),
                      ),
                      labelStyle: TextStyle(color: kPrimaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa tu nombre de entrenador';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!.trim();
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Campo de email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email del Entrenador',
                      hintText: 'Ingresa tu correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined, color: kPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kHighlightColor, width: 2.0),
                      ),
                      labelStyle: TextStyle(color: kPrimaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa tu email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Ingresa un email válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!.trim();
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Campo de contraseña
                  TextFormField(
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      hintText: 'Crea una contraseña segura',
                      prefixIcon: Icon(Icons.lock_outline, color: kPrimaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kHighlightColor, width: 2.0),
                      ),
                      labelStyle: TextStyle(color: kPrimaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa una contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      _password = value; // Guardar para comparar con la repetición
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Campo de repetir contraseña
                  TextFormField(
                    obscureText: _obscureRepeatPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      hintText: 'Repite tu contraseña',
                      prefixIcon: Icon(Icons.lock_reset, color: kPrimaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureRepeatPassword ? Icons.visibility : Icons.visibility_off,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureRepeatPassword = !_obscureRepeatPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kHighlightColor, width: 2.0),
                      ),
                      labelStyle: TextStyle(color: kPrimaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirma tu contraseña';
                      }
                      if (value != _password) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _repeatPassword = value!;
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Botón de registro o indicador de carga
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kHighlightColor),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentColor,
                            foregroundColor: kBackgroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Comenzar Aventura',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                  
                  const SizedBox(height: 20),
                  
                  // Mensaje de error si existe
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kAccentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kAccentColor),
                      ),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: kAccentColor, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Enlace para volver a login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya eres un entrenador? ',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: kDarkAccentColor,
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Inicia Sesión',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}