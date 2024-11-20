import 'package:cinesearch/details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  final bool shouldFocus;

  const Search({Key? key, this.shouldFocus = false}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Focus the TextField if shouldFocus is true
    if (widget.shouldFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> searched = [];
  Future<void> search(String query) async {
    if (query.isEmpty) {
      setState(() {
        searched = [];
      });
      return;
    }

    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searched = jsonDecode(response.body);
        // print(searched);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Container(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    search(value);
                  },
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    hintText: 'Search..',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.search,
                      color: Color(0xFFCC5500),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFCC5500), width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              )),
        ),
      ),
      body: searched.isEmpty
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Watch what you love",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Search for movies, shows, webseries and \n more.",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ))
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(8.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 0.6,
                    children: List.generate(
                      searched.length,
                      (index) {
                        final movie = searched[index]['show'];
                        return Center(
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
                                  borderRadius: BorderRadius.circular(7.0),
                                  child: movie['image'] != null
                                      ? Image.network(
                                          movie['image']['medium'],
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: double.infinity,
                                        )
                                      : Container(
                                          color: Colors.grey[800],
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                ),
                                SizedBox(height: 8.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Text(
                                    movie['name'],
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
