import 'package:flutter/material.dart';
import 'package:skribbl/create_room_screen.dart';

import 'package:skribbl/joinScreen.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Create/ join a room to play",
              style:TextStyle(
                fontSize: 24
              ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
                  minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width/2.5, 50))
                ),
                  onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateRoomScreen()));

              },
                  child: const Text("Create",
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
              ),

              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width/2.5, 50))
                ),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>JoinRoomScreen()));
                },
                child: const Text("Join",
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
