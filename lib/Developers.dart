import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:new_project/Directory/drawer.dart';


class DeveloperInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Developers',
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFFE8716D),
          primaryColor: Color(0xFF2E3E52),
          buttonColor: Color(0xFF6ADCC8),
          primaryColorDark: Color(0xFF7C8BA6)),
      home: new DevPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class DevPage extends StatefulWidget {
  DevPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<DevPage> with TickerProviderStateMixin {
  PageController pageViewController;
  String str;
  GlobalKey<ScaffoldState> scfldKey = new GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> devs = [
    {
      'name': 'Nabin Saru',
      'image': 'assets/nabin.png',
      'color': Colors.greenAccent,
      'cont': 'n2graphics',
      'desg': 'Designer, Front End Developer, Backend Developer, Integration and Debugger',
    },
    {
      'name': 'Sandesh Adhikari',
      'image': 'assets/sandesh.png',
      'color': Colors.blue,
      'cont': 'gway',
      'desg': 'Front End Developer, Backend Developer and Tester',
    },
    {
      'name': 'Sulav Panthi',
      'image': 'assets/sulav.png',
      'color': Colors.red,
      'cont': 'Just Sul',
      'desg': 'Backend Developer and Machine Model Development',
    },
    {
      'name': 'Archana Pant',
      'image': 'assets/arcy.png',
      'color': Colors.amberAccent,
      'cont': 'Arcy',
      'desg': 'Designer and Machine Model Development',
    },
  ];
  Color clr = Colors.orange;
  var pos = 20.0;
  int currentPage = 0;
  double pageOffset = 0.0;
  double currentOffset = 0.0;
  var dir = ScrollDirection.reverse;
  @override
  void initState() {
    super.initState();
    pageViewController = new PageController(initialPage: 0);
    setState(() {
      clr = devs[0]['color'];
    });
    pageViewController.addListener(() {
      dir = pageViewController.position.userScrollDirection;
      currentPage = pageViewController.page.truncate();
      currentOffset = pageViewController.offset;
      pageOffset = pageViewController.position.extentInside * currentPage;
      setState(() {
        pos = getMappedValue(0.0, pageViewController.position.extentInside,
            20.0, 100.0, pageViewController.offset - pageOffset);
      });
    });
  }

  double getMappedValue(double range1low, double range1high, double range2low,
      double range2high, double number) {
    return ((number - range1low) *
        ((range2high - range2low) / (range1high - range1low))) +
        range2low;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scfldKey,
      appBar: AppBar(title: Text('Developers'),),
      endDrawer: AppDrawer(),
      body: AnimatedContainer(
        padding: EdgeInsets.only(top: 50.0),
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
        color: clr,
        child: PageView.builder(
          itemCount: devs.length,
          onPageChanged: (int page) {
            this.setState(() {
              clr = devs[page]['color'];
              print(page);
              print(clr);
            });
          },
          controller: pageViewController,
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(scfldKey.currentContext).size.height -
                        100.0,
                    width: MediaQuery.of(scfldKey.currentContext).size.width -
                        60.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          width: MediaQuery.of(scfldKey.currentContext)
                              .size
                              .width -
                              100.0,
                          left: index != currentPage
                              ? getMappedValue(20.0, 100.0, 160.0, 20.0, pos)
                              : getMappedValue(20.0, 100.0, 20.0, -120.0, pos),
                          top: 20.0,
                          child: Opacity(
                            opacity: index != currentPage
                                ? getMappedValue(20.0, 100.0, 0.0, 01.0, pos)
                                : getMappedValue(20.0, 100.0, 01.0, 00.0, pos),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${devs[index]['name']}',
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Color(0xFF2E3E52),
                                          fontSize: 25.89,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      '${devs[index]['cont']}',
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Color(0xFF6ADCC8),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    '${devs[index]['desg']}',
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: index != currentPage
                              ? getMappedValue(20.0, 100.0, 160.0, 20.0, pos)
                              : getMappedValue(20.0, 100.0, 20.0, -120.0, pos),
                          bottom: 20.0,
                          child: Opacity(
                            opacity: index != currentPage
                                ? getMappedValue(20.0, 100.0, 0.0, 0.4, pos)
                                : getMappedValue(20.0, 100.0, 0.4, 00.0, pos),
                            child: Text(
                              '${devs[index]['name']}',
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 130.0, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: index != currentPage
                        ? getMappedValue(20.0, 100.0, -120.0, -10.0, pos)
                        : getMappedValue(20.0, 100.0, -10.0, 120.0, pos),
                    bottom: 100.0,
                    child: Image.asset(
                      '${devs[index]['image']}',
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}