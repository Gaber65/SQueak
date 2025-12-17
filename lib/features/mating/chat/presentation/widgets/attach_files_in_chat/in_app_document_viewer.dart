import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:squeak/generated/l10n.dart';

class InAppDocumentViewer extends StatefulWidget {
  final String documentUrl;
  final String fileName;

  const InAppDocumentViewer({
    super.key,
    required this.documentUrl,
    required this.fileName,
  });

  @override
  State<InAppDocumentViewer> createState() => _InAppDocumentViewerState();
}

class _InAppDocumentViewerState extends State<InAppDocumentViewer> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final viewerUrl = _getViewerUrl();

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: Text(
          widget.fileName,
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _webViewController?.reload();
            },
            tooltip: S.of(context).refresh,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).documentLoadingFailed,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isLoading = true;
                        });
                        _webViewController?.reload();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(S.of(context).retry),
                    ),
                  ],
                ),
              ),
            )
          else
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(viewerUrl)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useOnLoadResource: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowFileAccessFromFileURLs: true,
                allowUniversalAccessFromFileURLs: true,
                supportZoom: true,
                builtInZoomControls: true,
                displayZoomControls: false,
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  _isLoading = false;
                });
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              onLoadError: (controller, url, code, message) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = message;
                });
                debugPrint('❌ WebView load error: $code - $message');
              },
              onLoadHttpError: (controller, url, statusCode, description) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = 'HTTP $statusCode: $description';
                });
                debugPrint('❌ WebView HTTP error: $statusCode - $description');
              },
            ),
          if (_isLoading && _errorMessage == null)
            Container(
              color: (isDark ? Colors.grey[900] : Colors.white)?.withOpacity(
                0.9,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _progress > 0 ? _progress : null,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${S.of(context).loading}... ${(_progress * 100).toInt()}%',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getViewerUrl() {
    final extension = widget.fileName.split('.').last.toLowerCase();

    // For PDF files, use Google Docs Viewer
    if (extension == 'pdf') {
      return 'https://docs.google.com/viewer?url=${Uri.encodeComponent(widget.documentUrl)}&embedded=true';
    }

    if (['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].contains(extension)) {
      return 'https://docs.google.com/viewer?url=${Uri.encodeComponent(widget.documentUrl)}&embedded=true';
    }

    if (['txt', 'json', 'xml', 'html', 'css', 'js'].contains(extension)) {
      return widget.documentUrl;
    }

    return 'https://docs.google.com/viewer?url=${Uri.encodeComponent(widget.documentUrl)}&embedded=true';
  }
}
