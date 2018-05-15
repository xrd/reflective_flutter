import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import "state_injector.dart";

void main() {
  runApp(new MaterialApp(
    title: 'Navigation Basics',
    home: new FirstScreen(),
  ));
}

@stateInjector
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => stateInjector.createState( () => new RandomWordsState(), ["loadWords", "myFakedArgs"] );
}

class RandomWordsState extends State<RandomWords> {
  String wordPair;

  void loadWords({String seeded = null})
  {
    wordPair = seeded ?? new WordPair.random().asPascalCase;
  }

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return (new Text(wordPair));
  }
}

class FirstScreen extends StatelessWidget {

  RandomWords randomWords = new RandomWords();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('First Screen'),
      ),
      body: new Center(
        child: new RaisedButton(
          child: randomWords,
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new SecondScreen()),
            );
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Second Screen"),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('Go back!'),
        ),
      ),
    );
  }
}
