import 'package:flutter/material.dart';
import 'package:latihanresponsi/base_network.dart';
import 'package:latihanresponsi/model/list_restaurant.dart';
import 'package:latihanresponsi/restaurant_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late SharedPreferences _prefs;
  List<String> favoriteIds = [];
  late Future<List<ListRestaurant>> favoriteRestaurants;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    favoriteIds = _prefs.getStringList('favorite') ?? [];
    setState(() {
      favoriteRestaurants = _fetchFavoriteRestaurants();
    });
  }

  Future<List<ListRestaurant>> _fetchFavoriteRestaurants() async {
    final response = await BaseNetwork.getAll("list");
    final List<dynamic> restaurantsJson = response["restaurants"];

    final list =
        restaurantsJson.map((e) => ListRestaurant.fromJson(e)).toList();
    return list.where((r) => favoriteIds.contains(r.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Restaurants")),
      body: FutureBuilder<List<ListRestaurant>>(
        future: favoriteRestaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final favorites = snapshot.data!;
          if (favorites.isEmpty) {
            return const Center(child: Text("Belum ada restoran favorit"));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final restaurant = favorites[index];
              return ListTile(
                leading: Image.network(
                    "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                    width: 70,
                    fit: BoxFit.cover),
                title: Text(restaurant.name),
                subtitle: Row(
                  children: [
                    Text(restaurant.city),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Rating: ${restaurant.rating}",
                      style: TextStyle(),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RestaurantDetailPage(restaurantId: restaurant.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
