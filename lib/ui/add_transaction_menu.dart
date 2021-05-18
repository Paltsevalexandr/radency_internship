import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/image_picker/image_picker_bloc.dart';
import 'dart:ui';
import 'package:radency_internship_project_2/utils/ui_utils.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:radency_internship_project_2/blocs/import_csv/import_csv_bloc.dart';

class AddTransactionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ImagePickerBloc imageBloc = BlocProvider.of<ImagePickerBloc>(context);

    return BlocBuilder<ImagePickerBloc, ImagePickerState>(
      builder: (context, state) {
        return SimpleDialog(
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
                margin: EdgeInsets.only(top: pixelsToDP(context, 15)),
                padding: EdgeInsets.all(pixelsToDP(context, 15)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(pixelsToDP(context, 20)),
                  color: Colors.white
                ),
                child: Text(S.current.cancel, style: TextStyle(fontSize: pixelsToDP(context, 60))),
              ),
              onTap: () => Navigator.pop(context)
            )
          ]
        );
      }      
    );
  }

List<Widget> createMenuItems(imageBloc, context) {
  return [
    ListTile(
      onTap: () => Navigator.pushNamed(context, Routes.addTransactionPage), 
      title: Text(S.current.form, style: TextStyle(fontSize: pixelsToDP(context, 34)))),
    Divider(color: Colors.grey),
    ListTile(
      onTap: () => imageBloc.add(ImageFromGallery()), 
      title: Text(S.current.gallery, style: TextStyle(fontSize: pixelsToDP(context, 34)))),
    Divider(color: Colors.grey),
    ListTile(
      onTap: () => imageBloc.add(ImageFromCamera()), 
      title: Text(S.current.camera, style: TextStyle(fontSize: pixelsToDP(context, 34)))),
    Divider(color: Colors.grey),
    BlocBuilder<ImportCsvBloc, ImportCsvState>(
      builder: (context, importCsvState) {
        ImportCsvBloc importCsvBloc = context.read<ImportCsvBloc>();

        return ListTile(
          onTap: () => importCsvBloc.add(ImportCsvFile()),
          title: Text(S.current.import_csv, style: TextStyle(fontSize: pixelsToDP(context, 34))),
        );
      })
  ];
  }
}