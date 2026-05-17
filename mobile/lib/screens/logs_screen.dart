import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<Map<String, dynamic>> _artifacts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final arts = await ApiService.getArtifacts();
    setState(() {
      _artifacts = arts;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('AI Decision Transparency 🤖'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _load,
            tooltip: 'Refresh logs',
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1A237E)))
          : _artifacts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.analytics_outlined,
                          size: 64, color: Color(0xFF1A237E)),
                      const SizedBox(height: 16),
                      Text('No logs yet',
                          style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A237E))),
                      const SizedBox(height: 8),
                      Text(
                          'Make a booking first to see agent decision logs here.',
                          style: GoogleFonts.outfit(
                              color: Colors.grey.shade500, fontSize: 13),
                          textAlign: TextAlign.center),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _artifacts.length,
                  itemBuilder: (context, i) {
                    final art = _artifacts[i];
                    final filename = art['filename'] as String? ?? '';
                    final content = art['content'] as String? ?? '';
                    final icon = _iconForLog(filename);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: ExpansionTile(
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A237E).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon,
                              color: const Color(0xFF1A237E), size: 20),
                        ),
                        title: Text(
                          _labelForLog(filename),
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: const Color(0xFF1A237E)),
                        ),
                        subtitle: Text(filename,
                            style: GoogleFonts.outfit(
                                fontSize: 11, color: Colors.grey.shade400)),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A237E).withOpacity(0.03),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MarkdownBody(
                              data: content,
                              styleSheet: MarkdownStyleSheet(
                                h1: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1A237E)),
                                h2: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF283593)),
                                p: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: Colors.grey.shade700),
                                tableHead: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                                tableBody: GoogleFonts.outfit(fontSize: 12),
                                code: GoogleFonts.sourceCodePro(fontSize: 11),
                                codeblockDecoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  IconData _iconForLog(String name) {
    if (name.contains('intent'))    return Icons.psychology_rounded;
    if (name.contains('discovery')) return Icons.search_rounded;
    if (name.contains('ranking'))   return Icons.leaderboard_rounded;
    if (name.contains('pricing'))   return Icons.attach_money_rounded;
    if (name.contains('matchmaker'))return Icons.auto_awesome_rounded;
    if (name.contains('scheduling'))return Icons.calendar_today_rounded;
    if (name.contains('followup'))  return Icons.notifications_rounded;
    if (name.contains('quality'))   return Icons.star_rounded;
    if (name.contains('dispute'))   return Icons.gavel_rounded;
    return Icons.description_rounded;
  }

  String _labelForLog(String name) {
    if (name.contains('intent'))    return 'Agent 1 – Intent Extraction';
    if (name.contains('discovery')) return 'Agent 2 – Provider Discovery';
    if (name.contains('ranking'))   return 'Agent 3 – Ranking Engine';
    if (name.contains('pricing'))   return 'Agent 4 – Pricing Engine';
    if (name.contains('matchmaker'))return 'Agent 5 – Matchmaker';
    if (name.contains('scheduling'))return 'Agent 6 – Lock & Book';
    if (name.contains('followup'))  return 'Agent 7 – Follow-up';
    if (name.contains('quality'))   return 'Agent 8 – Review Manager';
    if (name.contains('dispute'))   return 'Agent 9 – Dispute Handler';
    return name;
  }
}
