import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:intl/intl.dart';

// Definición de la paleta de colores como constantes
const Color kBackgroundColor = Color(0xfff0eff4);
const Color kPrimaryColor = Color(0xff004e64);
const Color kAccentColor = Color(0xffed6a5a);
const Color kHighlightColor = Color(0xffffdd4a);
const Color kDarkAccentColor = Color(0xff6b0f1a);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _greeting = '';
  String _inspirationalPhrase = '';
  String _selectedMood = '';
  String _selectedPokemon = '';
  bool _showMoodSelector = false;

  // Lista de frases inspiradoras con temática Pokémon
  final List<String> _phrases = [
    "Hoy es un buen día para capturar nuevos recuerdos",
    "¿Qué sentimiento quieres preservar en tu Pokédex emocional?",
    "Escribe hoy lo que quieras recordar en tu viaje",
    "Cada emoción merece ser guardada, como un Pokémon especial",
    "Tus palabras son tan poderosas como un movimiento tipo Psíquico"
  ];

  // Lista de estados de ánimo con Pokémon
  final List<Map<String, dynamic>> _moods = [
    {'pokemon': 'Pikachu', 'name': 'Energético', 'color': Colors.amber},
    {'pokemon': 'Squirtle', 'name': 'Tranquilo', 'color': Colors.blue},
    {'pokemon': 'Charmander', 'name': 'Apasionado', 'color': kAccentColor},
    {'pokemon': 'Bulbasaur', 'name': 'Equilibrado', 'color': Colors.green},
    {'pokemon': 'Snorlax', 'name': 'Relajado', 'color': Colors.blueGrey},
    {'pokemon': 'Eevee', 'name': 'Adaptable', 'color': Colors.brown},
  ];

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _setRandomPhrase();
    
    // Configurar animación de entrada
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = '¡Buenos días, entrenador!';
    } else if (hour < 18) {
      _greeting = '¡Buenas tardes, entrenador!';
    } else {
      _greeting = '¡Buenas noches, entrenador!';
    }
    
    // Añadir el nombre del usuario si está disponible
    final user = _auth.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      _greeting = _greeting.replaceAll('entrenador', user.displayName!);
    }
  }

  void _setRandomPhrase() {
    final random = Random();
    _inspirationalPhrase = _phrases[random.nextInt(_phrases.length)];
  }

  void _toggleMoodSelector() {
    setState(() {
      _showMoodSelector = !_showMoodSelector;
    });
  }

  void _selectMood(String mood, String pokemon) {
    setState(() {
      _selectedMood = mood;
      _selectedPokemon = pokemon;
      _showMoodSelector = false;
    });
    // Aquí se podría guardar el estado de ánimo en Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // Barra de aplicación con animación
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: kPrimaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Arbook',
                    style: TextStyle(
                      color: kBackgroundColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Fondo decorativo con temática Pokémon
                      Image.asset(
                        'assets/logo.png', // Usar el logo como fondo
                        fit: BoxFit.cover,
                      ),
                      // Overlay para mejorar legibilidad
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              kPrimaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.catching_pokemon, color: kBackgroundColor),
                    onPressed: () {
                      // Navegar a configuración
                    },
                  ),
                ],
              ),
              
              // Contenido principal
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Saludo y frase del día
                      Text(
                        _greeting,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _inspirationalPhrase,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: kDarkAccentColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Mood Tracker con Pokémon
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
                              Text(
                                '¿Qué Pokémon refleja tu estado de ánimo?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _showMoodSelector
                                  ? Wrap(
                                      spacing: 12,
                                      runSpacing: 16,
                                      children: _moods.map((mood) {
                                        return InkWell(
                                          onTap: () => _selectMood(mood['name'], mood['pokemon']),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 70,
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: mood['color'].withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(35),
                                                  border: Border.all(color: mood['color'], width: 2),
                                                ),
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(35),
                                                    child: Image.asset(
                                                      'assets/${mood['pokemon'].toLowerCase()}.jpg',
                                                      fit: BoxFit.cover,
                                                      width: 60,
                                                      height: 60,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                mood['name'],
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : OutlinedButton.icon(
                                      onPressed: _toggleMoodSelector,
                                      icon: const Icon(Icons.catching_pokemon),
                                      label: Text(_selectedMood.isEmpty
                                          ? 'Selecciona tu Pokémon de hoy'
                                          : 'Te sientes $_selectedMood como $_selectedPokemon'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: kPrimaryColor,
                                        side: BorderSide(color: kPrimaryColor),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botones de acción emocional
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: kPrimaryColor.withOpacity(0.05),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿Qué quieres capturar hoy?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildEmotionalButton(
                                '¿Qué sentimiento quieres atrapar?',
                                Icons.catching_pokemon,
                                kAccentColor,
                              ),
                              const SizedBox(height: 12),
                              _buildEmotionalButton(
                                '¿A qué entrenador quieres escribir?',
                                Icons.mail_outline_rounded,
                                kDarkAccentColor,
                              ),
                              const SizedBox(height: 12),
                              _buildEmotionalButton(
                                '¿Algún recuerdo para tu Pokédex?',
                                Icons.favorite_border_rounded,
                                kHighlightColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Carta del pasado
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
                                    Icons.auto_stories,
                                    color: kDarkAccentColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'De tu viaje anterior',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kDarkAccentColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Un recuerdo de tu aventura hace un año...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // Abrir carta del pasado
                                  },
                                  icon: const Icon(Icons.visibility_outlined),
                                  label: const Text('Ver recuerdo'),
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
                      
                      // Carta programada
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: kAccentColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.catching_pokemon,
                                    color: kAccentColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Pokéball del tiempo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kAccentColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tienes un mensaje esperándote desde el pasado',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Abrir carta programada
                                  },
                                  icon: const Icon(Icons.lock_open_rounded),
                                  label: const Text('Abrir Pokéball'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kAccentColor,
                                    foregroundColor: Colors.white,
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
                      
                      // Recomendaciones artísticas
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: kPrimaryColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Para inspirar tu aventura',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildRecommendationItem(
                                'Libro',
                                'Pokémon: La historia oficial',
                                'The Pokémon Company',
                                Icons.book_outlined,
                              ),
                              const Divider(),
                              _buildRecommendationItem(
                                'Canción',
                                'Tema de Pokémon',
                                'Jason Paige',
                                Icons.music_note_outlined,
                              ),
                              const Divider(),
                              _buildRecommendationItem(
                                'Película',
                                'Pokémon: Detective Pikachu',
                                'Rob Letterman',
                                Icons.movie_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botón de abrazo
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Mostrar animación de abrazo
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('¡Pikachu te envía un abrazo eléctrico!'),
                                backgroundColor: kDarkAccentColor,
                              ),
                            );
                          },
                          icon: const Icon(Icons.electric_bolt),
                          label: const Text('Necesito un abrazo de Pikachu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkAccentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de nueva entrada
        },
        backgroundColor: kAccentColor,
        child: const Icon(Icons.catching_pokemon, color: Colors.white),
      ),
    );
  }

  Widget _buildEmotionalButton(String text, IconData icon, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navegar a la pantalla de nueva entrada con el tipo seleccionado
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
      String type, String title, String author, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kPrimaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  author,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}