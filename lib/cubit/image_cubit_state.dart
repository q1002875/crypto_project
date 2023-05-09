part of 'image_cubit_cubit.dart';

abstract class ImageCubitState extends Equatable {
  const ImageCubitState();

  @override
  List<Object> get props => [];
}

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final Image image;

  ImageLoaded({required this.image});
}

class ImageError extends ImageState {}
