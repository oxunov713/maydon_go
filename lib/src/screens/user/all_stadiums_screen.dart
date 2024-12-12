import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydon_go/src/screens/user/stadium_detail.dart';

import '../../data/fake_data.dart';
import '../../model/stadium_model.dart';
import '../../style/app_colors.dart';
import '../../style/app_icons.dart';

class AllStadiumsScreen extends StatefulWidget {
  AllStadiumsScreen({super.key});

  @override
  State<AllStadiumsScreen> createState() => _AllStadiumsScreenState();
}

class _AllStadiumsScreenState extends State<AllStadiumsScreen> {
  List<Stadium> stadiums = []; // List to hold stadium data
  List<int> _currentIndexList = []; // Track the current index for each stadium
  late List<CarouselSliderController> _carouselControllers;
  List<Stadium> filteredStadiums = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    stadiums = fetchStadiums();
    filteredStadiums = stadiums;
    _carouselControllers = List.generate(
      stadiums.length,
      (index) => CarouselSliderController(),
    );
    _currentIndexList = List.generate(stadiums.length, (index) => 0);
  }

  void _filterStadiums(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStadiums = stadiums;
      } else {
        final matches = stadiums
            .where((stadium) =>
                stadium.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        final others = stadiums
            .where((stadium) =>
                !stadium.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredStadiums = [...matches, ...others];
      }
    });
  }

  void _toggleSearchMode() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        filteredStadiums = stadiums;
      }
    });
  }

  void _navigateToDetailScreen(Stadium stadium) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StadiumDetailScreen(stadium: stadium),
      ),
    );
  }

  List<Stadium> fetchStadiums() {
    return FakeData.stadiumOwners
        .map(
          (e) => e.stadium,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        automaticallyImplyLeading: isSearching ? false : true,
        title: isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Maydon nomi',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.black),
                        onChanged: _filterStadiums,
                      ),
                    ),
                  ],
                ),
              )
            : const Text("Barcha maydonlar"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: isSearching
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  )
                : InkWell(
                    child: SvgPicture.asset(
                      'assets/icons/search_icon.svg', // Replace with your search icon
                      height: 23,
                    ),
                    onTap: _toggleSearchMode,
                  ),
          ),
        ],
      ),
      body: filteredStadiums.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredStadiums.length,
              itemBuilder: (context, stadiumIndex) {
                final stadium = filteredStadiums[stadiumIndex];
                return GestureDetector(
                  onTap: () => _navigateToDetailScreen(stadium),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: AppColors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                stadium.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 25),
                              ),
                              Card(
                                color: AppColors.green2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "4.5",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.white),
                                      ),
                                      SizedBox(width: 5),
                                      Image.asset(
                                        AppIcons.stars,
                                        height: 15,
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              children: [
                                // CarouselSlider for images
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CarouselSlider(
                                    items: stadium.images.map((imageUrl) {
                                      return Image.asset(
                                        imageUrl,
                                        fit: BoxFit
                                            .cover, // Ensure the image fills the card area
                                      );
                                    }).toList(),
                                    options: CarouselOptions(
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 1.0,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.3,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndexList[stadiumIndex] =
                                              index;
                                        });
                                      },
                                    ),
                                    carouselController:
                                        _carouselControllers[stadiumIndex],
                                  ),
                                ),

                                // Dotted Indicator
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      stadium.images.length,
                                      (index) => AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        width:
                                            _currentIndexList[stadiumIndex] ==
                                                    index
                                                ? 12
                                                : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color:
                                              _currentIndexList[stadiumIndex] ==
                                                      index
                                                  ? AppColors.green2
                                                  : AppColors.grey4,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${stadium.price.floor()} 000 so'm",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.bookmark_border,
                                  color: AppColors.green,
                                  size: 30,
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Bugungi bo'sh vaqtlar",
                            style:
                                TextStyle(fontSize: 14, color: AppColors.grey4),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            height: 45,
                            child: ListView.separated(
                              itemCount: 24,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => SizedBox(
                                width: 10,
                              ),
                              itemBuilder: (context, index) => Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: AppColors.green40,
                                ),
                                child: Center(
                                  child: Text(
                                    "${index}:00 - ${index + 1}:00",
                                    style: TextStyle(
                                        color: AppColors.green,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(height: 25),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 10),
                              SizedBox(
                                width: deviceWidth - 150,
                                child: Text(
                                  stadium.location.address,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.main,
                                      overflow: TextOverflow.visible),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
