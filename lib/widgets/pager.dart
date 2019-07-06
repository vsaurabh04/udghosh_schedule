import 'package:Schedule/widgets/rectangle_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuPager extends StatefulWidget {
  @override
  _MenuPagerState createState() => _MenuPagerState();
}

const double _kViewportFraction = 0.8;

class _MenuPagerState extends State<MenuPager> {
  int selectedPageIndex = 0;
  Future getSchedule() async {
    var firestore = Firestore.instance;
      QuerySnapshot qn = await firestore.collection('schedule1').getDocuments();
      return qn.documents;
  }
  List<String> days = ["Day 1", "Day 2", "Day 3"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
       title: Center(child:Text("Schedule",style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Dosis',
          ),)),
       
     ),
     
    body: Container(
      child: FutureBuilder(future: getSchedule(),builder: (_, snapshot)
      {
        if(snapshot.connectionState == ConnectionState.waiting){
              print("Check 2: Ya shayad yaha");

          return Stack(
            
            children: <Widget>[
              Text("Loading"),
               _renderBackground(),
               _renderTitle(days[selectedPageIndex]),
               _renderBottomNav(),
               
             
               
               
            ],
          );
        }
        else{
          
            print("Check 1: Problem here");
            return  Stack(
              children: <Widget>[
                _renderBackground(),
                _renderTitle(days[selectedPageIndex]),
                _renderBottomNav(),
                _renderContents(snapshot, selectedPageIndex, this.handlePageChanged),
              ], 
            );
          }
      })
    )
    );
  }

  void handlePageChanged(int pageIndex) {
    setState(() {
      selectedPageIndex = pageIndex;
    });
  }

  Widget _renderContents(AsyncSnapshot scheduleDay ,int selectedPageIndex, void onPageChanged(int pageIndex)) 
  {
    print("Check 3: Entered _renderContents");
      return PageView(
      controller: PageController(
        initialPage: selectedPageIndex, viewportFraction: _kViewportFraction),
      children: List<Widget>.generate(scheduleDay.data.length, (index) {
        return _renderPage(scheduleDay.data[index], index,selectedPageIndex);
      }, growable: false),
      onPageChanged: onPageChanged,
    );
  }

  Widget _renderPage(DocumentSnapshot page, int index, int selectedPageIndex) {
    print ("Check 4: from _renderContent to _renderPage");
    var resizeFactor = 1 -((index-selectedPageIndex) * 0.2).abs();
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 350.0 * resizeFactor,
        height: 600.0 * resizeFactor,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 0.0, right: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              elevation: 24.0,
              child: Container(
                height: MediaQuery.of(context).size.height*0.70,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SvgPicture.network(
                        page.data['image'],
                        width: 400.0,
                        height: 400.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderBottomNav() {
    List<String> iconImages =["assets/images/runningMan.svg","assets/images/cric-bat.svg", "assets/images/hockey.svg"];
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 10,bottom: 20.0),
        child: FittedBox(
          alignment: FractionalOffset.bottomCenter,
          child: RectangleIndicator(
            icons: iconImages,
            selectedIndex: selectedPageIndex,
          ),
        ),
      ),
    );
  }

  Widget _renderTitle(String titleText) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          titleText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Dosis',
          ),
        ),
      ),
    );

  }
 
  Widget _renderBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient:LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.indigo[800],
            Colors.indigo[700]],
          )
        ),
      ),
    );
  }
}
