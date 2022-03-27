import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/detail_page.dart';
import 'package:restaurant_app/utils/result_state.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Favorit Restaurants',
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.wifi_off,
                    size: 150,
                  ),
                  Text(
                    "Failed to Load Data \nPlease Check Your Internet Connection",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (provider.state == ResultState.noData) {
            return Center(
              child: noFavoriteData(),
            );
          } else if (provider.state == ResultState.hasData) {
            return ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                return FavoriteData(restaurant: provider.favorites[index]);
              },
            );
          } else {
            return const Text("");
          }
        },
      ),
    );
  }

  Widget noFavoriteData() {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  size: 80,
                  color: Colors.red[400],
                ),
                const SizedBox(
                  height: 23,
                ),
                Text(
                  'You Don\'t Have Favorite Restaurants?',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Let\'s Find Your Favorite Restaurants',
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FavoriteData extends StatelessWidget {
  final RestaurantElement restaurant;

  const FavoriteData({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                      builder: (_) => DetailPage(restaurant: restaurant)),
                )
                    .then((_) {
                  context.read<DatabaseProvider>().getFavorites();
                });
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                height: 80,
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag:
                              "https://restaurant-api.dicoding.dev/images/medium/" +
                                  restaurant.pictureId,
                          child: Image.network(
                              "https://restaurant-api.dicoding.dev/images/medium/" +
                                  restaurant.pictureId),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              restaurant.city,
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.yellow[600],
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              restaurant.rating.toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
