import 'package:flutter/material.dart';
import 'package:skribbl/models/my_custom_painter.dart';
import 'package:skribbl/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreen extends StatefulWidget {
  final Map data;
  final String screenFrom;
  PaintScreen({required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  Map dataOfRoom = {};
  List<TouchPoints> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;

  @override
  void initState() {
    super.initState();
    connect();
    print(widget.data);
  }

  void connect() {
    _socket = IO.io('http://192.168.1.42:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();

    if (widget.screenFrom == 'createRoom') {
      _socket.emit('create-game', widget.data);
    } else {
      _socket.emit('join-game', widget.data);
    }

    _socket.onConnect((data) {
      print('connected!');
      _socket.on('updateRoom', (roomData) {
        print(roomData['word']);
        setState(() {
          dataOfRoom = roomData;
        });
        if (roomData['isJoin'] != true) {}
      });

      _socket.on('points', (point) {
        if (point['details'] != null) {
          setState(() {
            points.add(TouchPoints(
                points: Offset((point['details']['dx']).toDouble(),
                    (point['details']['dy']).toDouble()),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width,
                height: height * 0.55,
                child: GestureDetector(
                    onPanUpdate: (details) {
                      print(details.localPosition.dx);
                      _socket.emit('paint', {
                        'details': {
                          'dx': details.localPosition.dx,
                          'dy': details.localPosition.dy
                        },
                        'roomName': widget.data['name']
                      });
                    },
                    onPanStart: (details) {
                      print(details.localPosition.dx);
                      _socket.emit('paint', {
                        'details': {
                          'dx': details.localPosition.dx,
                          'dy': details.localPosition.dy
                        },
                        'roomName': widget.data['name']
                      });
                    },
                    onPanEnd: (details) {
                      _socket.emit('paint', {
                        'details': null,
                        'roonName': widget.data['name'],
                      });
                    },
                    child: SizedBox.expand(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: RepaintBoundary(
                            child: CustomPaint(
                          size: Size.infinite,
                          painter: MyCustomPainter(pointsList: points),
                        )),
                      ),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
