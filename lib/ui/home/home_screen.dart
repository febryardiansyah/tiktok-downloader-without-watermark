import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_downloader/models/app_version_model.dart';
import 'package:tiktok_downloader/services/api_services.dart';
import 'package:tiktok_downloader/services/firebase_service.dart';
import 'package:tiktok_downloader/ui/home/bloc/app_version/app_version_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/download_video/download_video_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/get_data/get_data_cubit.dart';
import 'package:tiktok_downloader/ui/home/bloc/validate_tiktok/validate_tiktok_cubit.dart';
import 'package:tiktok_downloader/utils/custom_dialog.dart';
import 'package:flutter/services.dart';
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
              // Navigator.pushNamed(
              //   context,
              //   RouteConstants.history,
              // );
              showFailureDialog(
                context,
                text: 'This feature will be added later!',
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
                context.read<DownloadVideoCubit>().download(state.url);
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
              }
            },
          ),
          BlocListener<AppVersionCubit, AppVersionState>(
            listener: (context, state) {
              if (state is AppVersionSuccess) {
                final data = state.data;
                final version = data.version;
                if (version!.currentVersion != version.newVersion) {
                  showUpdateBottomSheet(data);
                }
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     showFailureDialog(context);
              //   },
              //   child: Text('TEST'),
              // ),
              BlocBuilder<ValidateTiktokCubit, ValidateTiktokState>(
                builder: (context, state) {
                  if (state is ValidateTiktokSuccess &&
                      textEdc.text.isNotEmpty) {
                    final data = state.data;
                    return Stack(
                      children: [
                        Column(
                          children: [
                            TikTokPreview(data: data),
                            const SizedBox(height: 32),
                          ],
                        ),
                        BlocBuilder<DownloadVideoCubit, DownloadVideoState>(
                          builder: (context, state) {
                            if (state.isDownloading) {
                              return Container(
                                height: 114,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const CircularProgressIndicator(),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      state.progressString,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                        )
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
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: state is ValidateTiktokSuccess &&
                                  textEdc.text.isNotEmpty
                              ? () {
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
