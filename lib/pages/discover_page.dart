import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/widgets/continue_planningcard.dart';
import '/widgets/destination_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final List<Map<String, String>> ongoingTrips = [
    {
      "title": "Bali Getaway",
      "image":
          "https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=800&q=80"
    },
  ];

  final List<Map<String, String>> popularDestinations = [
    {
      "name": "Paris, France",
      "image":
          "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=800&q=80",
      "tagline": "City of Light and Romance"
    },
    {
      "name": "New York, USA",
      "image":
          "https://images.unsplash.com/photo-1533106418989-88406c7cc8ca?auto=format&fit=crop&w=800&q=80",
      "tagline": "The City That Never Sleeps"
    },
    {
      "name": "Santorini, Greece",
      "image":
          "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
      "tagline": "White-washed paradise by the sea"
    },
  ];

  final List<Map<String, String>> recommendedDestinations = [
    {
      "name": "Tokyo, Japan",
      "description": "Vibrant city life meets traditional temples.",
      "image":
          "https://images.unsplash.com/photo-1554797589-7241bb691973?auto=format&fit=crop&w=800&q=80"
    },
    {
      "name": "Bali, Indonesia",
      "description": "Tropical beaches and cultural temples.",
      "image":
          "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Discover Destinations"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search destinations...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Continue Planning
              if (ongoingTrips.isNotEmpty) ...[
                const Text("Continue Planning",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ongoingTrips.length,
                    itemBuilder: (context, index) {
                      final trip = ongoingTrips[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ContinuePlanningCard(
                          title: trip["title"]!,
                          imageUrl: trip["image"]!,
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Recommended for You (moved up)
              const Text("Recommended for You",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recommendedDestinations.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final dest = recommendedDestinations[index];
                  return DestinationCard(
                    name: dest["name"]!,
                    description: dest["description"]!,
                    imageUrl: dest["image"]!,
                    onTap: () {},
                  );
                },
              ),

              const SizedBox(height: 20),

              // Popular Destinations Carousel (moved down)
              const Text("Popular Destinations",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.85,
                ),
                items: popularDestinations.map((dest) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(dest["image"]!, fit: BoxFit.cover),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 12,
                                right: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dest["name"]!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text(dest["tagline"]!,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Discover"),
          BottomNavigationBarItem(icon: Icon(Icons.luggage), label: "My Trips"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
