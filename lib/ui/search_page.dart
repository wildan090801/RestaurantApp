import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart';
import 'package:restaurant_app/provider/search_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String queries = '';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Consumer<SearchProvider>(
                builder: (context, state, _) {
                  return Container(
                    width: 360,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: const Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.blue,
                      ),
                      title: TextField(
                        controller: _controller,
                        onChanged: (String value) {
                          setState(() {
                            queries = value;
                          });
                          if (value != '') {
                            state.fetchAllRestaurantSearch(value);
                          }
                        },
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                            hintText: "Search Restaurant",
                            border: InputBorder.none),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: _searchRestaurant(context),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _searchRestaurant(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  color: Colors.grey,
                  size: 80,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 24, color: Colors.grey),
                ),
              ],
            ),
          );
        } else if (state.state == ResultState.hasData) {
          return Container(
            padding: const EdgeInsets.only(
              left: 10,
              top: 20,
            ),
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.result!.restaurants.length,
              itemBuilder: (context, index) {
                var resto = state.result!.restaurants;
                return buildRestoList(resto[index], context);
              },
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
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
            ),
          );
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }

  Widget buildRestoList(RestaurantSearch resto, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail-page', arguments: resto.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
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
                  tag: "https://restaurant-api.dicoding.dev/images/medium/" +
                      resto.pictureId,
                  child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/medium/" +
                          resto.pictureId),
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
                  resto.name,
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
                      resto.city,
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
                      resto.rating.toString(),
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
