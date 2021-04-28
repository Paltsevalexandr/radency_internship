import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class BaseModal extends StatelessWidget{
  final String title;
  final List<Widget> actions;
  final List<ButtonStyleButton> contents;

  final int crossAxisCount;
  final int mainAxisCount;

  const BaseModal({Key key, this.title, this.actions, this.contents, this.crossAxisCount = 3, this.mainAxisCount = 6}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      color: Color.fromRGBO(220, 220, 220, 1),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context){
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: pixelsToDP(context, 60),
      ),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: pixelsToDP(context, 60),
            ),
          ),
          Expanded(
            child: Container()
          ),
        ] + actions + [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              Navigator.of(context).pop();
            },
            color: Colors.white,
            iconSize: pixelsToDP(context, 90),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(){
    return LayoutBuilder(
      builder: (context, constraints){
        double aspectRatio = MediaQuery.of(context).size.width / constraints.maxHeight * mainAxisCount / crossAxisCount;

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            if (contents[index] != null) {
              return _buildButton(contents[index]);
            }
            else {
              return Container();
            }
          },
          itemCount: contents?.length ?? 0,
          shrinkWrap: true,
        );
      },
    );
  }

  Widget _buildButton(var _button){
    return TextButton(
      onPressed: _button.onPressed,
      child: FittedBox(child: _button.child),
      style: ButtonStyle(
        alignment: Alignment.center,
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.white
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          regularTextStyle,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.black
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(),
        ),
      ),
    );
  }
}