import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';

/// Service for integrating with Perplexity AI API
/// Perplexity provides real-time, factual AI responses with citations
class PerplexityService {
  static const String _model = 'llama-3.1-sonar-small-128k-online';
  
  /// Send a message to Perplexity AI and get a response
  /// 
  /// The online model has access to real-time information and provides
  /// citations for factual claims, making it ideal for financial advice
  static Future<String> sendMessage(String message) async {
    if (!AppConfig.isPerplexityConfigured) {
      throw Exception(
        'Perplexity API key not configured. Please add your API key to the configuration.',
      );
    }

    try {
      final url = Uri.parse('${AppConfig.perplexityApiUrl}/chat/completions');
      
      final requestBody = {
        'model': _model,
        'messages': [
          {
            'role': 'system',
            'content': _buildSystemPrompt(),
          },
          {
            'role': 'user',
            'content': message,
          }
        ],
        'temperature': 0.7,
        'top_p': 0.9,
        'max_tokens': 1024,
        'stream': false,
      };
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.perplexityApiKey}',
        },
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['choices'] != null && (data['choices'] as List).isNotEmpty) {
          final choice = data['choices'][0];
          final content = choice['message']['content'] as String;
          
          // Extract citations if available
          final citations = _extractCitations(data);
          
          if (citations.isNotEmpty) {
            return '$content\n\n📚 Sources:\n$citations';
          }
          
          return content;
        }
        
        return 'I apologize, but I couldn\'t generate a response. Please try again.';
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your Perplexity API configuration.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again in a moment.');
      } else {
        print('Perplexity API Error: ${response.statusCode} - ${response.body}');
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling Perplexity API: $e');
      rethrow;
    }
  }
  
  /// Build a contextual system prompt for financial advice
  static String _buildSystemPrompt() {
    return '''
You are PennyPal, an AI financial advisor designed to help users with personal finance management. You are knowledgeable, friendly, and focused on providing practical, actionable financial advice based on current, real-time information.

Key areas you can help with:
- Budgeting and expense tracking
- Saving strategies and goal setting
- Investment basics and portfolio planning (with current market insights)
- Debt management and payoff strategies
- Financial planning and retirement
- Tax optimization tips (current year)
- Credit score improvement
- Emergency fund planning
- Current economic trends and their impact on personal finance

Guidelines for responses:
1. Be conversational and encouraging
2. Provide specific, actionable advice based on current information
3. Use bullet points and formatting for clarity
4. Ask follow-up questions to better understand their situation
5. Always emphasize the importance of emergency funds and basic financial security
6. Keep responses concise but comprehensive (aim for 2-4 paragraphs)
7. Cite sources when providing statistical or factual information
8. If asked about specific financial products, recommend consulting with a licensed financial advisor
9. Never provide specific investment recommendations for individual stocks or securities
10. Always include disclaimers for investment and tax advice

IMPORTANT: Always base your advice on the most current information available. When discussing market conditions, interest rates, or economic factors, use the latest data.
''';
  }

  /// Extract and format citations from the Perplexity response
  static String _extractCitations(Map<String, dynamic> data) {
    final citations = <String>[];
    
    // Check if citations are available in the response
    if (data['citations'] != null && data['citations'] is List) {
      final citationsList = data['citations'] as List;
      for (int i = 0; i < citationsList.length && i < 3; i++) {
        citations.add('${i + 1}. ${citationsList[i]}');
      }
    }
    
    return citations.join('\n');
  }

  /// Get a fallback response when API is unavailable
  static String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('budget')) {
      return '''
📊 Budgeting is essential for financial health! Here are key tips:

• Follow the 50/30/20 rule: 50% needs, 30% wants, 20% savings/debt
• Track all expenses for at least a month
• Set realistic spending limits for each category
• Use apps or spreadsheets to monitor progress
• Review and adjust monthly

Would you like help creating a specific budget plan?

⚠️ Note: I'm currently offline. For the most up-to-date financial advice, please try again when I'm connected.
''';
    } else if (lowerMessage.contains('invest')) {
      return '''
💰 Investment basics for beginners:

• Start with an emergency fund (3-6 months expenses)
• Understand your risk tolerance
• Consider low-cost index funds for diversification
• Think long-term (5+ years)
• Don't try to time the market
• Consider tax-advantaged accounts (401k, IRA)

⚠️ Note: I'm currently offline. For current market conditions and personalized advice, please consult a licensed financial advisor.
''';
    } else if (lowerMessage.contains('save') || lowerMessage.contains('saving')) {
      return '''
🏦 Smart saving strategies:

• Automate your savings (pay yourself first)
• Set specific, measurable goals
• Use high-yield savings accounts
• Save windfalls and bonuses
• Cut unnecessary subscriptions
• Track progress regularly

⚠️ Note: I'm currently offline. For current interest rates and best savings options, please try again later.
''';
    } else if (lowerMessage.contains('debt')) {
      return '''
💳 Debt management strategies:

• List all debts with interest rates
• Pay minimum on all, extra on highest interest (avalanche method)
• Or start with smallest debt for quick wins (snowball method)
• Consider debt consolidation if rates are lower
• Negotiate with creditors if struggling
• Avoid new debt while paying off existing

⚠️ Note: I'm currently offline. For personalized debt strategies, please try again or consult a financial advisor.
''';
    }
    
    return '''
I'm here to help with your financial questions! I can assist with:

• Budgeting and expense tracking
• Saving and investing strategies
• Debt management
• Financial planning
• And much more!

⚠️ Note: I'm currently offline. For the best experience with real-time financial data and insights, please try again when I'm connected.

What specific financial topic would you like to explore?
''';
  }
}

