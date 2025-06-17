import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool _isLoading = false; // Nueva variable para controlar el estado de carga

  //Función para iniciar sesión
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true; // Mostrar indicador de carga
        _errorMessage = ''; // Limpiar mensaje de error anterior
      });
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        // Si el inicio de sesión es exitoso:
        print('Usuario logeado: ${userCredential.user!.email}');
        // Aquí puedes navegar a tu pantalla de inicio (HomeScreen)
        // Ejemplo: Navigator.pushReplacementNamed(context, '/home');
        // O, si estás usando el StreamBuilder en main.dart, la navegación es automática.
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'No se encontró un usuario con ese email.';
            break;
          case 'wrong-password':
            message = 'Contraseña incorrecta.';
            break;
          case 'invalid-email':
            message = 'El formato del email es inválido.';
            break;
          case 'user-disabled':
            message = 'Este usuario ha sido deshabilitado.';
            break;
          default:
            message = 'Error al iniciar sesión: ${e.message ?? 'desconocido'}';
        }
        setState(() {
          _errorMessage = message;
        });
        print('Error de inicio de sesión: $e');
      } catch (e) {
        setState(() {
          _errorMessage = 'Ocurrió un error inesperado: ${e.toString()}';
        });
        print('Error general: $e');
      } finally {
        setState(() {
          _isLoading = false; // Ocultar indicador de carga al finalizar
        });
      }
    }
  }

  //Función para registrar un nuevo usuario
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1957884248.
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true; // Mostrar indicador de carga
        _errorMessage = ''; // Limpiar mensaje de error anterior
      });
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        // Si el registro es exitoso:
        print('Usuario registrado: ${userCredential.user!.email}');
        // Opcional: Enviar email de verificación
        // await userCredential.user!.sendEmailVerification();
        // print('Email de verificación enviado.');

        // Aquí puedes navegar a una pantalla de confirmación o directamente a HomeScreen
        // Ejemplo: Navigator.pushReplacementNamed(context, '/welcome');
        // O, si estás usando el StreamBuilder, la navegación es automática.
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'weak-password':
            message = 'La contraseña es demasiado débil.';
            break;
          case 'email-already-in-use':
            message = 'Ya existe una cuenta con este email.';
            break;
          case 'invalid-email':
            message = 'El formato del email es inválido.';
            break;
          default:
            message =
                'Error al registrar usuario: ${e.message ?? 'desconocido'}';
        }
        setState(() {
          _errorMessage = message;
        });
        print('Error de registro: $e');
      } catch (e) {
        setState(() {
          _errorMessage = 'Ocurrió un error inesperado: ${e.toString()}';
        });
        print('Error general: $e');
      } finally {
        setState(() {
          _isLoading = false; // Ocultar indicador de carga al finalizar
        });
      }
    }
  }

// Suggested code may be subject to a license. Learn more: ~LicenseLog:1237790009.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eterna - Acceso'),
        centerTitle: true, // Centra el título
      ),
      body: Center(
        child: SingleChildScrollView(
          // Permite scroll si el contenido es demasiado grande
          padding: const EdgeInsets.all(24.0), // Aumenta el padding
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Estira los campos
              children: <Widget>[
                // Título o Logo (Puedes agregar una imagen o texto más grande aquí)
                const Text(
                  'Bienvenido a Eterna',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey, // O un color de tu marca
                  ),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    // Usa InputDecoration para más opciones
                    labelText: 'Email',
                    prefixIcon:
                        const Icon(Icons.email_outlined), // Ícono de email
                    border: OutlineInputBorder(
                      // Borde redondeado
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu email';
                    }
                    // Validación de formato de email más simple
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Ingresa un email válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!.trim(); // Elimina espacios en blanco
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon:
                        const Icon(Icons.lock_outline), // Ícono de candado
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      // Botón para mostrar/ocultar contraseña (implementación extra)
                      icon: Icon(Icons.visibility), // Icono base
                      onPressed: () {
                        // TODO: Implementar lógica para mostrar/ocultar contraseña
                      },
                    ),
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
                const SizedBox(height: 30),

                // Botones con indicador de carga
                _isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator()) // Mostrar indicador si está cargando
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 15),
                          OutlinedButton(
                            // Usamos OutlinedButton para el registro
                            onPressed: _signUp,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              side: const BorderSide(
                                  color: Colors.blueGrey), // Borde
                            ),
                            child: const Text(
                              'Crear Nueva Cuenta',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.blueGrey),
                            ),
                          ),
                        ],
                      ),

                const SizedBox(height: 20),

                // Mostrar mensaje de error si existe
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 20),

                // Botón para recuperar contraseña (opcional, implementar después)
                TextButton(
                  onPressed: () {
                    // TODO: Implementar pantalla o diálogo para recuperar contraseña
                    print('Recuperar contraseña presionado');
                  },
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
