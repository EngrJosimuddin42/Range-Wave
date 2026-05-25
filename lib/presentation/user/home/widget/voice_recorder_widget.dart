import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';

class VoiceRecorderWidget extends StatefulWidget {
  /// Recording শেষ হলে file path পাঠাবে
  final ValueChanged<String>? onRecorded;

  const VoiceRecorderWidget({super.key, this.onRecorded});

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _recorderReady = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  // State
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedPath;

  // Timer & duration
  Timer? _timer;
  int _seconds = 0;

  // Fake waveform bars (amplitude simulation)
  final List<double> _bars = List.filled(30, 4.0);
  int _barIndex = 0;

  // ── Recorder Initialization ─────────────────────────────────────
  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
    setState(() => _recorderReady = true);
  }

  // ── Lifecycle ───────────────────────────────────────────────────
  @override
  void dispose() {
    _timer?.cancel();
    _recorder.closeRecorder();
    _player.dispose();
    super.dispose();
  }

  // ── Recording ──────────────────────────────────────────────────
  Future<void> _startRecording() async {
    if (!_recorderReady) return;

    final path =
        '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);

    _seconds = 0;
    _barIndex = 0;
    _bars.fillRange(0, _bars.length, 4.0);

    _timer = Timer.periodic(const Duration(milliseconds: 150), (_) async {
      final barH = 4.0 + ((_barIndex * 7) % 28).toDouble();
      if (mounted) {
        setState(() {
          _bars[_barIndex % _bars.length] = barH;
          _barIndex++;
          if (_barIndex % 7 == 0) _seconds++;
        });
      }
    });

    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _recorder.stopRecorder();
    if (path != null) {
      setState(() {
        _recordedPath = path;
        _isRecording = false;
      });
      widget.onRecorded?.call(path);
    }
  }

  // ── Playback ───────────────────────────────────────────────────
  Future<void> _togglePlay() async {
    if (_recordedPath == null) return;

    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      await _player.play(DeviceFileSource(_recordedPath!));
      setState(() => _isPlaying = true);
      _player.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _isPlaying = false);
      });
    }
  }

  // ── Re-record ─────────────────────────────────────────────────
  void _reset() {
    _player.stop();
    setState(() {
      _recordedPath = null;
      _isPlaying = false;
      _seconds = 0;
      _bars.fillRange(0, _bars.length, 4.0);
    });
  }

  // ── Helpers ───────────────────────────────────────────────────
  String get _durationText {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── UI ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (!_isRecording && _recordedPath == null) {
      return _MicButton(onTap: _startRecording);
    }

    return _PlayerBar(
      isRecording: _isRecording,
      isPlaying: _isPlaying,
      bars: _bars,
      barIndex: _barIndex,
      duration: _durationText,
      onPlayPause: _isRecording ? _stopRecording : _togglePlay,
      onConfirm: _recordedPath != null ? () {} : null, // প্রয়োজন হলে এখানে কনফার্ম অ্যাকশন দিতে পারেন
      onReset: _recordedPath != null ? _reset : null,
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Mic button (initial state)
// ════════════════════════════════════════════════════════════
class _MicButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MicButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 52.w,
        decoration: BoxDecoration(
          color: AppColors.blue.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.blue, width: 1.5),
        ),
        child: Icon(Icons.mic, color: AppColors.blue, size: 26.w),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Player bar (recording / playback)
// ════════════════════════════════════════════════════════════
class _PlayerBar extends StatelessWidget {
  final bool isRecording;
  final bool isPlaying;
  final List<double> bars;
  final int barIndex;
  final String duration;
  final VoidCallback onPlayPause;
  final VoidCallback? onConfirm;
  final VoidCallback? onReset;

  const _PlayerBar({
    required this.isRecording,
    required this.isPlaying,
    required this.bars,
    required this.barIndex,
    required this.duration,
    required this.onPlayPause,
    this.onConfirm,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPlayPause,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRecording
                    ? Icons.stop
                    : (isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
                size: 20.w,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: SizedBox(
              height: 32.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(bars.length, (i) {
                  final isActive = isRecording && i == barIndex % bars.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 80),
                    width: 2.5.w,
                    height: bars[i].h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.blue
                          : AppColors.blue.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            duration,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 8.w),
          if (onConfirm != null)
            GestureDetector(
              onTap: onConfirm,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.blue,
                  size: 18.w,
                ),
              ),
            ),
          if (onReset != null) ...[
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: onReset,
              child: Icon(
                Icons.refresh,
                size: 18.w,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}