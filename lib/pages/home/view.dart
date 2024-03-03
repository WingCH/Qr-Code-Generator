import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:seo_renderer/seo_renderer.dart';
import "dart:js" as js;
import 'dart:convert';

import 'home_bloc.dart';
import 'screenshot_capture_view.dart';
import 'widgets/qr_code_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
  var onHover = false;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    final initData = context.read<HomeBloc>().state.qrCodeData;
    _qrCodeDataController = TextEditingController(text: initData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Theme.of(context).colorScheme.primary),
          title: const TextRenderer(
            style: TextRendererStyle.header1,
            child: Text('Qr Code Generator'),
          ),
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) => previous.qrCodeData != current.qrCodeData,
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
                  TextRenderer(
                    text: 'Qr Code image',
                    style: TextRendererStyle.header2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocSelector<HomeBloc, HomeState, String>(
                        selector: (state) {
                          return state.qrCodeData;
                        },
                        builder: (context, qrCodeData) {
                          return InkWell(
                            onHover: (isHovering) {
                              setState(() {
                                onHover = isHovering;
                              });
                            },
                            onTap: () async {
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              try {
                                final Uint8List image = await screenshotController.captureFromLongWidget(
                                  ScreenshotCaptureView(
                                    qrCodeData: qrCodeData,
                                    qrCodeColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                  context: context,
                                  pixelRatio: 3,
                                  constraints: const BoxConstraints(maxHeight: 1000),
                                  delay: const Duration(milliseconds: 100),
                                );
                                final base64Image = base64Encode(image);
                                js.context.callMethod('copyBase64ImageToClipboard', [base64Image]);
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard'),
                                  ),
                                );
                              } catch (error, _) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                  ),
                                );
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                QrCodeView(
                                  qrCodeData: qrCodeData,
                                ),
                                AnimatedOpacity(
                                  opacity: onHover ? 1 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Text('Tap to copy',
                                      style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Theme.of(context).colorScheme.inverseSurface,
                                            blurRadius: 10,
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // BlocSelector<HomeBloc, HomeState, String>(
                  //   selector: (state) {
                  //     return state.qrCodeData;
                  //   },
                  //   builder: (context, qrCodeData) {
                  //     return ScreenshotCaptureView(qrCodeData: qrCodeData);
                  //   },
                  // ),
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
                      context.read<HomeBloc>().add(HomeQrCodeDataRecordAdded(value));
                      _qrCodeDataFocusNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextRenderer(
                    text: 'Qr Code History',
                    style: TextRendererStyle.header3,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('History', style: Theme.of(context).textTheme.titleLarge),
                          Text('save in local storage', style: Theme.of(context).textTheme.titleMedium),
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior().copyWith(scrollbars: false),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: BlocSelector<HomeBloc, HomeState, List<String>>(
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
                                              label: Text(
                                                qrCodeData,
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              onPressed: () {
                                                context.read<HomeBloc>().add(HomeQrCodeDataRecordSelected(qrCodeData));
                                              },
                                              onDeleted: () {
                                                context.read<HomeBloc>().add(HomeQrCodeDataRecordRemoved(qrCodeData));
                                              },
                                            );
                                          }),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
