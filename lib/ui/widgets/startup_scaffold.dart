import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/ui/clippers/startup_clipper.dart';

class StartupScaffold extends StatefulWidget {
  @override
  _StartupScaffoldState createState() => _StartupScaffoldState();

  final Widget appBar;
  final Widget body;

  const StartupScaffold({Key key, this.appBar, this.body});

}

class _StartupScaffoldState extends State<StartupScaffold> {
  @override
  Widget build(BuildContext context) {

    StartupClipper clipper = StartupClipper();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      child: LayoutBuilder(
        builder: (context, box) {

          double clip_height = box.maxHeight * C_startup_scaffold_height;
          double padding = clip_height - clip_height * C_startup_scaffold_diff;

          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: color_background,
                child: Container(
                  padding: EdgeInsets.only(top: padding),
                  child: widget.body,
                ),
              ),
              ClipPath(
                clipper: clipper,
                child: Container(
                  width: double.infinity,
                  height: box.maxHeight * C_startup_scaffold_height,
                  decoration: BoxDecoration(
                    gradient: startup_scaffold_gradient,
                  ),
                  child: widget.appBar
                ),
              )
            ],
          );
        }
      ),
    );
  }
}

