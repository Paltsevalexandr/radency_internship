import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitial(null));

  Future<ImagePickerState> getImageFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.getImage(source: ImageSource.gallery);

    if(image != null) {
      return LoadedImage(File(image.path));
    }
    else {
      return LoadedImage(null);
    }
  }

  Future<ImagePickerState> getImageFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.getImage(source: ImageSource.camera);

    if(image != null) {
      return LoadedImage(File(image.path));
    }
    else {
      return LoadedImage(null);
    }
  }

  @override
  Stream<ImagePickerState> mapEventToState(
    ImagePickerEvent event,
  ) async* {
      if(event is ImageFromGallery) {
        yield await getImageFromGallery();
      
      }else if(event is ImageFromCamera) {
        yield await getImageFromGallery();
      }
  }
}
