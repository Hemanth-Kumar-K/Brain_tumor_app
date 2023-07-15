import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreImageDisplay extends StatefulWidget {
  const FirestoreImageDisplay({super.key});

  @override
  State<FirestoreImageDisplay> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FirestoreImageDisplay> {
  late String imageUrl;
  //late String imageUrl1;
  final storage = FirebaseStorage.instance;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    // Set the initial value of imageUrl to an empty string
    imageUrl = '';
    //imageUrl1 = '';
    //Retrieve the imge grom Firebase Storage
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    try {
      // Get the feference to the image file in Firebase Storage
      final ref = storage.ref().child('videos/output.mp4');
      //final ref1 = storage.ref().child('java.jpg');
      // Get teh inageUrl to download URL
      final url = await ref.getDownloadURL();
      //final url1 = await ref1.getDownloadURL();

      _videoController = VideoPlayerController.network(url);
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        autoInitialize: true,
      );
      setState(() {
        imageUrl = url;
        //imageUrl1 = url1;
      });
    } catch (error) {
      print('Prediction Error: $error');
      Fluttertoast.showToast(msg: 'Prediction Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display image from fiebase "),
      ),
      body: Column(
        children: [
          _chewieController != null
              ? Chewie(
                  controller: _chewieController!,
                )
              : Container(),
        ],
      ),
    );
  }
}
