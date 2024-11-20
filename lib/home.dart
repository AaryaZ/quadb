import 'dart:async';
import 'package:cinesearch/details.dart';
import 'package:cinesearch/search.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Top posters
  int post_idx = 0;
  final posters = [
    Image.asset('assets/images/image1.jpg', fit: BoxFit.contain, key: Key('1')),
    Image.asset('assets/images/image2.jpg', fit: BoxFit.contain, key: Key('2')),
    Image.asset('assets/images/image3.jpg', fit: BoxFit.contain, key: Key('3')),
    Image.asset('assets/images/image4.jpg', fit: BoxFit.contain, key: Key('4')),
    Image.asset('assets/images/image5.jpg', fit: BoxFit.contain, key: Key('5')),
  ];

  late Timer _timer;

  //fecth the movies from TV Maze APi
  bool isLoading = true;
  List<dynamic> movies = [];

  Future<void> fetchMovies() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
      if (response.statusCode == 200) {
        setState(() {
          movies = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  //bottom loading
  bool reachedBottom =
      false; // Flag to control the visibility of the loading indicator
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //for poster
    _timer = Timer.periodic(Duration(seconds: 8), (timer) {
      setState(() {
        post_idx = (post_idx + 1) % posters.length;
      });
    });

    fetchMovies();

    // Listen to the scroll position
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!reachedBottom) {
          setState(() {
            reachedBottom = true;
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              reachedBottom = false;
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(86, 0, 0, 0),
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFFCC5500),
                        offset: Offset(2, 2),
                        blurRadius: 5,
                        spreadRadius: 0.8),
                    BoxShadow(
                      color: Colors.grey.shade700,
                      offset: Offset(-1, -1),
                      blurRadius: 2,
                    ),
                  ]),
              child: Icon(
                Icons.movie_rounded,
                color: Color(0xFFCC5500),
                // color: Colors.grey[500],
                // Color myColor = Color(0xFFCC5500);
              ),
            ),
          ),
          title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(shouldFocus: true),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: screenWidth * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade800,
                              offset: Offset(-1, -1),
                              blurRadius: 3,
                              spreadRadius: 0.8)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Search..",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.search,
                            color: Color(0xFFCC5500),
                          ),
                        ),
                      ],
                    ),
                  ))),
        ),
      ),
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 2000),
                    reverseDuration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => SizeTransition(
                        child: Center(child: SizedBox(child: child)),
                        sizeFactor: animation),
                    child: posters[post_idx],
                  ),
                ),
//First Row-----------------------------------------------------------------------
                SizedBox(height: 20),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Everyone is watching",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('🍿', style: TextStyle(fontSize: 18)),
                          // Text(fireEmoji!.character, style: TextStyle(fontSize: 50)),
                        ],
                      ),
                      Text(
                        "See All",
                        style: TextStyle(
                          color: Color(0xFFCC5500),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFCC5500)),
                        ),
                      )
                    : _movieRow(movies.isEmpty ? [] : movies.sublist(0, 10)),

//Second Row-----------------------------------------------------------------------
                SizedBox(height: 20),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "New and Hot",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('🔥', style: TextStyle(fontSize: 18)),
                          // Text(fireEmoji!.character, style: TextStyle(fontSize: 50)),
                        ],
                      ),
                      Text(
                        "See All",
                        style: TextStyle(
                          color: Color(0xFFCC5500),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFCC5500)),
                        ),
                      )
                    : _movieRow(
                        movies.isEmpty ? [] : movies.sublist(5, movies.length)),

//Third Row-----------------------------------------------------------------------
                SizedBox(height: 20),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Recommended for You ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('🧡', style: TextStyle(fontSize: 18)),
                          // Text(fireEmoji!.character, style: TextStyle(fontSize: 50)),
                        ],
                      ),
                      Text(
                        "See All",
                        style: TextStyle(
                          color: Color(0xFFCC5500),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFCC5500)),
                        ),
                      )
                    : _movieRow(
                        movies.isEmpty
                            ? []
                            : movies
                                .sublist(0, movies.length)
                                .reversed
                                .toList(),
                      ),
//Fourth Row-----------------------------------------------------------------------
                const SizedBox(height: 20),

                if (reachedBottom)
                  const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFCC5500)),
                      ),
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}

//movie rows
Widget _movieRow(List<dynamic> movies) {
  return SizedBox(
    height: 200,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index]['show'];
        return Padding(
          padding: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == movies.length - 1 ? 16 : 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(movie: movie),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: movie['image'] != null
                      ? Image.network(movie['image']['medium'],
                          fit: BoxFit.cover, height: 150, width: 100)
                      : Container(
                          color: Colors.grey[800], height: 150, width: 100),
                ),
                SizedBox(height: 8),
                Text(
                  movie['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
