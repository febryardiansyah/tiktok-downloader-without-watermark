import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiktok_downloader/models/tiktok_validation_model.dart';
import 'package:tiktok_downloader/services/db_service.dart';
import 'package:tiktok_downloader/ui/history/bloc/get_saved_video/get_saved_video_cubit.dart';
import 'package:tiktok_downloader/ui/history/bloc/remove_from_history/remove_from_history_cubit.dart';
import 'package:tiktok_downloader/ui/history/bloc/remove_video/remove_video_cubit.dart';
import 'package:tiktok_downloader/utils/custom_dialog.dart';
import 'package:tiktok_downloader/widgets/tiktok_preview.dart';
import 'package:cross_file/cross_file.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetSavedVideoCubit(DbService()),
        ),
        BlocProvider(
          create: (_) => RemoveVideoCubit(DbService()),
        ),
        BlocProvider(
          create: (_) => RemoveFromHistoryCubit(DbService()),
        ),
      ],
      child: HistoryView(),
    );
  }
}

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    context.read<GetSavedVideoCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.black,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.delete),
        //   ),
        // ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RemoveVideoCubit, RemoveVideoState>(
            listener: (context, state) {
              if (state is RemoveVideoLoading) {
                showLoadingDialog(context);
              }
              if (state is RemoveVideoFailure) {
                Navigator.pop(context);
                showFailureDialog(context, text: state.msg);
              }
              if (state is RemoveVideoSuccess) {
                Navigator.pop(context);
                context.read<GetSavedVideoCubit>().fetchData();
              }
            },
          ),
          BlocListener<RemoveFromHistoryCubit, RemoveFromHistoryState>(
            listener: (context, state) {
              if (state is RemoveFromHistoryLoading) {
                showLoadingDialog(context);
              }
              if (state is RemoveFromHistoryFailure) {
                Navigator.pop(context);
                showFailureDialog(context, text: state.msg);
              }
              if (state is RemoveFromHistorySuccess) {
                Navigator.pop(context);
                context.read<GetSavedVideoCubit>().fetchData();
              }
            },
          ),
        ],
        child: BlocBuilder<GetSavedVideoCubit, GetSavedVideoState>(
          builder: (context, state) {
            if (state is GetSavedVideoLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetSavedVideoFailure) {
              return Center(
                child: Text(state.msg),
              );
            }
            if (state is GetSavedVideoSuccess) {
              final data = state.data;
              if (data.isEmpty) {
                return Center(
                  child: Text('No History yet'),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, i) {
                  final item = data[i];
                  return GestureDetector(
                    onTap: () async {
                      try {
                        final result = await OpenFilex.open(item.videoPath);
                        if(result.type == ResultType.fileNotFound){
                          showFailureDialog(context,text: "File does not exist");
                          return;
                        }
                        log(
                          '${result.type}: ${item.videoPath}',
                          name: 'OPEN_FILE_RESULT_TYPE',
                        );
                      } catch (e) {
                        log(
                          'ERROR: $e',
                          name: 'OPEN_FILE_RESULT_TYPE',
                        );
                        showFailureDialog(context,text: "$e");
                      }
                    },
                    child: TikTokPreview(
                      data: item,
                      onTap: () {
                        showMore(item);
                      },
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void showMore(TiktokValidationModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
            SizedBox(height: 12),
            // ListTile(
            //   leading: Icon(Icons.open_in_browser),
            //   title: Text('Open video in TikTok'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.link),
            //   title: Text('Copy tiktok video url'),
            //   onTap: () {},
            // ),
            ListTile(
              leading: Icon(Icons.remove_circle_outline),
              title: Text('Remove from history'),
              onTap: () {
                print(item.videoPath);
                Navigator.pop(context);
                context.read<RemoveFromHistoryCubit>().remove(item.videoPath!);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete video'),
              onTap: () {
                print(item.videoPath);
                Navigator.pop(context);
                context.read<RemoveVideoCubit>().removeVideo(item.videoPath!);
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.share),
            //   title: Text('Share video'),
            //   onTap: () async {
            //     try {
            //       Navigator.pop(context);
            //       final file = File(item.videoPath!);
            //       if (!await file.exists()) {
            //         showFailureDialog(context, text: "File does not exist");
            //         return;
            //       }

            //       print("PATH ${item.videoPath}");
            //       Share.shareXFiles(
            //         [XFile('${file.path}')],
            //         text: "I have a nice video, check this out",
            //       );
            //     } catch (e) {
            //       print("SHARE ERR: $e");
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
