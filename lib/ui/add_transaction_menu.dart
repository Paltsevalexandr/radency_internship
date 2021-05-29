import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/image_picker/image_picker_bloc.dart';
import 'package:radency_internship_project_2/blocs/import_csv/import_csv_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class AddTransactionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ImagePickerBloc imageBloc = BlocProvider.of<ImagePickerBloc>(context);

    return BlocBuilder<ImagePickerBloc, ImagePickerState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: pixelsToDP(context, 300)),
          child: SimpleDialog(
            contentPadding: EdgeInsets.all(0),
            backgroundColor: Color.fromRGBO(0, 0, 0, 0),
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(pixelsToDP(context, 20)),
                  color: Colors.white),
                child: Column(
                  children: createMenuItems(imageBloc, context))
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: pixelsToDP(context, 20)),
                  padding: EdgeInsets.all(pixelsToDP(context, 30)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(pixelsToDP(context, 20)),
                    color: Colors.white
                  ),
                  child: Text(S.current.cancel, style: TextStyle(fontSize: pixelsToDP(context, 50))),
                ),
                onTap: () => Navigator.pop(context)
              )]
          ));
      }      
    );
  }

  List<Widget> createMenuItems(imageBloc, context) {
    ImportCsvBloc importCsvBloc = BlocProvider.of<ImportCsvBloc>(context);
    return [
      Container(alignment: Alignment.center,
        padding: EdgeInsets.only(top: pixelsToDP(context, 20), bottom: pixelsToDP(context, 10)),
        child: Text(S.current.addTransaction, style: TextStyle(fontSize: pixelsToDP(context, 60)))),
      Divider(color: Colors.grey[350], thickness: pixelsToDP(context, 8)),
      ListTile(
        onTap: () => Navigator.of(context).pushNamed(Routes.addTransactionPage),
        title: Text(S.current.form, style: TextStyle(fontSize: pixelsToDP(context, 50)))),
      Divider(color: Colors.grey[350], thickness: pixelsToDP(context, 6)),
      ListTile(
        onTap: () => imageBloc.add(ImageFromGallery()),
        title: Text(S.current.gallery, style: TextStyle(fontSize: pixelsToDP(context, 50)))),
      Divider(color: Colors.grey[350], thickness: pixelsToDP(context, 6)),
      ListTile(
        onTap: () => imageBloc.add(ImageFromCamera()),
        title: Text(S.current.camera, style: TextStyle(fontSize: pixelsToDP(context, 50)))),
      Divider(color: Colors.grey[350], thickness: pixelsToDP(context, 6)),
      ListTile(
          onTap: () => importCsvBloc.add(ImportCsvFile()),
          title: Text(S.current.importCsv, style: TextStyle(fontSize: pixelsToDP(context, 50)))),
    ];
  }
}