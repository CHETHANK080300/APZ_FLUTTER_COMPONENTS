import 'package:flutter/material.dart';
import '../lib/components/appz_text/appz_text.dart';
import '../lib/components/appz_text/appz_text_style_config.dart';

const String pangramUpper = 'PACK MY JUMBO BOX WITH A DOZEN QUIRKY BOLD GLYPHS.';
const String pangramLower = 'pack my jumbo box with a dozen quirky bold glyphs.';
const String numbers = '0123456789';
const String demoText = '$pangramUpper\n$pangramLower\n$numbers';

Widget labeledText(String category, String fontWeight, {String? url}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('$category / $fontWeight', style: const TextStyle(fontSize: 12, color: Colors.grey)),
    AppzText(demoText, category: category, fontWeight: fontWeight, url: url),
    const SizedBox(height: 12),
  ],
);

class AppzTextExamplePage extends StatefulWidget {
  const AppzTextExamplePage({Key? key}) : super(key: key);

  @override
  State<AppzTextExamplePage> createState() => _AppzTextExamplePageState();
}

class _AppzTextExamplePageState extends State<AppzTextExamplePage> {
  bool _tokensLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    await AppzTextStyleConfig.instance.load();
    setState(() {
      _tokensLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_tokensLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('AppzText Example')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // title
          labeledText('title', 'regular'),
          labeledText('title', 'semibold'),
          labeledText('title', 'bold'),
          // subtitle
          labeledText('subtitle', 'regular'),
          labeledText('subtitle', 'medium'),
          labeledText('subtitle', 'bold'),
          // header
          labeledText('header', 'medium'),
          // subheader
          labeledText('subheader', 'subheader'),
          // menu item
          labeledText('menuItem', 'regular'),
          // label & helper text
          labeledText('label', 'regular'),
          labeledText('label', 'label'),
          // input
          labeledText('input', 'regular'),
          labeledText('input', 'medium'),
          // currency
          labeledText('currency', 'regular'),
          // body
          labeledText('body', 'regular'),
          labeledText('body', 'bold'),
          // paragraph
          labeledText('paragraph', 'regular'),
          labeledText('paragraph', 'semibold'),
          labeledText('paragraph', 'bold'),
          // button
          labeledText('button', 'semibold'),
          // hyperlink
          labeledText('hyperlink', 'medium', url: 'https://www.google.com'),
          labeledText('hyperlink', 'bold', url: 'https://www.google.com'),
          // tooltip
          labeledText('tooltip', 'bold'),
          labeledText('tooltip', 'semibold'),
          // table header
          labeledText('tableHeader', 'regular'),
          labeledText('tableHeader', 'medium'),
          labeledText('tableHeader', 'bold'),
          labeledText('tableHeader', 'semibold'),
          // table content
          labeledText('tableContent', 'regular'),
          // note
          labeledText('note', 'regular'),
          // chips
          labeledText('chips', 'text'),
        ],
      ),
    );
  }
} 