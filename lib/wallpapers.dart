import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/fullscreen.dart';

class Wallpapers extends StatefulWidget {
  const Wallpapers({super.key});

  @override
  State<Wallpapers> createState() => _WallpapersState();
}

class _WallpapersState extends State<Wallpapers> {
  List images = [];
  int page = 1;

  fetchData() async {
    var response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              'AD50na6TuWLcblEKwwS8gkauxMaVrqUjND5TREIbC5LB7XzCGh0zNIxJ'
        });

    Map data = jsonDecode(response.body);

    setState(() {
      images = data['photos'];
    });
  }

  void loadmore() async {
    page += 1;

    String url = 'https://api.pexels.com/v1/curated?per_page=80&&page=' +
        page.toString();

    var response = await http.get(Uri.parse(url), headers: {
      "Authorization":
          "AD50na6TuWLcblEKwwS8gkauxMaVrqUjND5TREIbC5LB7XzCGh0zNIxJ"
    });
    print("Response code: ${response.statusCode}");
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);

      setState(() {
        images.addAll(data['photos']);
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpapers Application"),
      ),
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    childAspectRatio: 2 / 3,
                  ),
                  itemBuilder: (context, item) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Fullscreen(
                                    ImageUrl: images[item]['src']['large2x'])));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Image.network(images[item]['src']['tiny'],
                            fit: BoxFit.cover),
                      ),
                    );
                  })),
          InkWell(
              onTap: () {
                loadmore();
              },
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.black,
                child: Text(
                  "Load more",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
