import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }
    _model = GenerativeModel(
      model: 'gemini-2.5-flash-image', // Updated to 2.5 flash image model
      apiKey: apiKey,
    );
  }

  Future<String> generateLogoSvg(String prompt) async {
    try {
      print('--- GEMINI PROMPT ---');
      print(prompt);
      print('---------------------');
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      print('--- GEMINI RESPONSE ---');
      print(response.text);
      print('-----------------------');
      
      String? svgCode = response.text;
      
      if (svgCode == null || svgCode.isEmpty) {
        throw Exception('AI returned empty response');
      }

      // Robust SVG Extraction: Find content between <svg and </svg>
      final svgMatch = RegExp(r'<svg[\s\S]*?<\/svg>', caseSensitive: false).firstMatch(svgCode);
      
      if (svgMatch != null) {
        svgCode = svgMatch.group(0);
      } else {
        // Fallback: cleaning common markdown artifacts
        svgCode = svgCode.replaceAll('```svg', '');
        svgCode = svgCode.replaceAll('```xml', '');
        svgCode = svgCode.replaceAll('```', '');
      }

      return svgCode?.trim() ?? '';
    } catch (e) {
      print('GEMINI SERVICE ERROR: $e');
      rethrow;
    }
  }
}
