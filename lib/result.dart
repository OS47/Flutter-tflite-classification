import 'package:flutter/material.dart';
class PredictionResult extends StatelessWidget {
  String label;
  double confidence;
  PredictionResult({this.label, this.confidence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                //elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.indigo[300],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                  Text(
                    'Label: $label ',
                    style: TextStyle(fontSize: 28, color: Colors.black),
                  ),
                  Text(
                    'Confidence: ${(confidence*100).toInt()}%',
                    style: TextStyle(fontSize: 28, color: Colors.black),
                  ),
              ],),
                ),),

              SizedBox(height: 300.0),
              Container(
                height: 50,
                width: 500,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(),
                  color: Colors.indigo[300],
                  child: Text(
                    'Reclassify',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pop(context),
                  splashColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
