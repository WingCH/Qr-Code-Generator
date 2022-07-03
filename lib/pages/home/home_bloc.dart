import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with HydratedMixin {
  HomeBloc() : super(const HomeState()) {
    hydrate();
    on<HomeEvent>((event, emit) {});
    on<HomeQrCodeDataEntered>((event, emit) {
      emit(state.copyWith(qrCodeData: event.qrCodeData));
    });
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return HomeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return state.toJson();
  }
}
