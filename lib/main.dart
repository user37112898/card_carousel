import 'dart:ui';

import 'package:card_carousel/card_data.dart';
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
  double scrollingPercent = 0.0;
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
                child: CardFlipper(
                  cards:demoCards,
                  onScroll:(double scrollPercent){
                    setState(() {
                     this.scrollingPercent = scrollPercent;
                    });
                  }
                )
              ),

              BottomBar(
                cardCount:demoCards.length,
                scrollPercent:scrollingPercent,
              ),
              
            ],
          ),
        );
  }
}

class CardFlipper extends StatefulWidget {
  final List<CardViewModel> cards;
  final Function(double scrollPercent) onScroll;
  CardFlipper({
    this.cards,
    this.onScroll
    });
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with TickerProviderStateMixin{

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
       if(widget.onScroll != null){
          widget.onScroll(scrollPercent);
        } 
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
      scrollPercent = (startDragPercentScroll + (-singleCardDragPercent/widget.cards.length)).clamp(0.0, 1.0 - (1/widget.cards.length)); 
      if(widget.onScroll != null){
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails dragEndDetails){
    finishScrollStart =scrollPercent;
    finishScrollEnd = (scrollPercent*widget.cards.length).round()/widget.cards.length;
    finishScrollController.forward(from: 0.0);
    setState(() {
     startDrag = null;
     startDragPercentScroll = null; 
    });
  }

  List<Widget> _buildCards(){

    final cardCount = widget.cards.length;
    int index = -1;
    return widget.cards.map((CardViewModel cardViewModel){
      ++index;
      return _buildCard(cardViewModel,index, widget.cards.length, scrollPercent);
    }).toList();

    // return [
    //   _buildCard(0, 3, scrollPercent),
    //   _buildCard(1, 3, scrollPercent),
    //   _buildCard(2, 3, scrollPercent),
    // ];
  }

  Widget _buildCard(CardViewModel cardViewModel,int CardIndex, int CardCount, double ScrollPercent){
    final parallax =scrollPercent - (CardIndex/CardCount);
    final cardScrollPercent = ScrollPercent/(1/CardCount);
    return FractionalTranslation(
      translation: Offset(CardIndex-cardScrollPercent, 0.0),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          cardViewModel:cardViewModel,
          parallaxPercent:parallax,
        ),
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
  
  final CardViewModel cardViewModel;
  final double parallaxPercent;
  Card({this.cardViewModel,this.parallaxPercent=0.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FractionalTranslation(
              translation: Offset(parallaxPercent*3, parallaxPercent),
              child: OverflowBox(
                maxWidth: double.infinity,
                child: Image.asset(cardViewModel.backdropAssetPath,fit: BoxFit.cover,),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(cardViewModel.address,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${cardViewModel.minHeightInFeet}-${cardViewModel.maxHeightInFeet}",style: TextStyle(fontSize: 100,color: Colors.white,letterSpacing: 5),),
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
                      Text("${cardViewModel.tempInDegrees}°C",style: TextStyle(fontSize: 15,color: Colors.white,),),
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
                      Text(cardViewModel.weatherType,style: TextStyle(color: Colors.white,letterSpacing: -0.4),),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8),child: Icon(Icons.wb_cloudy,color: Colors.white,),),
                      Text("${cardViewModel.windSpeedInMph}mph ${cardViewModel.cardinalDirection}",style: TextStyle(color: Colors.white,letterSpacing: -0.4)),
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
class BottomBar extends StatelessWidget {

  final int cardCount;
  final double scrollPercent;
  BottomBar({Key key,this.cardCount,this.scrollPercent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 5,
                child: ScrollIndicator(
                  cardCount:cardCount,
                  scrollPercent:scrollPercent
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  ScrollIndicator({
    this.cardCount,
    this.scrollPercent
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScrollIndicatorPainter(
        cardCount:cardCount,
        scrollPercent:scrollPercent,
      ),
      child: Container(),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {

  final int cardCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({this.cardCount,this.scrollPercent}):
  trackPaint = Paint()..color=Colors.grey..style=PaintingStyle.fill,
  thumbPaint = Paint()..color=Colors.white..style=PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0),
      ),
      trackPaint
    );

    double thumbLeft = scrollPercent * size.width;
    final thumbWidth = size.width/cardCount;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(thumbLeft, 0.0, thumbWidth, size.height),
        topLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0),
      ),
      thumbPaint
    );
  }

  @override
  bool shouldRepaint(ScrollIndicatorPainter oldDelegate) => false;

  // @override
  // bool shouldRebuildSemantics(ScrollIndicatorPainter oldDelegate) => false;
}