import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "舒尔特方格",
      home: ShulteCheck(),
    );
  }
}

class ShulteCheck extends StatefulWidget {
  @override
  _ShulteCheckState createState() => _ShulteCheckState();
}

class _ShulteCheckState extends State<ShulteCheck>
    with TickerProviderStateMixin {
  //定义方格的数量
  int count;

  //存放数值的列表
  List<int> data = List<int>();

  //存放当前点击的数值的列表,存放顺序
  List<int> curSel = List<int>();

  //动画 controller
  List<AnimationController> controller = List<AnimationController>();

  //动画颜色
  List<Animation<Color>> animations = List<Animation<Color>>();

  @override
  void initState() {
    super.initState();
    count = 16;
    List.generate(count, (index) {
      //每次要往list中添加点击的数字，所以 index + 1
      data.add(index + 1);
      //点击每个方格都设置controller动画
      controller.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)));

      animations.add(
          //颜色变换 白 --> 紫
          ColorTween(begin: Colors.white, end: Colors.purpleAccent)
              .animate(controller[index])
                ..addListener(() {
                  //点击格子之后发生的变化
                  setState(() {});
                }));
    });
    //使数值随机排列，相当于随机数
    data.shuffle();
  }

  tapCell(int i) {
    //获取最后点击的数字
    int lastCell = curSel.length > 0 ? curSel.last : 0;
    //验证是否点击过之前点击的数字 ，
    //data[i] -1 当前点击的数字 ，-1 就是之前点击的数字
    if (data[i] - 1 == lastCell) {
      //正确
      animations[i] = ColorTween(begin: Colors.white, end: Colors.purpleAccent)
          .animate(controller[i])
            ..addListener(() {
              setState(() {});
            });
      //正确的适合需要加进去
      curSel.add(data[i]);
    } else {
      //  不正确  变红色
      animations[i] = ColorTween(begin: Colors.white, end: Colors.redAccent)
          .animate(controller[i])
            ..addListener(() {
              setState(() {});
            });
    }
    //动画效果 从0开始
    controller[i].forward(from: 0).then((_) => controller[i].reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("舒尔特方格"),
      ),
      //制作方格
      body: GridView.count(
        //每行有4个方格
        crossAxisCount: 4,
        children: List.generate(count, (index) {
          return Container(
              alignment: Alignment.center,
              //设置color 保证每次刷新都变化颜色
              decoration: BoxDecoration(
                  border: Border.all(width: 1), color: animations[index].value),
              child: FlatButton(
                onPressed: () {
                  tapCell(index);
                },
                child: Text("${data[index]}",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ));
        }),
      ),
    );
  }
}
