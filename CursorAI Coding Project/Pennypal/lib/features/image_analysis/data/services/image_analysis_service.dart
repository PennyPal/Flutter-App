import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';

/// Service for analyzing images using Perplexity AI
/// Supports receipt scanning, document analysis, and financial image processing
class ImageAnalysisService {
  static const String _baseUrl = 'https://api.perplexity.ai';
  
  /// Analyze an image for financial information
  /// Supports: receipts, invoices, bills, bank statements
  static Future<ImageAnalysisResult> analyzeImage({
    required File imageFile,
    String? customPrompt,
  }) async {
    final apiKey = AppConfig.perplexityApiKey;
    
    if (apiKey == 'YOUR_PERPLEXITY_API_KEY_HERE' || apiKey.isEmpty) {
      throw Exception('Perplexity API key not configured');
    }

    try {
      // Read image as base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Prepare the prompt
      final prompt = customPrompt ?? _buildDefaultPrompt();
      
      // Note: Perplexity API currently doesn't support image input directly
      // This is a placeholder for when they add vision capabilities
      // For now, we'll return a helpful message
      
      return ImageAnalysisResult(
        success: false,
        message: 'Image analysis coming soon! Perplexity is adding vision capabilities.',
        extractedData: {},
      );
      
      // TODO: When Perplexity adds vision API, use this:
      /*
      final url = Uri.parse('$_baseUrl/chat/completions');
      
      final requestBody = {
        'model': 'llama-3.1-sonar-small-128k-online',
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
              }
            ]
          }
        ],
        'temperature': 0.2,
        'max_tokens': 1024,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        return _parseAnalysisResult(content);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
      */
    } catch (e) {
      return ImageAnalysisResult(
        success: false,
        message: 'Error analyzing image: ${e.toString()}',
        extractedData: {},
      );
    }
  }

  /// Analyze receipt and extract transaction details
  static Future<ReceiptAnalysisResult> analyzeReceipt(File imageFile) async {
    // Placeholder for receipt-specific analysis
    return ReceiptAnalysisResult(
      success: false,
      message: 'Receipt scanning coming soon with Perplexity Vision API!',
      merchantName: null,
      totalAmount: null,
      date: null,
      items: [],
      category: null,
    );
  }

  static String _buildDefaultPrompt() {
    return '''
Analyze this financial image and extract the following information:
1. Type of document (receipt, invoice, bill, statement, etc.)
2. Merchant/vendor name
3. Total amount
4. Date
5. Individual items (if receipt)
6. Payment method
7. Category suggestion (food, transport, utilities, etc.)

Provide the information in a structured format.
''';
  }

  static ImageAnalysisResult _parseAnalysisResult(String content) {
    // Parse the AI response and extract structured data
    return ImageAnalysisResult(
      success: true,
      message: 'Analysis complete',
      extractedData: {
        'raw_analysis': content,
      },
    );
  }
}

/// Result of image analysis
class ImageAnalysisResult {
  final bool success;
  final String message;
  final Map<String, dynamic> extractedData;

  ImageAnalysisResult({
    required this.success,
    required this.message,
    required this.extractedData,
  });
}

/// Result of receipt analysis
class ReceiptAnalysisResult {
  final bool success;
  final String message;
  final String? merchantName;
  final double? totalAmount;
  final DateTime? date;
  final List<ReceiptItem> items;
  final String? category;

  ReceiptAnalysisResult({
    required this.success,
    required this.message,
    this.merchantName,
    this.totalAmount,
    this.date,
    required this.items,
    this.category,
  });
}

/// Individual item from receipt
class ReceiptItem {
  final String name;
  final double price;
  final int quantity;

  ReceiptItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

