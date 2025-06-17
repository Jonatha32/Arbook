// Lista de recomendaciones para la aplicación

class Recommendation {
  final String title;
  final String creator;
  final String description;
  final String imageUrl;
  final String link;

  Recommendation({
    required this.title,
    required this.creator,
    this.description = '',
    this.imageUrl = '',
    this.link = '',
  });
}

// Recomendaciones de libros
final List<Recommendation> books = [
  Recommendation(
    title: 'El Principito',
    creator: 'Antoine de Saint-Exupéry',
    description: 'Una fábula sobre la importancia de la conexión humana y la imaginación.',
    imageUrl: 'https://m.media-amazon.com/images/I/71OZY035QKL._AC_UF1000,1000_QL80_.jpg',
  ),
  Recommendation(
    title: 'Cien años de soledad',
    creator: 'Gabriel García Márquez',
    description: 'La historia épica de la familia Buendía a lo largo de siete generaciones.',
    imageUrl: 'https://images.penguinrandomhouse.com/cover/9780307474728',
  ),
  Recommendation(
    title: 'El amor en los tiempos del cólera',
    creator: 'Gabriel García Márquez',
    description: 'Una historia de amor que trasciende el tiempo y las circunstancias.',
    imageUrl: 'https://images.penguinrandomhouse.com/cover/9780307389732',
  ),
  Recommendation(
    title: 'Matar a un ruiseñor',
    creator: 'Harper Lee',
    description: 'Una poderosa historia sobre la injusticia racial y la pérdida de la inocencia.',
    imageUrl: 'https://images.penguinrandomhouse.com/cover/9780060935467',
  ),
  Recommendation(
    title: 'Orgullo y prejuicio',
    creator: 'Jane Austen',
    description: 'Una novela de amor y malentendidos en la Inglaterra del siglo XIX.',
    imageUrl: 'https://m.media-amazon.com/images/I/71Q1tPupKjL._AC_UF1000,1000_QL80_.jpg',
  ),
];

// Recomendaciones de películas
final List<Recommendation> movies = [
  Recommendation(
    title: 'El Fabuloso Destino de Amélie Poulain',
    creator: 'Jean-Pierre Jeunet',
    description: 'Una joven camarera decide cambiar la vida de quienes la rodean para mejor.',
    imageUrl: 'https://m.media-amazon.com/images/M/MV5BNDg4NjM1YjMtYmNhZC00MjM0LWFiZmYtNGY1YjA3MzZmODc5XkEyXkFqcGdeQXVyNDk3NzU2MTQ@._V1_.jpg',
  ),
  Recommendation(
    title: 'Eterno resplandor de una mente sin recuerdos',
    creator: 'Michel Gondry',
    description: 'Una pareja se somete a un procedimiento para borrar los recuerdos el uno del otro.',
    imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTY4NzcwODg3Nl5BMl5BanBnXkFtZTcwNTEwOTMyMw@@._V1_.jpg',
  ),
  Recommendation(
    title: 'La vida es bella',
    creator: 'Roberto Benigni',
    description: 'Un padre usa su imaginación para proteger a su hijo de los horrores de la guerra.',
    imageUrl: 'https://m.media-amazon.com/images/M/MV5BYmJmM2Q4NmMtYThmNC00ZjRlLWEyZmItZTIwOTBlZDQ3NTQ1XkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_.jpg',
  ),
  Recommendation(
    title: 'Interestelar',
    creator: 'Christopher Nolan',
    description: 'Un grupo de astronautas viaja a través de un agujero de gusano en busca de un nuevo hogar para la humanidad.',
    imageUrl: 'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg',
  ),
  Recommendation(
    title: 'Your Name',
    creator: 'Makoto Shinkai',
    description: 'Dos extraños descubren que están conectados de una manera extraña y mágica.',
    imageUrl: 'https://m.media-amazon.com/images/M/MV5BODRmZDVmNzUtZDA4ZC00NjhkLWI2M2UtN2M0ZDIzNDcxYThjL2ltYWdlXkEyXkFqcGdeQXVyNTk0MzMzODA@._V1_.jpg',
  ),
];

// Recomendaciones de canciones
final List<Recommendation> songs = [
  Recommendation(
    title: 'Fix You',
    creator: 'Coldplay',
    description: 'Una canción sobre ayudar a alguien a superar el dolor y la pérdida.',
    imageUrl: 'https://i.scdn.co/image/ab67616d0000b273de09e02aa7febf30b7c02d82',
    link: 'https://open.spotify.com/track/7LVHVU3tWfcxj5aiPFEW4Q',
  ),
  Recommendation(
    title: 'Bohemian Rhapsody',
    creator: 'Queen',
    description: 'Una obra maestra que combina rock, ópera y balada.',
    imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c2f1eeafd52d8e4a9d8ae873',
    link: 'https://open.spotify.com/track/7tFiyTwD0nx5a1eklYtX2J',
  ),
  Recommendation(
    title: 'Imagine',
    creator: 'John Lennon',
    description: 'Una canción que invita a imaginar un mundo de paz y unidad.',
    imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d25bab9d5d03c5f85b7b2dee',
    link: 'https://open.spotify.com/track/7pKfPomDEeI4TPT6EOYjn9',
  ),
  Recommendation(
    title: 'Hallelujah',
    creator: 'Leonard Cohen',
    description: 'Una profunda exploración de la emoción humana y la espiritualidad.',
    imageUrl: 'https://i.scdn.co/image/ab67616d0000b273ce8296e75c8cf0c8a450d7a0',
    link: 'https://open.spotify.com/track/5VVFCPOazRBTnEU9B8J8AJ',
  ),
  Recommendation(
    title: 'Clocks',
    creator: 'Coldplay',
    description: 'Una canción sobre el paso del tiempo y la confusión existencial.',
    imageUrl: 'https://i.scdn.co/image/ab67616d0000b273de09e02aa7febf30b7c02d82',
    link: 'https://open.spotify.com/track/0BCPKOYdS7jK2IvTV5K6pj',
  ),
];

// Obtener una recomendación aleatoria basada en la fecha
Recommendation getRandomRecommendation(List<Recommendation> list) {
  // Usar la fecha actual como semilla para que cambie cada día
  final seed = DateTime.now().day + DateTime.now().month * 31;
  final index = seed % list.length;
  return list[index];
}