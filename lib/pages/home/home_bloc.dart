import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../helper/debouncer.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with HydratedMixin {
  final _debouncer = Debouncer(milliseconds: 500);

  HomeBloc() : super(const HomeState()) {
    hydrate();
    on<HomeEvent>((event, emit) {});
    on<HomeQrCodeDataEntered>((event, emit) {
      emit(state.copyWith(qrCodeData: event.qrCodeData));
      _debouncer.run(() {
        FirebaseAnalytics.instance.logEvent(
          name: 'record_entered',
          parameters: {
            'data': event.qrCodeData,
          },
        );
      });
    });
    on<HomeQrCodeDataRecordAdded>((event, emit) {
      Set<String> qrCodeHistories = state.qrCodeHistories.toSet();
      qrCodeHistories.add(event.qrCodeData);
      emit(state.copyWith(qrCodeHistories: qrCodeHistories.toList()));
      FirebaseAnalytics.instance.logEvent(
        name: 'record_added',
        parameters: {
          'data': event.qrCodeData,
        },
      );
    });
    on<HomeQrCodeDataRecordSelected>((event, emit) {
      emit(state.copyWith(qrCodeData: event.qrCodeData));
      FirebaseAnalytics.instance.logEvent(
        name: 'record_selected',
        parameters: {
          'data': event.qrCodeData,
        },
      );
    });
    on<HomeQrCodeDataRecordRemoved>((event, emit) {
      Set<String> qrCodeHistories = state.qrCodeHistories.toSet();
      qrCodeHistories.remove(event.qrCodeData);
      emit(state.copyWith(qrCodeHistories: qrCodeHistories.toList()));
      FirebaseAnalytics.instance.logEvent(
        name: 'record_removed',
        parameters: {
          'data': event.qrCodeData,
        },
      );
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
