import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

const String kBaseUrl = 'http://localhost:8000';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF075E54);
  static const Color _accent = Color(0xFF25D366);

  List<Map<String, String>> _artifacts = [];
  bool _loading = false;
  String? _error;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _fetchArtifacts();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchArtifacts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp = await http.get(Uri.parse('$kBaseUrl/artifacts'));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final list = (data['artifacts'] as List)
            .map((e) => {
                  'filename': e['filename'] as String,
                  'content': e['content'] as String,
                })
            .toList();
        setState(() {
          _artifacts = list;
          _loading = false;
          _tabController?.dispose();
          _tabController = TabController(
            length: list.length,
            vsync: this,
          );
        });
      } else {
        setState(() {
          _error = 'Server returned ${resp.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Cannot connect to backend. Start the server first.';
        _loading = false;
      });
    }
  }

  String _prettyName(String filename) {
    return filename
        .replaceAll('.md', '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty
            ? w[0].toUpperCase() + w.substring(1)
            : '')
        .join(' ');
  }

  Color _tabColor(String filename) {
    if (filename.contains('intent')) return const Color(0xFF6C63FF);
    if (filename.contains('discovery')) return const Color(0xFF00BCD4);
    if (filename.contains('ranking')) return const Color(0xFFFF9800);
    if (filename.contains('pricing')) return const Color(0xFF4CAF50);
    if (filename.contains('scheduling')) return const Color(0xFF2196F3);
    if (filename.contains('quality')) return const Color(0xFFE91E63);
    if (filename.contains('followup')) return const Color(0xFF9C27B0);
    if (filename.contains('user_response')) return const Color(0xFF25D366);
    return _primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 2,
        title: const Row(
          children: [
            Icon(Icons.analytics, color: Colors.white, size: 22),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agent Transparency Logs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Full decision trail for every booking',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh Logs',
            onPressed: _fetchArtifacts,
          ),
        ],
        bottom: _loading || _artifacts.isEmpty || _tabController == null
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: _accent,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
                tabs: _artifacts
                    .map((a) => Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _tabColor(a['filename']!),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(_prettyName(a['filename']!)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF075E54)),
            SizedBox(height: 16),
            Text('Loading agent logs...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchArtifacts,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF075E54),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_artifacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No logs yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Send a message in the Chat tab to\ngenerate agent decision logs.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchArtifacts,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075E54),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: _artifacts.map((a) => _buildLogView(a)).toList(),
    );
  }

  Widget _buildLogView(Map<String, String> artifact) {
    final filename = artifact['filename']!;
    final content = artifact['content']!;
    final color = _tabColor(filename);

    return Column(
      children: [
        // Header badge
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border(bottom: BorderSide(color: color.withOpacity(0.3))),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  filename,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${content.length} chars',
                style: TextStyle(color: color, fontSize: 11),
              ),
            ],
          ),
        ),
        // Markdown content
        Expanded(
          child: Markdown(
            data: content,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF075E54),
              ),
              h2: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
              h3: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
              p: const TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF444444)),
              code: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                backgroundColor: Color(0xFFEEEEEE),
                color: Color(0xFF075E54),
              ),
              codeblockDecoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDDDDDD)),
              ),
              blockquoteDecoration: BoxDecoration(
                color: const Color(0xFFF0F9F0),
                border: const Border(
                  left: BorderSide(color: Color(0xFF25D366), width: 4),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              tableHead: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tableHeadAlign: TextAlign.center,
              tableBorder: TableBorder.all(
                color: const Color(0xFFDDDDDD),
                width: 1,
              ),
              listBullet: const TextStyle(
                color: Color(0xFF075E54),
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
