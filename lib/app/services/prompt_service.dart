class PromptService {
  static String buildLogoPrompt({
    required String brandName,
    required String slogan,
    required String industry,
    required String style,
    required List<String> colors,
    required String audience,
    required String font,
    required String layout,
  }) {
    final String colorStr = colors.join(' and ');

    return '''
Act as a professional Brand Identity Designer and SVG Expert. 
Your task is to generate a high-quality, professional, and unique logo in SVG format.

BRAND DETAILS:
- Name: $brandName
- Slogan: $slogan
- Industry: $industry
- Target Audience: $audience

DESIGN REQUIREMENTS:
- Style: $style
- Primary Colors (CRITICAL): Use exactly these hex codes: $colorStr
- Font Style: $font
- Layout: $layout

TECHNICAL CONSTRAINTS:
1. Output ONLY the valid SVG code.
2. Ensure the SVG is responsive (use viewBox).
3. Do NOT include any explanations, markdown code blocks, or text outside the <svg> tags.
4. If a slogan is provided, include it as a smaller <text> element below or beside the Brand Name.
5. Use high-quality vector shapes to represent the icon/industry.
6. Make sure the colors are correctly applied as hex codes or valid SVG color names.

The logo should look premium, balanced, and aesthetically pleasing.
''';
  }
}
