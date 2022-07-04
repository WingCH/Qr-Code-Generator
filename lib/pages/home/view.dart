import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => HomeBloc(),
      child: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  late TextEditingController _qrCodeDataController;
  final _qrCodeDataFocusNode = FocusNode();

  @override
  void initState() {
    final initData = context.read<HomeBloc>().state.qrCodeData;
    _qrCodeDataController = TextEditingController(text: initData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qr Code Generator')),
      body: BlocListener<HomeBloc, HomeState>(
        listenWhen: (previous, current) =>
            previous.qrCodeData != current.qrCodeData,
        listener: (context, state) {
          if (state.qrCodeData != _qrCodeDataController.text) {
            _qrCodeDataController.text = state.qrCodeData;
          }
        },
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                BlocSelector<HomeBloc, HomeState, String>(
                  selector: (state) {
                    return state.qrCodeData;
                  },
                  builder: (context, qrCodeData) {
                    return QrImage(
                      data: qrCodeData,
                      version: QrVersions.auto,
                      size: 200.0,
                    );
                  },
                ),
                TextField(
                  controller: _qrCodeDataController,
                  focusNode: _qrCodeDataFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Enter a string',
                  ),
                  onChanged: (value) {
                    context.read<HomeBloc>().add(HomeQrCodeDataEntered(value));
                  },
                  onSubmitted: (value) {
                    context
                        .read<HomeBloc>()
                        .add(HomeQrCodeDataRecordAdded(value));
                    _qrCodeDataFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('History',
                        style: Theme.of(context).textTheme.headline6),
                    const SizedBox(height: 8),
                    BlocSelector<HomeBloc, HomeState, List<String>>(
                      selector: (state) {
                        return state.qrCodeHistories;
                      },
                      builder: (context, qrCodeHistories) {
                        return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runSpacing: 8,
                          spacing: 8,
                          children: [
                            ...qrCodeHistories.map((qrCodeData) {
                              return InputChip(
                                label: Text(qrCodeData),
                                onPressed: () {
                                  context.read<HomeBloc>().add(
                                      HomeQrCodeDataRecordSelected(qrCodeData));
                                },
                                onDeleted: () {
                                  context.read<HomeBloc>().add(
                                      HomeQrCodeDataRecordRemoved(qrCodeData));
                                },
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
