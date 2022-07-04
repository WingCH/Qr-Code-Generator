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

class HomeQrCodeDataRecordAdded extends HomeEvent {
  final String qrCodeData;

  const HomeQrCodeDataRecordAdded(this.qrCodeData);

  @override
  List<Object> get props => [qrCodeData];
}

class HomeQrCodeDataRecordSelected extends HomeEvent {
  final String qrCodeData;

  const HomeQrCodeDataRecordSelected(this.qrCodeData);

  @override
  List<Object> get props => [qrCodeData];
}

class HomeQrCodeDataRecordRemoved extends HomeEvent {
  final String qrCodeData;

  const HomeQrCodeDataRecordRemoved(this.qrCodeData);

  @override
  List<Object> get props => [qrCodeData];
}
