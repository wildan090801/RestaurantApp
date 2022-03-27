import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/list_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 15, top: 55, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Restaurant',
                style: GoogleFonts.poppins(
                    fontSize: 28, fontWeight: FontWeight.w400),
              ),
              Text(
                'Recommendation restaurant for you!',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w300),
              ),
              Consumer<RestaurantProvider>(builder: (context, state, _) {
                if (state.state == ResultState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == ResultState.noData) {
                  return Center(child: Text(state.message));
                } else if (state.state == ResultState.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.result.count,
                      itemBuilder: (context, index) {
                        var resto = state.result.restaurants;
                        return buildRestoList(resto[index], context);
                      });
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
                  return const Text("");
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRestoList(RestaurantElement resto, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation.intentWithData("/detail-page", resto);
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
}
