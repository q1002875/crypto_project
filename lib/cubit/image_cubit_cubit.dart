
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
part 'image_cubit_state.dart';


class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageInitial());

  Future<void> loadImage(String imageUrl) async {
    try {
      emit(ImageLoading());

      final modifiedUrl = _modifyImageUrl(imageUrl);
      final response = await http.get(Uri.parse(modifiedUrl));

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        final image = Image.memory(imageBytes);

        emit(ImageLoaded(image: image));
      } else {
        emit(ImageError());
      }
    } catch (_) {
      emit(ImageError());
    }
  }

  String _modifyImageUrl(String imageUrl) {
    final uri = Uri.parse(imageUrl);
    final uriWithoutQueryParams = uri.replace(queryParameters: {});
    return uriWithoutQueryParams.toString();
  }
}




