import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../order_cart/presentation/pages/cart_page.dart';
import '../../../order_cart/presentation/pages/order_history_page.dart';
import '../../../product/presentation/pages/home_page.dart';
import '../../../product/data/services/product_service.dart';

class GeminiChatPage extends StatefulWidget {
  const GeminiChatPage({super.key});

  @override
  State<GeminiChatPage> createState() => _GeminiChatPageState();
}

class _GeminiChatPageState extends State<GeminiChatPage> {
  final List<types.Message> _messages = [];
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  final ProductService _productService = ProductService();

  bool _isSpeaking = false;
  bool _isTyping = false;
  bool _hasUserInteracted = false;

  final types.User _user = const types.User(id: 'user-1', firstName: 'Sen');
  final types.User _gemini = const types.User(id: 'gemini-1', firstName: 'KLKAI');

  final List<String> _suggestionPrompts = [
    "👕 Sepetime nasıl gidebilirim ?",
    "👟 4000 tl civarı siyah spor ayakkabı var mı?",
    "📦 Siparişim ne zaman kargoya verilir?",
    "🕶️ Yüz tipime uygun gözlük önerir misin?",
  ];

  @override
  void initState() {
    super.initState();
    Gemini.init(apiKey: "AIzaSyCkXwDYIao9OLNY1An3Q6ZUAivpX2tzwbQ");

    _flutterTts.setStartHandler(() => setState(() => _isSpeaking = true));
    _flutterTts.setCompletionHandler(() => setState(() => _isSpeaking = false));
    _flutterTts.setCancelHandler(() => setState(() => _isSpeaking = false));

    _textController.addListener(() {
      if (mounted) {
        setState(() {
          _isTyping = _textController.text.trim().isNotEmpty;
        });
      }
    });
  }

  String _randomId() => Random().nextInt(999999).toString();

  void _addMessage(types.Message message) {
    if (mounted) {
      setState(() => _messages.insert(0, message));
    }
  }

  bool _handleCommands(String text) {
    final t = text.toLowerCase();

    if (t.contains("ana sayfa") || t.contains("home")) {
      _addMessage(types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomId(),
        text: "Tabi hemen Ana Sayfaya yönlendiriyorum...",
      ));
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
          );
        }
      });
      return true;
    }

    if (t.contains("sepet") || t.contains("sepetime") || t.contains("cart")) {
      _addMessage(types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomId(),
        text: "Tabi hemen Sepetine yönlendiriyorum...",
      ));
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartPage()),
          );
        }
      });
      return true;
    }

    if (t.contains("geçmiş") || t.contains("sipariş") || t.contains("orders")) {
      _addMessage(types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomId(),
        text: "Tabi hemen Sipariş geçmişine gidiyoruz...",
      ));
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
          );
        }
      });
      return true;
    }

    if (t.contains("profil") || t.contains("hesabım")) {
      _addMessage(types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomId(),
        text: "Tabi hemen Profiline yönlendiriyorum...",
      ));
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        }
      });
      return true;
    }

    return false;
  }

  int? _extractCategoryFromText(String text) {
    final t = text.toLowerCase();

    if (t.contains("t-shirt") || t.contains("tişört") || t.contains("tshirt")) return 1;
    if (t.contains("mont") || t.contains("ceket")) return 2;
    if (t.contains("triko") || t.contains("kazak")) return 3;
    if (t.contains("ayakkabı") || t.contains("spor ayakkabı")) return 4;
    if (t.contains("cüzdan") || t.contains("parfürm") || t.contains("parfüm")) return 5;

    return null;
  }

  Map<String, double?> _extractPriceRange(String text) {
    final t = text.toLowerCase().replaceAll(',', '').replaceAll('.', '');

    final betweenRegex = RegExp(r'(\d{2,7})\s*[-–]\s*(\d{2,7})');
    final betweenMatch = betweenRegex.firstMatch(t);
    if (betweenMatch != null) {
      final min = double.tryParse(betweenMatch.group(1)!) ?? 0;
      final max = double.tryParse(betweenMatch.group(2)!) ?? 0;
      return {"min": min, "max": max};
    }

    final belowRegex = RegExp(r'(\d{2,7})\s*(tl)?\s*(altı|altinda|altında|alt)');
    final belowMatch = belowRegex.firstMatch(t);
    if (belowMatch != null) {
      final max = double.tryParse(belowMatch.group(1)!) ?? 0;
      return {"min": 0, "max": max};
    }

    final aboveRegex = RegExp(r'(\d{2,7})\s*(tl)?\s*(üstü|ustu|üzeri|uzeri|den fazla|fazla)');
    final aboveMatch = aboveRegex.firstMatch(t);
    if (aboveMatch != null) {
      final min = double.tryParse(aboveMatch.group(1)!) ?? 0;
      return {"min": min, "max": null};
    }

    final aroundRegex = RegExp(r'(\d{2,7})\s*(tl)?\s*(civar|civarında|civarinda|yaklaşık|yaklasik)');
    final aroundMatch = aroundRegex.firstMatch(t);
    if (aroundMatch != null) {
      final base = double.tryParse(aroundMatch.group(1)!) ?? 0;
      return {"min": base * 0.8, "max": base * 1.2};
    }

    final numberRegex = RegExp(r'(?<!\d)(\d{2,7})(?!\d)');
    final numberMatch = numberRegex.firstMatch(t);
    if (numberMatch != null) {
      final base = double.tryParse(numberMatch.group(1)!) ?? 0;

      if (t.contains('tl') || t.contains('fiyat') || t.contains('tutar') || t.contains('lira') || t.contains('₺')) {
        return {"min": base * 0.8, "max": base * 1.2};
      }
    }

    return {"min": null, "max": null};
  }

  bool _isFilterQuery(String text) {
    final lower = text.toLowerCase();

    return _extractCategoryFromText(text) != null ||
        lower.contains("tl") ||
        lower.contains("fiyat") ||
        lower.contains("altı") ||
        lower.contains("üstü") ||
        lower.contains("civar") ||
        RegExp(r'\d{2,7}\s*[-–]\s*\d{2,7}').hasMatch(lower);
  }

  Future<void> _processFilterQuery(String text) async {
    final categoryId = _extractCategoryFromText(text);
    final price = _extractPriceRange(text);
    final min = price["min"];
    final max = price["max"];

    String info = "Filtre uygulanıyor";
    if (categoryId != null) info += " — kategori: $categoryId";
    if (min != null || max != null) {
      info += " — fiyat:";
      if (min != null) info += " min ${min.toInt()}";
      if (max != null) info += " max ${max.toInt()}";
    }

    _addMessage(types.TextMessage(
      author: _gemini,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _randomId(),
      text: info,
    ));

    try {
      final products = await _productService.filterProducts(
        categoryId: categoryId,
        minPrice: min,
        maxPrice: max,
      );

      if (products.isEmpty) {
        _addMessage(types.TextMessage(
          author: _gemini,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: _randomId(),
          text: "Maalesef bu kriterlere uygun ürün bulunamadı.",
        ));
        return;
      }

      final limit = products.length > 8 ? 8 : products.length;
      final displayed = products.take(limit).toList();

      final productList = displayed.map((p) {
        final priceStr = p.price.toStringAsFixed(0);
        // 'p.brand' yerine 'p.name' kullanıyoruz:
        return "• ${p.name} - ${priceStr} TL";
      }).join("\n");

      String replyText = "Bulduklarım (${products.length}):\n$productList";
      if (products.length > limit) replyText += "\n\nDaha fazlasını görmek istersen söyle.";

      _addMessage(types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomId(),
        text: replyText,
      ));
    } catch (e) {
      _addMessage(types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomId(),
        text: "Filtreleme sırasında bir hata oluştu. (Hata: $e)",
      ));
    }
  }

  Future<void> _handleSendPressed(String text) async {
    if (text.trim().isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _hasUserInteracted = true;
      _textController.clear();
      _isTyping = false;
    });

    _addMessage(types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _randomId(),
      text: text,
    ));

    if (_handleCommands(text)) return;

    if (_isFilterQuery(text)) {
      await _processFilterQuery(text);
      return;
    }

    try {
      final response = await Gemini.instance.text(text);
      String replyText = "Yanıt alınamadı.";

      final parts = response?.content?.parts;
      if (parts != null && parts.isNotEmpty) {
        try {
          final first = parts.first;
          if (first is TextPart) {
            replyText = first.text ?? replyText;
          } else if (first.toString().isNotEmpty) {
            replyText = first.toString();
          }
        } catch (_) {
          replyText = parts.first.toString();
        }
      }

      _addMessage(types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomId(),
        text: replyText,
      ));
    } catch (e) {
      _addMessage(types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: _randomId(),
        text: "Bir hata oluştu: $e",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("KLKAI Asistan",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                Text("● Çevrimiçi",
                    style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz, color: Colors.black), onPressed: () {})
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.withOpacity(0.1), height: 1),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Chat(
                  messages: _messages,
                  onSendPressed: (partialText) => _handleSendPressed(partialText.text),
                  user: _user,
                  customBottomWidget: const SizedBox.shrink(),
                  theme: DefaultChatTheme(
                    backgroundColor: Colors.white,
                    messageBorderRadius: 20,
                    messageInsetsVertical: 12,
                    messageInsetsHorizontal: 16,
                    primaryColor: Colors.black,
                    sentMessageBodyTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                    secondaryColor: const Color(0xFFF4F4F5),
                    receivedMessageBodyTextStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  showUserAvatars: false,
                  showUserNames: false,
                ),
              ),
              _buildCustomInputArea(),
            ],
          ),
          if (!_hasUserInteracted)
            Positioned(bottom: 90, left: 0, right: 0, child: _buildSuggestionsOverlay()),
        ],
      ),
    );
  }

  Widget _buildSuggestionsOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              "Hızlı Başlangıç 👇",
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _suggestionPrompts.map((suggestion) {
              return GestureDetector(
                onTap: () => _handleSendPressed(suggestion),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 8),
            child: Icon(Icons.add_circle_outline, color: Colors.grey[600], size: 28),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: "Merak ettiğin bir şey sor...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (value) => _handleSendPressed(value),
                    ),
                  ),
                  if (!_isTyping) const Icon(Icons.mic, color: Colors.grey, size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _handleSendPressed(_textController.text),
            child: Container(
              margin: const EdgeInsets.only(bottom: 2),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              child: _isTyping
                  ? const Icon(Icons.arrow_upward, color: Colors.white, size: 24)
                  : const Icon(Icons.camera_alt, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}