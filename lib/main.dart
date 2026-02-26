import 'package:flutter/material.dart';
import 'models/pokemon_model.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      theme: ThemeData(
        //colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PostsListScreen(),
    );
  }
}


class PostsListScreen extends StatefulWidget {
  @override
  _PostsListScreenState createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  late Future<List<Pokemon>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = ApiService().fetchPokemons(); // Llamar la API 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokemon List')),
      body: FutureBuilder<List<Pokemon>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Cargando
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos'));
          }

          // Datos cargados exitosamente
          List<Pokemon> pokemons = snapshot.data!;
          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              return Card( 
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Image.network(
                    pokemon.imageUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child; 
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                  title: Text(
                    pokemon.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Pokémon ID: ${pokemon.id}'),
                )
              );
            },
          );
        },
      ),
    );
  }
}