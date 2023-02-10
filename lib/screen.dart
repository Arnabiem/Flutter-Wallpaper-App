import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
class Screen extends StatefulWidget {
  final String imageurl;
  const Screen({Key? key, required this.imageurl}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  Future<void> setwallpaper() async{
    int location=WallpaperManager.HOME_SCREEN;
    var file=await DefaultCacheManager().getSingleFile(widget.imageurl);
    bool result=await WallpaperManager.setWallpaperFromFile(file.path, location);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(child: Container(
              child: Image.network(widget.imageurl),
            )),
            InkWell(
              onTap:() {
                setwallpaper();
              },
              child: Container(
                height: 50,
                width: double.infinity,
                color: Colors.black,
                child: Center(child: Text(
                  'Set as Wallpaper', style: TextStyle(fontSize: 20, color: Colors.red),)),
              ),
            )

          ],
        ),
      ),
    );
  }
}
