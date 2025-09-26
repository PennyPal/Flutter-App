import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for integrating with Google Gemini AI API
class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String _model = 'gemini-pro';
  
  // TODO: Replace with your actual Gemini API key
  static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  /// Send a message to Gemini AI and get a response
  static Future<String> sendMessage(String message) async {
    try {
      final url = Uri.parse('$_baseUrl/models/$_model:generateContent?key=$_apiKey');
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': _buildPrompt(message),
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final candidates = data['candidates'] as List;
        
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          
          if (parts.isNotEmpty) {
            return parts[0]['text'] as String;
          }
        }
        
        return 'I apologize, but I couldn\'t generate a response. Please try again.';
      } else {
        print('Gemini API Error: ${response.statusCode} - ${response.body}');
        return _getFallbackResponse(message);
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      return _getFallbackResponse(message);
    }
  }
  
  /// Build a contextual prompt for financial advice
  static String _buildPrompt(String userMessage) {
    return '''
You are PennyPal, an AI financial advisor designed to help users with personal finance management. You are knowledgeable, friendly, and focused on providing practical, actionable financial advice.

Key areas you can help with:
- Budgeting and expense tracking
- Saving strategies and goal setting
- Investment basics and portfolio planning
- Debt management and payoff strategies
- Financial planning and retirement
- Tax optimization tips
- Credit score improvement
- Emergency fund planning

Guidelines for responses:
1. Be conversational and encouraging
2. Provide specific, actionable advice
3. Use bullet points and formatting for clarity
4. Ask follow-up questions to better understand their situation
5. Always emphasize the importance of emergency funds and basic financial security
6. Keep responses concise but comprehensive (aim for 2-4 paragraphs)
7. If asked about specific financial products, recommend consulting with a licensed financial advisor
8. Never provide specific investment recommendations for individual stocks or securities

User's question: $userMessage

Please provide a helpful, personalized response that addresses their financial question or concern.
''';
  }
  
  /// Fallback response when API is unavailable
  static String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('budget') || lowerMessage.contains('budgeting')) {
      return '''Great question about budgeting! Here are some key tips:

• **50/30/20 Rule**: Allocate 50% to needs, 30% to wants, and 20% to savings
• **Track every expense** for at least a month to understand your spending patterns
• **Use the envelope method** for variable expenses like groceries and entertainment
• **Review and adjust** your budget monthly

Would you like me to help you create a specific budget plan?''';
    } else if (lowerMessage.contains('save') || lowerMessage.contains('saving')) {
      return '''Saving money is crucial for financial security! Here's how to get started:

• **Pay yourself first** - set up automatic transfers to savings
• **Build an emergency fund** - aim for 3-6 months of expenses
• **Use the 52-week challenge** - save \$1 in week 1, \$2 in week 2, etc.
• **Cut unnecessary expenses** - review subscriptions and dining out

What's your current savings goal?''';
    } else if (lowerMessage.contains('invest') || lowerMessage.contains('investment')) {
      return '''Investing can help grow your wealth over time! Here are the basics:

• **Start with index funds** - they're diversified and low-cost
• **Dollar-cost averaging** - invest regularly regardless of market conditions
• **Consider your risk tolerance** - younger investors can take more risk
• **Don't try to time the market** - time in the market beats timing the market

What's your investment timeline and risk tolerance?''';
    } else if (lowerMessage.contains('debt') || lowerMessage.contains('pay off')) {
      return '''Managing debt effectively is important for financial health:

• **Debt avalanche method** - pay off highest interest debt first
• **Debt snowball method** - pay off smallest debts first for motivation
• **Consider debt consolidation** if you have high-interest debt
• **Stop accumulating new debt** while paying off existing debt

What type of debt are you dealing with?''';
    } else {
      return '''I'd be happy to help you with that! As your AI financial advisor, I can assist with:

• Budgeting and expense tracking
• Saving strategies and goal setting
• Investment basics and portfolio planning
• Debt management and payoff strategies
• Financial planning and retirement
• Tax optimization tips

Could you be more specific about what financial topic you'd like to discuss?''';
    }
  }
}
