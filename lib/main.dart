import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              Container(
                width: double.infinity,
                height: 20,
              ),

              Expanded(
                child: CardFlipper()
              ),

              Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey,
              ),
              
            ],
          ),
        );
  }
}

class CardFlipper extends StatefulWidget {
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with TickerProviderStateMixin{

  final numCards = 3;
  double scrollPercent = 0.0;
  Offset startDrag;                       //When we start Dragging
  double startDragPercentScroll;          //Percent when we start Dragging
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  void initState() { 
    super.initState();

    finishScrollController = new AnimationController(vsync: this,duration: Duration(milliseconds: 150));
    finishScrollController.addListener((){
      setState(() {
       scrollPercent = lerpDouble(finishScrollStart,finishScrollEnd,finishScrollController.value); 
      });
    });
  }

  @override
  void dispose() { 
    finishScrollController.dispose();
    super.dispose();
  }

  
  void _onHorizontalDragStart(DragStartDetails dragStartDetails){
    startDrag =dragStartDetails.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails dragUpdateDetails){
    final currentDrag = dragUpdateDetails.globalPosition;
    final dragDistance = currentDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance/context.size.width;
    setState(() {
      scrollPercent = (startDragPercentScroll + (-singleCardDragPercent/numCards)).clamp(0.0, 1.0 - (1/numCards)); 
    });
  }

  void _onHorizontalDragEnd(DragEndDetails dragEndDetails){
    finishScrollStart =scrollPercent;
    finishScrollEnd = (scrollPercent*numCards).round()/numCards;
    finishScrollController.forward(from: 0.0);
    setState(() {
     startDrag = null;
     startDragPercentScroll = null; 
    });
  }

  List<Widget> _buildCards(){
    return [
      _buildCard(0, 3, scrollPercent),
      _buildCard(1, 3, scrollPercent),
      _buildCard(2, 3, scrollPercent),
    ];
  }

  Widget _buildCard(int CardIndex, int CardCount, double ScrollPercent){
    final cardScrollPercent = ScrollPercent/(1/CardCount);
    return FractionalTranslation(
      translation: Offset(CardIndex-cardScrollPercent, 0.0),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: GestureDetector(
         onHorizontalDragStart: _onHorizontalDragStart,
         onHorizontalDragUpdate: _onHorizontalDragUpdate,
         onHorizontalDragEnd: _onHorizontalDragEnd,
         behavior: HitTestBehavior.translucent,
         child: Stack(
           children: _buildCards(),
         ),
       )
    );
  }
}

class Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/img3.jpg',fit: BoxFit.cover,),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("10TH STREET",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("2-3",style: TextStyle(fontSize: 100,color: Colors.white,letterSpacing: 5),),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text("FT",style: TextStyle(fontSize: 15,color: Colors.white),),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Icon(Icons.wb_sunny,color: Colors.white,),
                      ),
                      Text("33°C",style: TextStyle(fontSize: 15,color: Colors.white,),),
                    ]
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  decoration: BoxDecoration(color: Colors.black38,borderRadius: BorderRadius.circular(30),border: Border.all(color: Colors.white)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Mostly Cloudy",style: TextStyle(color: Colors.white,letterSpacing: -0.4),),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8),child: Icon(Icons.wb_cloudy,color: Colors.white,),),
                      Text("11.2mph ENE",style: TextStyle(color: Colors.white,letterSpacing: -0.4)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          )
        ],
      ),
    );
  }
}