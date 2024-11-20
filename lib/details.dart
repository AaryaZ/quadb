import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final dynamic movie;

  const Details({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Text(movie['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Movie Image
            if (movie['image'] != null)
              Container(
                height: 300,
                child: Image.network(
                  movie['image']['original'],
                  fit: BoxFit.cover,
                ),
              ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // Movie Rating
                  Row(
                    children: [
                      _buildStarRating(movie['rating']['average'] ?? 2),
                      SizedBox(width: 8.0),
                      Text(
                        (movie['rating']['average'] ?? 2.0).toString(),
                        style: TextStyle(
                          color: Color(0xFFCC5500),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),

                  // Movie Genres
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Wrap(
                      spacing: 8.0,
                      children: [
                        for (String genre in movie['genres'])
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(59, 204, 85, 0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Movie Summary
                  Text(
                    _stripHtmlTags(movie['summary'] ?? 'No summary available.'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),

                  // Movie Status
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                          color: Color(0xFFCC5500),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        movie['status'] ?? 'Not Available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),

                  // Movie Runtime
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(
                        'Runtime: ',
                        style: TextStyle(
                          color: Color(0xFFCC5500),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (movie['runtime'] != null
                            ? '${movie['runtime']} minutes'
                            : 'Unknown'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Function to build star rating
  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    int emptyStars = 5 - fullStars;

    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(
        Icons.star,
        color: Colors.yellow,
        size: 18.0,
      ));
    }

    for (int i = 0; i < emptyStars; i++) {
      stars.add(Icon(
        Icons.star_border,
        color: Colors.grey,
        size: 18.0,
      ));
    }

    return Row(
      children: stars,
    );
  }
}

String _stripHtmlTags(String htmlText) {
  final RegExp exp = RegExp(r'<[^>]*>');
  return htmlText.replaceAll(exp, '').trim();
}
