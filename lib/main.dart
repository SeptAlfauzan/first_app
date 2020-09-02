import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  // final List<WordPair> _suggestions = <WordPair>[]; //create array of word pair
  final _saved = Set<String>(); //set of saved word pair
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);
  List data;
  //push to next page
  void _pushSaved() {
    //move to saved suggestion page
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final tiles = _saved.map((String pair) {
          return ListTile(
            title: Text(
              pair,
              style: _biggerFont,
            ),
          );
        });

        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          body: ListView(children: divided), //return list view in body
        );
      },
    ));
  }

  Future<String> fetchAlbum() async {
    final response = await http.get(
        Uri.encodeFull('https://swapi.dev/api/starships'),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var resBody = json.decode(response.body)['results'];
      print(resBody);
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          data = resBody;
        });
      });
      return 'success';
    } else {
      print('gagal');
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Widget _buildSuggestions() {
    // fetchAlbum();
    print(data);
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext _context, int i) {
        print(i);
        //add skeleton loading
        // if (data == null) {
        //   return SizedBox(
        //       child: Shimmer.fromColors(
        //           baseColor: Colors.grey[300],
        //           highlightColor: Colors.grey[100],
        //           child: ListItem(index: -1)));
        // }

        // if (i.isOdd) {
        //   // Add a one-pixel-high divider widget before each row
        //   // in the ListView.
        //   return Divider();
        // }

        return _buildRow(data[i]["model"]);
      },
    );
  }

  Widget _buildRow(String pair) {
    //check to ensure that a word pairing has
    //not already been added to favorites
    final alreadySaved = _saved.contains(pair);
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            pair,
            style: _biggerFont,
          ),
          trailing: Icon(
            alreadySaved ? Icons.bookmark : Icons.bookmark_outline,
            color: alreadySaved ? Colors.black : null,
          ),
          onTap: () {
            //when user clicked on list item
            setState(() {
              alreadySaved ? _saved.remove(pair) : _saved.add(pair);
            });
          },
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAlbum();
  }
}

class ListItem extends StatelessWidget {
  final int index;
  const ListItem({Key key, this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.grey,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(primaryColor: Colors.black), //change primary theme
      home: RandomWords(),
    );
  }
}
