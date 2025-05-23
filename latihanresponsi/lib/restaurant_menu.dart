import 'package:flutter/material.dart';
import 'package:latihanresponsi/base_network.dart';
import 'package:latihanresponsi/favorit_page.dart';
import 'package:latihanresponsi/login_page.dart';
import 'package:latihanresponsi/model/list_restaurant.dart';
import 'package:latihanresponsi/restaurant_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantMenu extends StatefulWidget {
  const RestaurantMenu({super.key});

  @override
  State<RestaurantMenu> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  String username = "";
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _sharedData();
  }

  Future<void> _sharedData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("Username") ?? "";
    });
  }

  Future<List<ListRestaurant>> _getAllRestaurant() async {
    final response = await BaseNetwork.getAll("list");
    final List<dynamic> restaurantListJson = response["restaurants"];

    return restaurantListJson
        .map((json) => ListRestaurant.fromJson(json))
        .toList();
  }

  Future<void> _logoutBtn() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Anda berhasil Logout!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai, $username!"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logoutBtn,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _getAllRestaurant(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            final restaurantLists = snapshot.data!;
            return ListView.builder(
              itemCount: restaurantLists.length,
              itemBuilder: (context, i) {
                final restaurantList = restaurantLists[i];
                return Card(
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantDetailPage(
                                    restaurantId: restaurantList.id,
                                  )));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/small/${restaurantList.pictureId}",
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(restaurantList.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("Kota: ${restaurantList.city}"),
                              SizedBox(height: 4),
                              Text("Rating: ${restaurantList.rating}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
