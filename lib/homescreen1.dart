import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File? image) onImageSelected;
  final bool disabled;

  ImagePickerWidget({required this.onImageSelected, required this.disabled});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  String? _imageName;
  String? _imageValue; // Added variable to store the value from the CSV file
  String? _filename; // Added variable to store the filename

  Future<void> _loadCSVData() async {
    final csvData = await rootBundle.loadString('assets/MetaData6.csv');
    final List<List<dynamic>> rows =
        const CsvToListConverter().convert(csvData);
    final String pickedImageName = _imageName!.split('/').last;

    for (final row in rows) {
      if (row[0] == pickedImageName) {
        setState(() {
          _imageValue = row[1];
        });
        break;
      }
    }

    if (_imageValue == null) {
      setState(() {
        _imageValue = 'No Ground Truth Value Found';
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        _imageName = pickedImage.path;
        _filename = _imageName!.split('/').last; // Get the filename
        widget.onImageSelected(_image); // Call the callback function
        _imageValue = null; // Reset the value when a new image is picked
        _loadCSVData(); // Load the CSV data for the picked image
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF1E232C),
          ),
          onPressed: widget.disabled ? null : _pickImage,
          child: Text('Pick Image'),
        ),
        SizedBox(height: 16.0),
        _image != null
            ? Column(
                children: [
                  Container(
                    width: 300.0, // Adjust the width as desired
                    height: 300.0, // Adjust the height as desired
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Image Name: $_filename'),
                  SizedBox(height: 20.0),
                  _imageValue != null
                      ? TextFormField(
                          key: ValueKey(
                              _image), // Add a unique key for the TextFormField
                          initialValue: _imageValue,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            labelText: 'Ground Truth Value',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(
                            // Added style for the text form field
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : CircularProgressIndicator(), // Show a progress indicator while loading CSV data
                  SizedBox(height: 8.0),
                ],
              )
            : Text('No image selected.'),
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

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  File? _selectedImage;
  String prediction = "";
  TextEditingController _textFieldController = TextEditingController();
  bool _isImagePickerDisabled = false;
  bool _isPredictButtonDisabled = false;
  bool _isPredictionMade =
      false; // Added variable to track if prediction has been made
  String? _videoName; // Added variable to store the video file name

  void _handleImageSelected(File? image) {
    setState(() {
      _selectedImage = File(image!.path);
      _videoName = _selectedImage != null
          ? _selectedImage!.path.split('/').last
          : null; // Get the video file name
      _textFieldController.text = '';
      _isPredictionMade =
          false; // Reset the prediction state when a new image is selected
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose();
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
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xFF1E232C),
          title: Text(
            'Brain Hemorrhage Classifier',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          actions: <Widget>[],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                ImagePickerWidget(
                  onImageSelected: _handleImageSelected,
                  disabled: _isImagePickerDisabled,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF1E232C),
                  ),
                  onPressed: _isPredictButtonDisabled
                      ? null
                      : () async {
                          if (_selectedImage != null) {
                            setState(() {
                              _isImagePickerDisabled = true;
                              _isPredictButtonDisabled = true;
                            });

                            var request = http.MultipartRequest(
                              'POST',
                              Uri.parse('http://16.170.204.187/ipredict'),
                            );

                            request.files.add(
                              await http.MultipartFile.fromPath(
                                'image',
                                _selectedImage!.path,
                              ),
                            );

                            var response = await request.send();

                            if (response.statusCode == 200) {
                              var jsonResponse =
                                  await response.stream.bytesToString();
                              setState(() {
                                prediction = jsonResponse;
                                _textFieldController.text = prediction;
                                _isPredictionMade =
                                    true; // Set the prediction state to true
                              });
                              print(jsonResponse);
                            } else {
                              print(
                                  'Request failed with status: ${response.statusCode}');
                            }

                            setState(() {
                              _isImagePickerDisabled = false;
                              _isPredictButtonDisabled = false;
                            });
                          } else {
                            print('No image selected.');
                          }
                        },
                  child: Text('Predict'),
                ),
                SizedBox(height: 20),
                if (_isPredictionMade &&
                    _videoName !=
                        null) // Show the TextFormField only if a video is selected and prediction has been made
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: TextField(
                        controller: _textFieldController,
                        style: TextStyle(
                          color: prediction == 'Normal'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          labelText: 'AI Prediction',
                          enabled: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
