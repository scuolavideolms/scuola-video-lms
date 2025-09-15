import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PodVideoPlayerDev extends StatelessWidget {
  final String type;
  final String url;

  const PodVideoPlayerDev(this.url, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    if (type == 'youtube') {
      return VideoPlayerWidget(videoUrl: url);
    } else {
      return PodPlayerWrapper(type: type, url: url);
    }
  }
}

class PodPlayerWrapper extends StatefulWidget {
  final String type;
  final String url;

  const PodPlayerWrapper({required this.url, required this.type, super.key});

  @override
  State<PodPlayerWrapper> createState() => _PodPlayerWrapperState();
}

class _PodPlayerWrapperState extends State<PodPlayerWrapper> {
  late PodPlayerController controller;

  @override
  void initState() {
    super.initState();

    const qualityPrefs = [720, 480, 360];

    controller = PodPlayerController(
      playVideoFrom: widget.type == 'vimeo'
          ? PlayVideoFrom.vimeo(widget.url)
          : PlayVideoFrom.network(widget.url),
      podPlayerConfig: PodPlayerConfig(
        autoPlay: true,
        videoQualityPriority: qualityPrefs,
      ),
    );

    controller.initialise().catchError((e) {
      debugPrint("Error initializing PodPlayerController: $e");
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: PodVideoPlayer(controller: controller),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl, super.key});

  String? extractVideoId(String url) {
    Uri uri = Uri.parse(url);

    if (uri.host.contains("youtube.com")) {
      return uri.queryParameters['v'];
    }

    if (uri.host.contains("youtu.be")) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final videoId = extractVideoId(videoUrl);
    if (videoId == null) {
      return const Center(child: Text("Invalid YouTube URL"));
    }

    final embedUrl =
        "https://www.youtube.com/embed/$videoId?autoplay=1&controls=1&rel=0";

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(embedUrl)),
          initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(useHybridComposition: true),
            ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
          ),
        ),
      ),
    );
  }
}