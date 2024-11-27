import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantListView extends StatefulWidget {
  final int regionId;
  final String regionName; // Region name added for the app bar title.

  const RestaurantListView({
    super.key,
    required this.regionId,
    required this.regionName,
  });

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  List<dynamic> restaurants = []; // List to hold restaurants for the region.

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  // Function to fetch restaurants based on region_id
  Future<void> fetchRestaurants() async {
    try {
      final response = await Supabase.instance.client
          .from('restaurants') // Table name: restaurant
          .select('id, name, region_id, photo_couverture')
          .eq('region_id', widget.regionId);
      print(response); // Filter by region_id

      if (response != null) {
        setState(() {
          restaurants = response as List<dynamic>;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants in ${widget.regionName}"), // Region name
      ),
      body: restaurants.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display restaurant's image as a large banner
                    Image.network(
                      restaurant['photo_couverture'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant Name
                          Text(
                            restaurant['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 4-Star Rating
                          Row(
                            children: List.generate(
                              4,
                              (starIndex) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                            )..add(
                                const Icon(
                                  Icons.star_outline,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ),
                          ),
                          const SizedBox(height: 8),
                          // Region ID (optional display)
                          Text(
                            "Region ID: ${restaurant['region_id']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, height: 30),
                  ],
                );
              },
            ),
    );
  }
}
