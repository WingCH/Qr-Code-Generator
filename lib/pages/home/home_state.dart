part of 'home_bloc.dart';

@immutable
class HomeState extends Equatable {
  final String qrCodeData;
  final List<String> qrCodeHistories;

  const HomeState({
    this.qrCodeData = '',
    this.qrCodeHistories = const [],
  });

  HomeState copyWith({
    String? qrCodeData,
    List<String>? qrCodeHistories,
  }) {
    return HomeState(
      qrCodeData: qrCodeData ?? this.qrCodeData,
      qrCodeHistories: qrCodeHistories ?? this.qrCodeHistories,
    );
  }

  factory HomeState.fromJson(Map<String, dynamic> json) {
    return HomeState(
      qrCodeData: json['qrCodeData'] as String,
      qrCodeHistories: json['qrCodeHistories'] == null
          ? []
          : List<String>.from(json['qrCodeHistories'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrCodeData': qrCodeData,
      'qrCodeHistories': List<String>.from(qrCodeHistories.map((x) => x)),
    };
  }

  @override
  List<Object?> get props => [qrCodeData, qrCodeHistories];
}
