import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe/models/recipe_model.dart';
import 'package:flutter_recipe/views/recipe_view.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController textEditingController = TextEditingController();

  String appId = '423ac15e';
  String appKey = 'd33b74af468789e07641b8c2e4b9b6ff';

  List<RecipeModel> recipes = List<RecipeModel>();

  getRecipes(String query) async{
    String url = 'https://api.edamam.com/search?q=$query&app_id=$appId&app_key=$appKey&from=0&to=3&calories=591-722&health=alcohol-free';

    var response = await http.get(url);
    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData['hits'].forEach((element){
      RecipeModel recipeModel = RecipeModel();
      recipeModel = RecipeModel.fromMap(element['recipe']);
      recipes.add(recipeModel);
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                const Color(0xff213A50),
                const Color(0xff071930)
              ])),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'What will you cook today??',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      'Just enter Ingredients you have and we will show the best recipes for you',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              decoration:InputDecoration(
                                hintText: 'Enter Ingredient',
                                hintStyle: TextStyle(
                                  fontSize: 18,color: Colors.white.withOpacity(0.5),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white
                                  )
                                )
                              ) ,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                              ),
                            ),
                          ),
                          SizedBox(width: 16,),
                          InkWell(
                            onTap: (){
                              if(textEditingController.text.isNotEmpty){
                                getRecipes(textEditingController.text);
                                print('just search it');
                              }else{
                                print('dont search it');
                              }
                            },
                            child: Container(
                              child: Icon(Icons.search, color: Colors.white,),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      child: GridView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        gridDelegate:SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 10.0
                        ) ,
                        children: List.generate(recipes.length, (index)  {
                          return RecipieTile(
                            title: recipes[index].label,
                            desc: recipes[index].source,
                            imgUrl: recipes[index].image,
                            url: recipes[index].url,
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                             ),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
