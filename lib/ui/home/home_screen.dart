import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tiktok_downloader/models/app_version_model.dart';
import 'package:tiktok_downloader/models/tiktok_validation_model.dart';
import 'package:tiktok_downloader/services/api_services.dart';
import 'package:tiktok_downloader/services/db_service.dart';
import 'package:tiktok_downloader/services/firebase_service.dart';
import 'package:tiktok_downloader/ui/history/bloc/save_video/save_video_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/ads_counter/ads_counter_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/app_version/app_version_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/download_file/download_file_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/download_video/download_video_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/get_data/get_data_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/validate_tiktok/validate_tiktok_cubit.dart';
import 'package:tiktok_downloader/utils/custom_dialog.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_downloader/utils/utils.dart';
import 'package:tiktok_downloader/widgets/tiktok_preview.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetDataCubit(ApiServices()),
        ),
        BlocProvider(
          create: (context) => DownloadVideoCubit(ApiServices()),
        ),
        BlocProvider(
          create: (context) => ValidateTiktokCubit(ApiServices()),
        ),
        BlocProvider(
          create: (context) =>
              AppVersionCubit(FirebaseService())..checkVersion(),
        ),
        BlocProvider(
          create: (context) => SaveVideoCubit(DbService()),
        ),
        BlocProvider(
          create: (context) => AdsCounterCubit(),
        ),
        BlocProvider(
          create: (context) => DownloadFileCubit(ApiServices()),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: const HomeView(),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final textEdc = TextEditingController();
  TiktokValidationModel? video;

  late String appVersion;

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String _version = packageInfo.version;
    setState(() {
      appVersion = _version;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<DownloadFileCubit>().registerPort();
  }

  @override
  void dispose() {
    super.dispose();
    ui.IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                RouteConstants.history,
              );
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GetDataCubit, GetDataState>(
            listener: (context, state) {
              if (state is GetDataLoading) {
                showLoadingDialog(context, text: 'Getting data..');
              }
              if (state is GetDataFailure) {
                Navigator.pop(context);
                showFailureDialog(context, text: state.msg);
              }
              if (state is GetDataSuccess) {
                Navigator.pop(context);
                context.read<DownloadFileCubit>().startDownload(state.url);
                // context.read<DownloadVideoCubit>().download(
                //       state.url,
                //     );
              }
            },
          ),
          BlocListener<ValidateTiktokCubit, ValidateTiktokState>(
            listener: (context, state) {
              if (state is ValidateTiktokLoading) {
                showLoadingDialog(context, text: 'Validating TikTok URL..');
              }
              if (state is ValidateTiktokFailure) {
                Navigator.pop(context);
                showFailureDialog(context, text: 'Make sure the URL is valid');
              }
              if (state is ValidateTiktokSuccess) {
                Navigator.pop(context);
                setState(() {
                  video = state.data;
                });
              }
            },
          ),
          BlocListener<AppVersionCubit, AppVersionState>(
            listener: (context, state) async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              String appVersion = packageInfo.version;
              if (state is AppVersionSuccess) {
                final data = state.data;
                final version = data.version;
                if (data.showUpdate!) {
                  if (version!.currentVersion != appVersion) {
                    showUpdateBottomSheet(data);
                  }
                }
              }
            },
          ),
          // BlocListener<DownloadVideoCubit, DownloadVideoState>(
          //   listener: (context, state) {
          //     if (state.hasErr) {
          //       showFailureDialog(context, text: state.err);
          //     }
          //     if (state.isDone) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text('Download video successfuly'),
          //           backgroundColor: Colors.green,
          //         ),
          //       );
          //       context.read<SaveVideoCubit>().saveVideo(
          //             TiktokValidationModel(
          //               type: video?.type,
          //               title: video?.title,
          //               authorUrl: video?.authorUrl,
          //               authorName: video?.authorName,
          //               thumbnailUrl: video?.thumbnailUrl,
          //               videoUrl: video?.videoUrl,
          //               videoPath: state.videoPath,
          //               createdAt: DateTime.now(),
          //             ),
          //           );
          //     }
          //   },
          // ),
          BlocListener<DownloadFileCubit, DownloadFileState>(
            listener: (context, state) {
              if (state.err != null) {
                print('DOWNLOAD BloC: ERR');
                showFailureDialog(context, text: state.err);
              }
              if (state.downloadStarted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Loading....'),
                  ),
                );
              }
              if (state.downloadDone) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Download video successfuly'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<SaveVideoCubit>().saveVideo(
                      TiktokValidationModel(
                        type: video?.type,
                        title: video?.title,
                        authorUrl: video?.authorUrl,
                        authorName: video?.authorName,
                        thumbnailUrl: video?.thumbnailUrl,
                        videoUrl: video?.videoUrl,
                        videoPath: state.filePath,
                        createdAt: DateTime.now(),
                      ),
                    );
                context.read<DownloadFileCubit>().openFile();
              }
            },
          ),
          BlocListener<AdsCounterCubit, int>(
            listener: (context, state) {
              if (state % 2 == 1) {
                /// show ads here
              }
            },
            child: Container(),
          )
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ValidateTiktokCubit, ValidateTiktokState>(
                builder: (context, state) {
                  if (state is ValidateTiktokSuccess &&
                      textEdc.text.isNotEmpty) {
                    final data = state.data;
                    return Column(
                      children: [
                        TikTokPreview(data: data),
                        const SizedBox(height: 32),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              Row(
                children: [
                  const Text('Paste your TikTok video link'),
                  const Spacer(),
                  textEdc.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            textEdc.clear();
                            setState(() {});
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: textEdc,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Drop your TikTok link here',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Paste Link'),
                      onPressed: () async {
                        ClipboardData? cdata = await Clipboard.getData(
                          Clipboard.kTextPlain,
                        );
                        String? copiedtext = cdata?.text;
                        if (copiedtext != null && copiedtext.isNotEmpty) {
                          textEdc.text = copiedtext;
                        }
                        context
                            .read<ValidateTiktokCubit>()
                            .validate(textEdc.text);
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  BlocBuilder<ValidateTiktokCubit, ValidateTiktokState>(
                    builder: (context, state) {
                      return Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: state is ValidateTiktokSuccess &&
                                  textEdc.text.isNotEmpty
                              ? () {
                                  // context.read<AdsCounterCubit>().increment();
                                  context
                                      .read<GetDataCubit>()
                                      .fetchData(textEdc.text);
                                }
                              : null,
                          child: const Text('Download'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Center(
              //   child: Container(
              //     alignment: Alignment.center,
              //     child: AdWidget(ad: myBanner),
              //     width: myBanner.size.width.toDouble(),
              //     height: myBanner.size.height.toDouble(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void showUpdateBottomSheet(AppVersionModel data) {
    showModalBottomSheet(
      context: context,
      isDismissible: !data.force!,
      enableDrag: !data.force!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      builder: (context) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello,',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'The latest version of our app is now available in playstore, please update your app.',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff333333),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Update now'),
                onPressed: () async {
                  Uri parsedUrl = Uri.parse(data.link!);
                  if (!await launchUrl(parsedUrl,
                      mode: LaunchMode.externalApplication)) {
                    showFailureDialog(context, text: 'Url cannot be opened');
                  }
                },
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}
