import 'package:flutter/material.dart';
import 'package:project/common/color_extension.dart';
import 'package:project/common/globs.dart';
import 'package:project/common/service_call.dart';
import 'package:project/common_widget/category_cell.dart';
import 'package:project/common_widget/popular_restaurant_row.dart';
import 'package:project/common_widget/round_textfield.dart';
import 'package:project/common_widget/view_all_title_row.dart';
import 'package:project/view/more/my_order_view.dart';
import 'package:project/view/regions/restaurant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart'; // Import the correct package for PostgrestResponse

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();

  List catArr = [
    {"image": "assets/img/cat_offer.png", "name": "Offers"},
    {"image": "assets/img/cat_sri.png", "name": "Sri Lankan"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cat_4.png", "name": "Indian"},
  ];
  List<dynamic> popArr = []; // Dynamic list for popular restaurants.

  @override
  void initState() {
    super.initState();
    fetchRegions(); // Fetch regions from Supabase on initialization.
  }

  // Function to fetch regions from Supabase
  Future<void> fetchRegions() async {
    try {
      final response = await Supabase.instance.client
          .from('region') // Replace 'region' with your table name
          .select('id, name, photo_couverture');
      // print("the response $response");
      if (response != null) {
        setState(() {
          popArr = response as List<dynamic>;
        });
        // print("Error fetching regions: ${response.message}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Good morning ${ServiceCall.userPayload[KKey.name] ?? ""}!",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
                      },
                      icon: Image.asset(
                        "assets/img/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivering to",
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 11),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Current Location",
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Image.asset(
                          "assets/img/dropdown.png",
                          width: 12,
                          height: 12,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: "Search Food",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/img/search.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: catArr.length,
                  itemBuilder: ((context, index) {
                    var cObj = catArr[index] as Map? ?? {};
                    return CategoryCell(
                      cObj: cObj,
                      onTap: () {},
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Popular Restaurants",
                  onView: () {},
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: popArr.length,
                itemBuilder: (context, index) {
                  final pObj = popArr[index];
                  return PopularRestaurantRow(
                    pObj: {
                      "image": pObj['photo_couverture'], // Image from Supabase
                      "name": pObj['name'], // Name from Supabase
                      "rate":
                          "4.9", // Dummy data (or replace with real ratings)
                      "rating":
                          "124", // Dummy data (or replace with real ratings)
                      "type":
                          "Region", // Dummy type (or replace with relevant type)
                      "food_type": "Western Food", // Dummy food type
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantListView(
                            regionId: pObj['id'],
                            regionName: pObj['name'], // Pass the region ID
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

