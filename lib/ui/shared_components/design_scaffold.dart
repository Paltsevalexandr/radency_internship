import 'package:flutter/material.dart';

class DesignScaffold extends StatelessWidget {
  final Widget appBar;
  final Widget header;
  final Widget body;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;

  const DesignScaffold({Key key, this.appBar, this.header, this.body, this.floatingActionButton, this.bottomNavigationBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(child: header ?? Container()),
            SliverToBoxAdapter(child: SizedBox(height: 20,),),
            SliverToBoxAdapter(child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
            )),
          ];
        },
        body: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10
          ),
          color: Colors.white,
          child: body ?? Container(),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar ?? Container(
        height: 0,
      ),
      floatingActionButton: floatingActionButton ?? Container(),
    );
  }
}