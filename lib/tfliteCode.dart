import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'result.dart';

class TfliteClassification extends StatefulWidget {
  @override
  _TfliteClassificationState createState() => _TfliteClassificationState();
}

class _TfliteClassificationState extends State<TfliteClassification> {
  File _pickedImage;
  List<dynamic> _recognitions;
  bool _busy = false;
  var result;
  bool isLoaded = false;
  String label;
  double confidence;

  // loading a model
  Future loadModel() async {
    Tflite.close();
    String res = await Tflite.loadModel(
        model: "assets/dogBread.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  Future getImageGallery() async {
    final takeImage = await ImagePicker().getImage(source: ImageSource.gallery);
    //if (_pickedImage == null) return;
    setState(() {
      _pickedImage = File(takeImage.path);
      isLoaded = true;
    });
  }

  Future getImageCamera() async {
    final takeImage = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(takeImage.path);
      isLoaded = true;
    });
  }

  // Prediction
  Future predict(File image) async {
    _recognitions = await Tflite.runModelOnImage(
      path: image.path,
      // required
      imageMean: 0.0,
      // defaults to 117.0
      imageStd: 255.0,
      // defaults to 1.0
      numResults: 2,
      // defaults to 5
      threshold: 0.2,
      // defaults to 0.1
      asynch: true,
    );
    // defaults to true

    setState(() {
      print(_recognitions);
      label = _recognitions[0]['label'];
      confidence = (_recognitions[0]['confidence']);
      print(label);
      print(confidence);
    });
  }

  @override
  void initState() {
    super.initState();

    //_busy = true;

    loadModel().then((val) {
      setState(() {
        //_busy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo[100],
        body: Center(
          child: Container(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 200.0),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(),
                          splashColor: Colors.blueGrey,
                          child: Text(
                            'Gallery',
                            style: TextStyle(fontSize: 28, color: Colors.black),
                          ),
                          color: Colors.indigo[300],
                          onPressed: () {
                            getImageGallery();
                          },
                        ),
                        SizedBox(width: 30.0),

                        RaisedButton(
                          shape: RoundedRectangleBorder(),
                          splashColor: Colors.blueGrey,
                          child: Text(
                            'Camera',
                            style: TextStyle(fontSize: 28, color: Colors.black),
                          ),
                          color: Colors.indigo[300],
                          onPressed: () {
                            getImageCamera();
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.0),
                  isLoaded
                      ? Center(
                          child: Container(
                            height: 200.0,
                            width: 600.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_pickedImage),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: Text(
                            'Image not selected',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                  SizedBox(height: 50.0),
                  Container(
                    width: 300,
                    child: RaisedButton(
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Classify',
                        style: TextStyle(fontSize: 28, color: Colors.black),
                      ),
                      color: Colors.indigo[300],
                      onPressed: () {
                        predict(_pickedImage);

                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PredictionResult(
                                  label: label,
                                  confidence: confidence,
                                ),
                              ),
                            );
                          });
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                ]),
          ),
        ),
      ),
    );
  }
}
