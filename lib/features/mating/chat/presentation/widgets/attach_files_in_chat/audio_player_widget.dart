import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:squeak/generated/l10n.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final Color? primaryColor;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.isMe,
    this.primaryColor,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = false;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _loadAudioDuration();
  }

  Future<void> _loadAudioDuration() async {
    try {
      await _audioPlayer.setSource(UrlSource(widget.audioUrl));
    } catch (e) {
      debugPrint('❌ Error loading audio duration: $e');
    }
  }

  void _initializePlayer() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _playerStateSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isLoading) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });

        if (_position == Duration.zero) {
          await _audioPlayer.play(UrlSource(widget.audioUrl));
        } else {
          await _audioPlayer.resume();
        }

        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error playing audio: $e');
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play audio'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressValue =
        _duration.inMilliseconds > 0
            ? _position.inMilliseconds / _duration.inMilliseconds
            : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              widget.isMe
                  ? [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ]
                  : [
                    (widget.primaryColor ?? theme.colorScheme.primary)
                        .withOpacity(0.15),
                    (widget.primaryColor ?? theme.colorScheme.primary)
                        .withOpacity(0.05),
                  ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    widget.isMe
                        ? Colors.white.withOpacity(0.3)
                        : (widget.primaryColor ?? theme.colorScheme.primary)
                            .withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child:
                  _isLoading
                      ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              widget.isMe
                                  ? Colors.white
                                  : (widget.primaryColor ??
                                      theme.colorScheme.primary),
                        ),
                      )
                      : Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color:
                            widget.isMe
                                ? Colors.white
                                : (widget.primaryColor ??
                                    theme.colorScheme.primary),
                        size: 20,
                      ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor:
                              widget.isMe
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.isMe
                                ? Colors.white
                                : (widget.primaryColor ??
                                    theme.colorScheme.primary),
                          ),
                          minHeight: 3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _duration.inMilliseconds > 0
                          ? '${_formatDuration(_position)} / ${_formatDuration(_duration)}'
                          : '00:00',
                      style: TextStyle(
                        color:
                            widget.isMe
                                ? Colors.white.withOpacity(0.8)
                                : theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.audiotrack_rounded,
                      color:
                          widget.isMe
                              ? Colors.white.withOpacity(0.7)
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      S.of(context).audioFile,
                      style: TextStyle(
                        color:
                            widget.isMe
                                ? Colors.white.withOpacity(0.7)
                                : theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                    if (_duration.inMilliseconds > 0) ...[
                      Text(
                        ' • ${_formatDuration(_duration)}',
                        style: TextStyle(
                          color:
                              widget.isMe
                                  ? Colors.white.withOpacity(0.7)
                                  : theme.colorScheme.onSurface.withOpacity(
                                    0.6,
                                  ),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
