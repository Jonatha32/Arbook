import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Define the color palette as const
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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        // Registration successful
        print('Usuario registrado: ${userCredential.user!.email}');
        // You can navigate to a confirmation screen or directly to the home screen
        // For now, let's navigate back to the login screen
        Navigator.pop(context);
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
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eterna - Registro',
          style: TextStyle(color: Color(0xfff0eff4)), // Use f0eff4 for text
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff004e64), // Use 004e64 for AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Container(
              // Add a Container for background color
              color: const Color(0xfff0eff4), // Use f0eff4 for background
              padding: const EdgeInsets.all(16.0), // Add some padding to the container
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Crear Nueva Cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff6b0f1a), // Use 6b0f1a for title
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nombre de Usuario',
                      prefixIcon: const Icon(Icons.person_outline, color: Color(0xff004e64)), // Use 004e64 for icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Color(0xff004e64)), // Use 004e64 for border
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Add focused border style
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Color(0xffffdd4a), width: 2.0), // Use ffdd4a for focused border
                      ),
                      labelStyle:
                          const TextStyle(color: Color(0xff004e64)), // Use 004e64 for label text
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa un nombre de usuario';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!.trim();
                    },
                  ),
                  const SizedBox(height: 20), // Adjust spacing
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xff004e64)), // Use 004e64 for icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Color(0xff004e64)), // Use 004e64 for border
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Add focused border style
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Color(0xffffdd4a), width: 2.0), // Use ffdd4a for focused border
                      ),
                      labelStyle:
                          const TextStyle(color: Color(0xff004e64)), // Use 004e64 for label text
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
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff004e64)), // Use 004e64 for icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Color(0xff004e64)), // Use 004e64 for border
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Add focused border style
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Color(0xffffdd4a), width: 2.0), // Use ffdd4a for focused border
                      ),
                      labelStyle:
                          const TextStyle(color: Color(0xff004e64)), // Use 004e64 for label text
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
                  const SizedBox(height: 20), // Adjust spacing
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Repetir Contraseña',
                      prefixIcon: const Icon(Icons.lock_reset, color: Color(0xff004e64)), // Use 004e64 for icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Color(0xff004e64)), // Use 004e64 for border
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Add focused border style
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Color(0xffffdd4a), width: 2.0), // Use ffdd4a for focused border
                      ),
                      labelStyle:
                          const TextStyle(color: Color(0xff004e64)), // Use 004e64 for label text
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, repite tu contraseña';
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
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xffffdd4a)), // Use ffdd4a for indicator
                        ))
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor:
                                const Color(0xffed6a5a), // Use ed6a5a for button background
                            foregroundColor:
                                const Color(0xfff0eff4), // Use f0eff4 for button text
                          ),
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                  const SizedBox(height: 20),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style:
                          const TextStyle(color: Color(0xffed6a5a), fontSize: 14), // Use ed6a5a for error text
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the login screen
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xff004e64), // Use 004e64 for text button
                    ),
                    child: const Text('¿Ya tienes cuenta? Inicia Sesión'),
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
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
                const SizedBox(height: 40),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.verified_user),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
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
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                const SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the login screen
                  },
                  child: const Text('¿Ya tienes cuenta? Inicia Sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
