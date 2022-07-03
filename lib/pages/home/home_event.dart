part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeQrCodeDataEntered extends HomeEvent {
  final String qrCodeData;

  const HomeQrCodeDataEntered(this.qrCodeData);

  @override
  List<Object> get props => [qrCodeData];
}
