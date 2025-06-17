import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'write_entry_screen.dart';
import 'profile_screen.dart';
import 'services/database_service.dart';
import 'recommendations.dart';

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
  
  // Método para obtener una frase poética para la sección "Ecos del Tiempo"
  String _getPastJourneyQuote() {
    final random = Random();
    final quotes = [
      "Este mensaje fue escrito por ti... un día antes de conocerte. Porque aunque no hayas usado esta app antes, algo en ti sabía que ibas a necesitar esto.",
      "Hace un año, alguien como tú también estaba atravesando algo fuerte. Esto es lo que te habría dicho: 'No tienes que poder con todo hoy, solo con este momento.'",
      "Un día mirarás atrás y entenderás por qué el caos tenía sentido. Tu yo del pasado ya lo sabía.",
      "Las emociones que sentiste hace un año siguen vivas en alguna parte de ti. ¿Te gustaría recuperarlas?",
      "Cada Pokémon guarda una memoria especial. Tus emociones pasadas también merecen ser capturadas.",
    ];
    
    return quotes[random.nextInt(quotes.length)];
  }
  
  // Método para obtener un mensaje para la sección "Pokéball del Tiempo"
  String _getTimeCapsuleMessage() {
    final random = Random();
    final messages = [
      "Todavía no has programado ninguna carta hacia el futuro... ¿Quieres dejarle un mensaje a tu yo del próximo año?",
      "Las Pokéballs del tiempo guardan tus palabras hasta que estés listo para recibirlas. ¿Qué te gustaría decirte a ti mismo en el futuro?",
      "El tiempo es como un Pokémon legendario: poderoso pero esquivo. Atrapa un momento para tu futuro yo.",
      "¿Qué consejo necesitará tu yo del futuro? Escríbelo ahora y envíalo a través del tiempo.",
      "Crea una cápsula del tiempo emocional. Tu futuro yo te lo agradecerá.",
    ];
    
    return messages[random.nextInt(messages.length)];
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
                    icon: Icon(Icons.person, color: kBackgroundColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                    tooltip: 'Mi Perfil',
                  ),
                  IconButton(
                    icon: Icon(Icons.catching_pokemon, color: kBackgroundColor),
                    onPressed: () {
                      // Navegar a configuración
                    },
                    tooltip: 'Configuración',
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
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(35),
                                                  border: Border.all(color: mood['color'], width: 2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: mood['color'].withOpacity(0.3),
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(35),
                                                  child: Image.asset(
                                                    'assets/${mood['pokemon'].toLowerCase()}.jpg',
                                                    fit: BoxFit.cover,
                                                    width: 70,
                                                    height: 70,
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
                      
                      // Botones de acción emocional basados en el estado de ánimo
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
                              
                              // Selector de tipo de entrada
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
                                    Text(
                                      '¿Qué tipo de entrada quieres crear?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          _buildEntryTypeChip('Carta', Icons.mail_outline, kAccentColor),
                                          _buildEntryTypeChip('Diario', Icons.book_outlined, kPrimaryColor),
                                          _buildEntryTypeChip('Recuerdo', Icons.photo_album_outlined, Colors.purple),
                                          _buildEntryTypeChip('Poema', Icons.music_note_outlined, Colors.teal),
                                          _buildEntryTypeChip('Idea', Icons.lightbulb_outline, Colors.amber),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Botones emocionales adaptados al estado
                              _buildEmotionalButton(
                                _selectedMood == 'Triste' || _selectedMood == 'Melancólico' ? 
                                  '¿Quieres soltar algo que duele?' : 
                                  '¿Qué sentimiento quieres atrapar?',
                                Icons.catching_pokemon,
                                kAccentColor,
                              ),
                              const SizedBox(height: 12),
                              _buildEmotionalButton(
                                _selectedMood == 'Adaptable' || _selectedMood == 'Tranquilo' ? 
                                  '¿A quién extrañas hoy?' : 
                                  '¿A qué entrenador quieres escribir?',
                                Icons.mail_outline_rounded,
                                kDarkAccentColor,
                              ),
                              const SizedBox(height: 12),
                              _buildEmotionalButton(
                                _selectedMood == 'Energético' || _selectedMood == 'Apasionado' ? 
                                  '¿Hay algo hermoso que quieras atesorar?' : 
                                  '¿Algún recuerdo para tu Pokédex?',
                                Icons.favorite_border_rounded,
                                kHighlightColor,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Escritura guiada
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    // Lista de prompts de inspiración
                                    final random = Random();
                                    final prompts = [
                                      "¿Qué momento de esta semana no quieres olvidar?",
                                      "¿Qué le dirías a alguien que no puedes ver?",
                                      "¿Qué Pokémon te gustaría ser hoy y por qué?",
                                      "¿Qué batalla emocional has ganado recientemente?",
                                      "¿Qué recuerdo guardarías en una Pokéball especial?"
                                    ];
                                    
                                    // Seleccionar un prompt aleatorio
                                    final selectedPrompt = prompts[random.nextInt(prompts.length)];
                                    
                                    // Mostrar diálogo con opciones
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'Inspiración para escribir',
                                          style: TextStyle(color: kPrimaryColor),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedPrompt,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              '¿Quieres escribir sobre esto?',
                                              style: TextStyle(color: kPrimaryColor),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Mostrar otro prompt
                                              final newPrompt = prompts[random.nextInt(prompts.length)];
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(newPrompt),
                                                  backgroundColor: kPrimaryColor,
                                                  action: SnackBarAction(
                                                    label: 'Escribir',
                                                    textColor: kHighlightColor,
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => WriteEntryScreen(
                                                            entryType: 'Reflexión',
                                                            prompt: newPrompt,
                                                            mood: _selectedMood,
                                                            pokemon: _selectedPokemon,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Otra idea',
                                              style: TextStyle(color: kAccentColor),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Navegar a la pantalla de escritura con el prompt
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => WriteEntryScreen(
                                                    entryType: 'Reflexión',
                                                    prompt: selectedPrompt,
                                                    mood: _selectedMood,
                                                    pokemon: _selectedPokemon,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kAccentColor,
                                            ),
                                            child: Text('Escribir ahora'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.lightbulb_outline, color: kHighlightColor),
                                  label: Text(
                                    '¿Necesitas inspiración?',
                                    style: TextStyle(color: kHighlightColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Carta del pasado - "Ecos del tiempo"
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
                                    'Ecos del Tiempo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kDarkAccentColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Contenido poético para usuarios nuevos
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
                                      _getPastJourneyQuote(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: kPrimaryColor,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '— Tu yo del pasado',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: kDarkAccentColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              Center(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // Crear un recuerdo retroactivo
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WriteEntryScreen(
                                          entryType: 'Recuerdo Retroactivo',
                                          prompt: '¿Qué te gustaría haber escrito hace un año?',
                                          mood: _selectedMood,
                                          pokemon: _selectedPokemon,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit_outlined),
                                  label: const Text('Crear recuerdo retroactivo'),
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
                      
                      // Carta programada - "Pokéball del tiempo"
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
                                    'Pokéball del Tiempo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kAccentColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Mensaje para usuarios sin cartas programadas
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kAccentColor.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getTimeCapsuleMessage(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: kPrimaryColor,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 16,
                                          color: kAccentColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Viaje al futuro',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: kAccentColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Crear una carta programada para el futuro
                                    final futureDate = DateTime.now().add(const Duration(days: 365));
                                    final formattedDate = DateFormat('dd/MM/yyyy').format(futureDate);
                                    
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WriteEntryScreen(
                                          entryType: 'Carta al Futuro',
                                          prompt: '¿Qué te gustaría decirle a tu yo del $formattedDate?',
                                          mood: _selectedMood,
                                          pokemon: _selectedPokemon,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.send),
                                  label: const Text('Enviar al futuro'),
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
                              
                              // Recomendación de libro
                              _buildDailyRecommendation(
                                'Libro',
                                getRandomRecommendation(books),
                                Icons.book_outlined,
                              ),
                              const Divider(),
                              
                              // Recomendación de canción
                              _buildDailyRecommendation(
                                'Canción',
                                getRandomRecommendation(songs),
                                Icons.music_note_outlined,
                              ),
                              const Divider(),
                              
                              // Recomendación de película
                              _buildDailyRecommendation(
                                'Película',
                                getRandomRecommendation(movies),
                                Icons.movie_outlined,
                              ),
                              
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  'Recomendaciones actualizadas diariamente',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kPrimaryColor.withOpacity(0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
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
          // Navegar a la pantalla de escritura con una entrada rápida
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteEntryScreen(
                entryType: 'Nota rápida',
                prompt: '',
                mood: _selectedMood,
                pokemon: _selectedPokemon,
              ),
            ),
          );
        },
        backgroundColor: kAccentColor,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildEmotionalButton(String text, IconData icon, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Determinar el tipo de entrada basado en el icono
          String entryType;
          if (icon == Icons.catching_pokemon) {
            entryType = 'Sentimiento';
          } else if (icon == Icons.mail_outline_rounded) {
            entryType = 'Carta';
          } else if (icon == Icons.favorite_border_rounded) {
            entryType = 'Recuerdo';
          } else {
            entryType = 'Nota';
          }
          
          // Navegar a la pantalla de escritura con el prompt como guía
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteEntryScreen(
                entryType: entryType,
                prompt: text,
                mood: _selectedMood,
                pokemon: _selectedPokemon,
              ),
            ),
          );
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

  Widget _buildDailyRecommendation(
      String type, Recommendation recommendation, IconData icon) {
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
                Row(
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (recommendation.link.isNotEmpty)
                      InkWell(
                        onTap: () {
                          // Aquí se podría abrir el enlace
                        },
                        child: Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: kAccentColor,
                        ),
                      ),
                  ],
                ),
                Text(
                  recommendation.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  recommendation.creator,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (recommendation.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      recommendation.description,
                      style: TextStyle(
                        color: kPrimaryColor.withOpacity(0.8),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEntryTypeChip(String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, color: color, size: 18),
        label: Text(label),
        labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
        backgroundColor: color.withOpacity(0.1),
        side: BorderSide(color: color.withOpacity(0.5)),
        onPressed: () {
          // Navegar a la pantalla de escritura con el tipo seleccionado
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteEntryScreen(
                entryType: label,
                prompt: '',
                mood: _selectedMood,
                pokemon: _selectedPokemon,
              ),
            ),
          );
        },
      ),
    );
  }
}