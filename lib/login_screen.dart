import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/register_screen.dart';

// Definición de la paleta de colores como constantes
const Color kBackgroundColor = Color(0xfff0eff4);
const Color kPrimaryColor = Color(0xff004e64);
const Color kAccentColor = Color(0xffed6a5a);
const Color kHighlightColor = Color(0xffffdd4a);
const Color kDarkAccentColor = Color(0xff6b0f1a);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _errorMessage = '';
  bool _isLoading = false;
  bool _obscurePassword = true; // Para mostrar/ocultar contraseña

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        // Si el inicio de sesión es exitoso
        print('Usuario conectado: ${userCredential.user!.email}');
        // La navegación se manejará automáticamente si estás usando StreamBuilder
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'No encontramos un entrenador con este email.';
            break;
          case 'wrong-password':
            message = 'La contraseña no es correcta.';
            break;
          case 'invalid-email':
            message = 'El formato del email no es válido.';
            break;
          case 'user-disabled':
            message = 'Esta cuenta ha sido deshabilitada.';
            break;
          default:
            message = 'Error al iniciar sesión: ${e.message ?? 'desconocido'}';
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
                  // Logo de Pokéball
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kAccentColor,
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset('assets/logo.png', width: 80, height: 80),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Título principal
                  Text(
                    'Arbook',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      letterSpacing: 1.5,
                    ),
                  ),

                  // Subtítulo
                  Text(
                    'Tu Pokédex emocional',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: kDarkAccentColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Campo de email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email del Entrenador',
                      hintText: 'Ingresa tu correo electrónico',
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
                      hintText: 'Ingresa tu contraseña secreta',
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
                        return 'Por favor, ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),

                  const SizedBox(height: 10),

                  // Enlace para recuperar contraseña
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Implementar recuperación de contraseña
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kPrimaryColor,
                      ),
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón de inicio de sesión o indicador de carga
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kHighlightColor),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _signIn,
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
                            'Iniciar Aventura',
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

                  const SizedBox(height: 30),

                  // Separador
                  Row(
                    children: [
                      Expanded(child: Divider(color: kPrimaryColor.withOpacity(0.3))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '¿Nuevo entrenador?',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                      Expanded(child: Divider(color: kPrimaryColor.withOpacity(0.3))),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Botón para crear cuenta
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                      side: BorderSide(color: kPrimaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Comenzar mi Viaje',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón para acceder directamente (modo desarrollo)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Modo desarrollo: ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/direct-home');
                          },
                          child: const Text(
                            'Acceder sin autenticación',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
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
