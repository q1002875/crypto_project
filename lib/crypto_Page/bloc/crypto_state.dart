part of 'crypto_bloc.dart';

class CryptoFailLoad extends CryptoState {}

class CryptoInitial extends CryptoState {}

class CryptoLoaded extends CryptoState {}

class CryptoLoading extends CryptoState {}

abstract class CryptoState extends Equatable {
  const CryptoState();
  @override
  List<Object> get props => [];
}
