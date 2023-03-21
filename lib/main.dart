import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_downloader/firebase_options.dart';
import 'package:tiktok_downloader/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tiktok Downloader',
      onGenerateRoute: generateRoute,
      initialRoute: RouteConstants.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: downloadFile,
              child: Text('Download'),
            ),
            loading
                ? Center(
                    child: Text('Getting data...'),
                  )
                : Center(),
            downloading
                ? Container(
                    height: 120.0,
                    width: 200.0,
                    child: Card(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const CircularProgressIndicator(),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Downloading File: $progressString",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const Text("No Data"),
            Html(
              data: '''
<blockquote class="tiktok-embed" cite="https://www.tiktok.com/@ironsenpaitt/video/7197295707903020314" data-video-id="7197295707903020314" data-embed-from="oembed" style="max-width: 605px;min-width: 325px;" > <section> <a target="_blank" title="@ironsenpaitt" href="https://www.tiktok.com/@ironsenpaitt?refer=embed">@ironsenpaitt</a> <p>Nerf Stinger di update Valorant patch 6.02 <a title="valorant" target="_blank" href="https://www.tiktok.com/tag/valorant?refer=embed">#valorant</a> <a title="valorantclips" target="_blank" href="https://www.tiktok.com/tag/valorantclips?refer=embed">#valorantclips</a> <a title="valorantindonesia" target="_blank" href="https://www.tiktok.com/tag/valorantindonesia?refer=embed">#valorantindonesia</a> <a title="valorantnews" target="_blank" href="https://www.tiktok.com/tag/valorantnews?refer=embed">#valorantnews</a> <a title="fypindonesia" target="_blank" href="https://www.tiktok.com/tag/fypindonesia?refer=embed">#fypindonesia</a> <a title="fyp" target="_blank" href="https://www.tiktok.com/tag/fyp?refer=embed">#fyp</a> </p> <a target="_blank" title="♬ original sound - Iron Senpai - Iron Senpai" href="https://www.tiktok.com/music/original-sound-Iron-Senpai-7197295712994954011?refer=embed">♬ original sound - Iron Senpai - Iron Senpai</a> </section> </blockquote> <script async src="https://www.tiktok.com/embed.js"></script>''',
            ),
          ],
        ),
      ),
    );
  }

  bool downloading = false;
  var progressString = "";
  bool loading = false;

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      final permissionStatus = await Permission.manageExternalStorage.request();

      if (permissionStatus.isGranted) {
        var dir = Directory('/sdcard/download/');
        setState(() {
          loading = true;
        });
        final tiktokResponse = await dio.post(
          'https://downloader-api.febryardiansyah.my.id/api/tiktok',
          data: {
            "url":
                "https://www.tiktok.com/@sen.elevenz/video/7197737838627114242?is_from_webapp=1&sender_device=pc",
          },
        );
        print('DATA ${tiktokResponse.data['data']['no_wm']}');
        await dio.download(
          "${tiktokResponse.data['data']['no_wm']}",
          "${dir.path}/demo.mp4",
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total");

            setState(() {
              loading = false;
              downloading = true;
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          },
        );
        if (!await File("${dir.path}/demo.mp4").exists()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FILE TIDAK ADA')),
          );
          return;
        }
        final open = await OpenFilex.open("${dir.path}/demo.mp4");
        print("OPEN RESULT: ${open.message}");
        setState(() {
          downloading = false;
          progressString = "Completed";
        });
        print("Download completed");
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
        downloading = false;
        progressString = "Failure: $e";
      });
    }
  }
}
