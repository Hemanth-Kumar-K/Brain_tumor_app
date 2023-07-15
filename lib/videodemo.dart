import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart' show rootBundle;

class VideoPickerWidget extends StatefulWidget {
  final Function(File? video) onVideoSelected;
  final bool isPredicting;

  VideoPickerWidget({
    required this.onVideoSelected,
    required this.isPredicting,
  });

  @override
  _VideoPickerWidgetState createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  File? _video;
  String? _videoName;
  List<List<String>> _csvData = [];

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> sendVideo(File video) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://16.170.204.187/vpredict'));
    request.files.add(await http.MultipartFile.fromPath('video', video.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = await response.stream.bytesToString();
      return json.decode(jsonResponse);
    } else {
      throw Exception('Failed to send video: ${response.reasonPhrase}');
    }
  }

  Future<void> loadCSVData() async {
    String csvString = await rootBundle.loadString('assets/MetaData5.csv');
    List<List<dynamic>> csvData = CsvToListConverter().convert(csvString);
    setState(() {
      _csvData = csvData
          .map((row) => row.map((cell) => cell.toString()).toList())
          .toList();
    });
  }

  Future<void> _pickVideo() async {
    if (widget.isPredicting) return;
    final picker = ImagePicker();
    final pickedVideo = await picker.getVideo(source: ImageSource.gallery);

    setState(() async {
      if (pickedVideo != null) {
        _video = File(pickedVideo.path);
        _videoName = pickedVideo.path.split('/').last;
        widget.onVideoSelected(_video);
        // Clear existing video data and prediction
        _csvData.clear();
        _controller?.dispose();
        _chewieController?.dispose();
        _controller = VideoPlayerController.file(_video!);
        await _controller!.initialize();
        _chewieController = ChewieController(
          videoPlayerController: _controller!,
          autoInitialize: true,
          looping: false,
          autoPlay: false,
        );
        setState(() {}); // Trigger a rebuild to update the video player widget
        await loadCSVData();
      } else {
        print('No video selected.');
      }
    });
  }

  List<String> getVideoData(String videoName) {
    return _csvData.firstWhere((element) => element[0] == videoName,
        orElse: () => []);
  }

  @override
  Widget build(BuildContext context) {
    List<String> selectedVideoData = getVideoData(_videoName ?? '');

    return Column(
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E232C),
          ),
          onPressed: widget.isPredicting ? null : _pickVideo,
          child: Text('Pick Video'),
        ),
        SizedBox(height: 16.0),
        _video != null
            ? Column(
                children: [
                  Container(
                    width: 300.0, // Adjust the width as desired
                    height: 300.0, // Adjust the height as desired
                    child: _controller != null && _chewieController != null
                        ? Chewie(controller: _chewieController!)
                        : Container(),
                  ),
                  SizedBox(height: 10.0),
                  Text('Video Name: $_videoName'),
                  SizedBox(height: 10.0),
                  selectedVideoData.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(height: 30),
                            TextFormField(
                              initialValue: selectedVideoData.length > 1
                                  ? selectedVideoData[1]
                                  : '',
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                labelText: 'Ground Truth of Normal Frames',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: selectedVideoData.length > 2
                                  ? selectedVideoData[2]
                                  : '',
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                labelText: 'Ground Truth of Abnormal Frames',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: selectedVideoData.length > 3
                                  ? selectedVideoData[3]
                                  : '',
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                labelText:
                                    'Ground Truth Number of Normal Frames',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: selectedVideoData.length > 4
                                  ? selectedVideoData[4]
                                  : '',
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                labelText:
                                    'Ground Truth Number of Abnormal Frames',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: selectedVideoData.length > 5
                                  ? selectedVideoData[5]
                                  : '',
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                labelText:
                                    'Ground Truth Total Number of Frames',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              readOnly: true,
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )
                      : Text('No Ground Truth Data found'),
                ],
              )
            : Text('No video selected.'),
      ],
    ).marginEdgeInsets(EdgeInsets.only(left: 25, right: 25));
  }
}

extension MarginEdgeInsets on Widget {
  Widget marginEdgeInsets(EdgeInsetsGeometry margin) {
    return Container(
      margin: margin,
      child: this,
    );
  }
}

class MyHome6 extends StatefulWidget {
  @override
  _MyHome6State createState() => _MyHome6State();
}

class _MyHome6State extends State<MyHome6> {
  File? _selectedVideo;
  bool _isPredicting = false;
  String? _prediction;
  int _totalFrameCount = 0;
  int _normalCount = 0;
  List<String> _normalFrames = [];
  int _abnormalCount = 0;
  List<String> _abnormalFrames = [];
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  String res = "";

  void _handleVideoSelected(File? video) {
    setState(() {
      _clearPredictionData(); // Clear prediction data
      _selectedVideo = File(video!.path);
      _videoController = VideoPlayerController.file(_selectedVideo!);
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        autoInitialize: true,
      );
    });
  }

  void _clearPredictionData() {
    setState(() {
      _prediction = null;
      _totalFrameCount = 0;
      _normalCount = 0;
      _normalFrames.clear();
      _abnormalCount = 0;
      _abnormalFrames.clear();
      _videoController = null;
      _chewieController = null;
      res = "";
    });
  }

  Future<Map<String, dynamic>> sendVideo(File video) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://54.252.215.122/vpredict'));
    request.files.add(await http.MultipartFile.fromPath('video', video.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = await response.stream.bytesToString();
      return json.decode(jsonResponse);
    } else {
      throw Exception('Failed to send video: ${response.reasonPhrase}');
    }
  }

  Future<void> predictVideo() async {
    if (_selectedVideo != null) {
      setState(() {
        _isPredicting = true;
        _prediction = "";
      });

      var predictions;
      try {
        predictions = await sendVideo(_selectedVideo!);
        print('Total Frames: ${predictions['total_frames']}');
        print('Normal Count: ${predictions['normal_count']}');
        print('Normal Frames: ${predictions['normal_frames']}');
        print('Abnormal Count: ${predictions['abnormal_count']}');
        print('Abnormal Frames: ${predictions['abnormal_frames']}');
        var result = 'Yes';
        _prediction = result;
      } catch (error) {
        print('Prediction Error: $error');
        Fluttertoast.showToast(msg: 'Prediction Error: $error');
      }

      setState(() {
        _totalFrameCount = predictions['total_frames'];
        _normalCount = predictions['normal_count'];
        _normalFrames = List<String>.from(predictions['normal_frames']);
        _abnormalCount = predictions['abnormal_count'];
        _abnormalFrames = List<String>.from(predictions['abnormal_frames']);
        _isPredicting = false;
        res = "result";
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brain Hemorrhage Classifier',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
          backgroundColor: const Color(0xFF1E232C),
          title: Text('Brain Hemorrhage Classifier'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  "Enter a Video",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                VideoPickerWidget(
                  onVideoSelected: _handleVideoSelected,
                  isPredicting: _isPredicting,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E232C),
                  ),
                  onPressed: _isPredicting ? null : predictVideo,
                  child: Text('Predict'),
                ),
                SizedBox(height: 20),
                if (_selectedVideo != null &&
                    _chewieController != null &&
                    res != "")
                  Column(
                    children: [
                      Container(
                        width: 300.0, // Adjust the width as desired
                        height: 300.0, // Adjust the height as desired
                        child: Chewie(controller: _chewieController!),
                      ),
                      SizedBox(height: 10.0),
                      // Text(
                      //     'Video Name: ${_selectedVideo!.path.split('/').last}'),
                    ],
                  ),
                SizedBox(height: 20),
                _isPredicting
                    ? CircularProgressIndicator()
                    : _prediction != null
                        ? Column(
                            children: [
                              TextFormField(
                                initialValue: '$_normalFrames',
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  labelText: 'AI Prediction of Normal Frames',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                readOnly: true,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue: '$_abnormalFrames',
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  labelText: 'AI Prediction of Abnormal Frames',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                readOnly: true,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue: '$_normalCount',
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  labelText: 'Count of Normal Frames',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                readOnly: true,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue: '$_abnormalCount',
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  labelText: 'Count of Abnormal Frames',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                readOnly: true,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue: '$_totalFrameCount',
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  labelText: 'Total Count of Frames',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                readOnly: true,
                              ),
                              SizedBox(height: 20),
                            ],
                          ).marginEdgeInsets(
                            EdgeInsets.only(left: 25, right: 25))
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
