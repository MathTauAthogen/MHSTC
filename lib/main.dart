import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Millburn Tutor Club',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(channel:new IOWebSocketChannel.connect('ws://millburntutorclub.appspot.com/ws')),
    );
  }
}

class LoginPage extends StatefulWidget {
  WebSocketChannel channel;
  LoginPage({Key key,this.channel}):super(key: key);
  @override
  createState() => new LoginPageState();
}
class LoginPageState extends State<LoginPage> {
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  void _submit() {
    final form = formKey.currentState;
    form.save();
    _performLogin();
  }

  void _performLogin() {
    widget.channel.sink.add('$_email,$_password');
    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (context) {
            return new Scaffold(
                appBar: new AppBar(
                  title: new Text("Testing Purposes only")
                ),
                body: new StreamBuilder(
                  stream: widget.channel.stream,
                  builder: (context, snapshot) {
                    return new Text(snapshot.hasData ? '${snapshot.data}' : '');
                  },
                )
            );
          }
      ),
    );
    final snackbar = new SnackBar(
      content: new Text('Oops! Your username and password are incorrect. Please try again.'),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller1 = new TextEditingController();
    TextEditingController _controller2 = new TextEditingController();
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Millburn Tutor Club'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              new TextFormField(
                controller:_controller1,
                decoration: new InputDecoration(labelText: 'Username'),
                onSaved: (val) => _email = val,
              ),
              new TextFormField(
                controller:_controller2,
                decoration: new InputDecoration(labelText: 'Password'),
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
              new RaisedButton(
                onPressed: _submit,
                child: new Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






//class RandomWords extends StatefulWidget {
//  @override
//  createState() => new RandomWordsState();
//}
//class RandomWordsState extends State<RandomWords> {
//  final _suggestions = <WordPair>[];
//  final _biggerFont = const TextStyle(fontSize: 18.0);
//  @override
//  Widget build(BuildContext context) {
//    void _pushSaved(){
//      Navigator.of(context).push(
//          new MaterialPageRoute(
//          builder: (context) {
//            return new Scaffold(
//              appBar: new AppBar(
//                title: new Text('Saved Suggestions'),
//              ),
//              body: new Text("Yay!",style: _biggerFont)
//            );
//          }
//          ),
//      );
//    }
//    return new Scaffold (
//      appBar: new AppBar(
//        title: new Text('Startup Name Generator'),
//        actions: <Widget>[
//          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
//        ],
//      ),
//      body: _buildSuggestions(),
//    );
//  }
//  Widget _buildSuggestions() {
//    return new ListView.builder(
//        padding: const EdgeInsets.all(16.0),
//        itemBuilder: (context, i) {
//          if (i.isOdd) return new Divider();
//          final index = i ~/ 2;
//          if (index >= _suggestions.length) {
//            _suggestions.addAll(generateWordPairs().take(10));
//          }
//          return _buildRow(_suggestions[index]);
//        }
//    );
//  }
//  Widget _buildRow(WordPair pair) {
//    return new ListTile(
//      title: new Text(
//        pair.asPascalCase,
//        style: _biggerFont,
//      ),
//    );
//  }
//}

//class RandomWords2 extends StatefulWidget {
//  @override
//  createState() => new MyButtonState();
//}
//class MyButtonState extends State<RandomWords2> {
//  Widget build(BuildContext context){
//    return new Scaffold (
//      appBar: new AppBar(
//        title: new Text('Millburn Tutoring Club'),
//      ),
//      body:new ListView(children:[new RaisedButton(color:Colors.green,child: new Text('Stuff'),onPressed:(){
//      Navigator.of(context).push(
//      new MaterialPageRoute(
//          builder: (context) {
//            return new Scaffold(
//                appBar: new AppBar(
//                  title: new Text('Saved Suggestions'),
//                ),
//                body: new Text("Yay!")
//            );
//          }
//      ),
//    );},)]));
//  }
//}
