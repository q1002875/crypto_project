part of 'calculate_bloc_bloc.dart';

class CalculateBlocError extends CalculateBlocState {}

class CalculateBlocInitial extends CalculateBlocState {}

class CalculateBlocLoaded extends CalculateBlocState {
  final List<SymbolCase> symbolcase;
  const CalculateBlocLoaded({required this.symbolcase});
  @override
  List<Object> get props => [symbolcase];
}

class CalculateBlocLoading extends CalculateBlocState {}

abstract class CalculateBlocState extends Equatable {
  const CalculateBlocState();

  @override
  List<Object> get props => [];
}

class CalculatePressed extends CalculateBlocState {
  final List<String> outputCase;
  const CalculatePressed({required this.outputCase});
  @override
  List<Object> get props => [outputCase];
}

class CalculateUpDownLoaded extends CalculateBlocState {
  final List<SymbolCase> symbolcase;
  final List<String> outputList;
  const CalculateUpDownLoaded(
      {required this.symbolcase, required this.outputList});
  @override
  List<Object> get props => [symbolcase];
}
