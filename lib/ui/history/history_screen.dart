import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_downloader/services/db_service.dart';
import 'package:tiktok_downloader/ui/history/bloc/get_saved_video/get_saved_video_cubit.dart';
import 'package:tiktok_downloader/widgets/tiktok_preview.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetSavedVideoCubit(DbService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          backgroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: HistoryView(),
      ),
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
    return BlocBuilder<GetSavedVideoCubit, GetSavedVideoState>(
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
          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, i) {
              final item = data[i];
              return TikTokPreview(
                data: item,
                onTap: () {},
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
