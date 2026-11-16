
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const SmartCutApp());
}

class SmartCutApp extends StatelessWidget {
  const SmartCutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMARTCUT AI',
      theme: ThemeData.dark(),
      home: const EditorHome(),
    );
  }
}

class EditorHome extends StatefulWidget {
  const EditorHome({super.key});

  @override
  State<EditorHome> createState() => _EditorHomeState();
}

class _EditorHomeState extends State<EditorHome> {
  VideoPlayerController? controller;
  String language = 'Kannada';
  String format = '9:16 Reels';
  bool silence = true;
  bool captions = true;
  bool music = false;

  Future<void> pickVideo() async {
    final file = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (file == null) return;

    final video = VideoPlayerController.file(File(file.path));
    await video.initialize();
    await controller?.dispose();

    setState(() {
      controller = video;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMARTCUT AI ✨'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'AI VIDEO EDITOR',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 220,
            color: Colors.black,
            child: controller == null
                ? const Center(
                    child: Icon(
                      Icons.video_library,
                      size: 70,
                      color: Colors.white,
                    ),
                  )
                : AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: pickVideo,
            icon: const Icon(Icons.add),
            label: const Text('SELECT VIDEO'),
          ),
          if (controller != null)
            IconButton(
              onPressed: () {
                setState(() {
                  controller!.value.isPlaying
                      ? controller!.pause()
                      : controller!.play();
                });
              },
              icon: const Icon(Icons.play_arrow),
            ),
          const Divider(),
          const Text(
            'AI EDITING OPTIONS',
            style: TextStyle(fontSize: 20),
          ),
          SwitchListTile(
            title: const Text('Remove Silence'),
            value: silence,
            onChanged: (v) => setState(() => silence = v),
          ),
          SwitchListTile(
            title: const Text('Auto Captions'),
            value: captions,
            onChanged: (v) => setState(() => captions = v),
          ),
          SwitchListTile(
            title: const Text('Background Music'),
            value: music,
            onChanged: (v) => setState(() => music = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: language,
            decoration: const InputDecoration(
              labelText: 'Video Language',
            ),
            items: [
              'Kannada',
              'English',
              'Hindi',
              'Tamil',
              'Telugu',
            ].map((v) => DropdownMenuItem(
              value: v,
              child: Text(v),
            )).toList(),
            onChanged: (v) => setState(() => language = v!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: format,
            decoration: const InputDecoration(
              labelText: 'Output Format',
            ),
            items: [
              '9:16 Reels',
              '16:9 YouTube',
              '1:1 Square',
            ].map((v) => DropdownMenuItem(
              value: v,
              child: Text(v),
            )).toList(),
            onChanged: (v) => setState(() => format = v!),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('SMARTCUT AI'),
                  content: const Text(
                    'AI editing features will be added '
                    'in future versions.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('START AI EDIT'),
          ),
        ],
      ),
    );
  }
}
