import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [SizedBox(height: 32), _groupTiles()],
      ),
    );
  }
}

Widget _groupTiles() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 300.0),
    child: Column(
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/lego/1.jpg",
              ),
              backgroundColor: Colors.transparent,
            ),
            title: Text("Lorran Rodrigues"),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("link1"),
                Text("link2"),
                Text("link3"),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/lego/2.jpg'),
              backgroundColor: Colors.transparent,
            ),
            title: Text("Prof. Dr. Marcos dos Santos"),
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/lego/3.jpg"),
              backgroundColor: Colors.transparent,
            ),
            title: Text("Prof. Dr. Carlos Francisco Simões Gomes"),
          ),
        )
      ],
    ),
  );
}
