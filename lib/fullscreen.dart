import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_handler/wallpaper_handler.dart';

class Fullscreen extends StatefulWidget {
  final String ImageUrl;
  const Fullscreen({super.key, required this.ImageUrl});

  @override
  State<Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {
  Future<void> SetWallpaper() async {
    var location = WallpaperLocation.homeScreen;
    var file = await DefaultCacheManager().getSingleFile(widget.ImageUrl);
    var result =
        await WallpaperHandler.instance.setWallpaperFromFile(file.path, location);
    print("Result: $result");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.network(widget.ImageUrl, fit: BoxFit.cover),
          ),
          InkWell(
              onTap: () {
                SetWallpaper();
              },
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.black,
                child: Text(
                  "Set Wallpaper",
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
