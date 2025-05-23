import 'package:flutter/material.dart';
import 'package:latihanresponsi/model/detail_restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latihanresponsi/base_network.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Future<DetailRestaurant> _detailFuture;
  late SharedPreferences _prefs;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _detailFuture = _fetchDetail();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    _prefs = await SharedPreferences.getInstance();
    final favoriteList = _prefs.getStringList('favorite') ?? [];
    setState(() {
      _isFavorite = favoriteList.contains(widget.restaurantId);
    });
  }

  Future<void> _toggleFavorite() async {
    final favoriteList = _prefs.getStringList('favorite') ?? [];

    setState(() {
      if (_isFavorite) {
        favoriteList.remove(widget.restaurantId);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil menghapus dari favorit'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        favoriteList.add(widget.restaurantId);
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil menambahkan ke favorit'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    });

    await _prefs.setStringList('favorite', favoriteList);
  }

  Future<DetailRestaurant> _fetchDetail() async {
    final json = await BaseNetwork.getDetail(widget.restaurantId);
    return DetailRestaurant.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Restaurant"),
      ),
      body: FutureBuilder<DetailRestaurant>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final detail = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  "https://restaurant-api.dicoding.dev/images/small/${detail.pictureId}",
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(detail.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
                Text("Rating: ${detail.rating}"),
                const SizedBox(height: 8),
                Text("Alamat: ${detail.address}, ${detail.city}"),
                const SizedBox(height: 16),
                Text(
                  detail.description,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
