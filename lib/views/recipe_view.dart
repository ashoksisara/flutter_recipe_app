import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {

  final String postUrl;
  RecipeView({this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

  String finalUrl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.postUrl.contains('http://')){
      finalUrl = widget.postUrl.replaceAll('http://', 'https://');
    }else{
      finalUrl = widget.postUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30,right: 24, left: 24, bottom: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xff213A50),
                      const Color(0xff071930)
                    ])),
                child: Row(
                  mainAxisAlignment: kIsWeb
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Text(
                      'Flutter',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    Text('Recipes',
                        style: TextStyle(fontSize: 20, color: Colors.white))
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height-100,
                width:  MediaQuery.of(context).size.width,
                child: WebView(
                  initialUrl: finalUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController){
                    setState(() {
                      _controller.complete(webViewController);
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
