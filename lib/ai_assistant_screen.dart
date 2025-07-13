import 'package:flutter/material.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111618),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: Text(
                      'Assistant',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // To balance the back button
                ],
              ),
            ),
            // Chat bubbles
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _AssistantBubble(
                    avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuASbwwcCagswlQnl4-iv4UmMvnbprG90QFrN8EJC_c5V-ZqZn4gROmtVWfGDdKIKwrEO45Jk8vJ_JVr7vaoLbyU8vfu5ZLHW4PHk3ZYl32JPTEU9yRvfnIrFOGf2dnKL50HAtJqeNa54RFMtQdO-CtDGlJ9T7ltY93xzbVj6fhvTjmn7DzChvdMhj2ItZHB792b_uczUofeTzf24Rtz7KbIzUMmG5j_Y3mOnnEL1Q-ItbqhXVGEuih3UEwzZP6yPl_ry4AWode-108x',
                    name: 'Aiden',
                    message: 'Hey there! How can I help you today?',
                    isUser: false,
                  ),
                  _AssistantBubble(
                    avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAZRnnmXsn_ZOELdNRbG77Fta6EEenuxgg1nADQG8Ivj5GVeeyZbIjHwguCbB6642HsUAVVJQJ0KUFUhBKnwekTIttDFZy7-gRzWbUUcWGyxyXWcd83fGWGkOzqFMJcOlnd8tb-Ipnbua7YH_cmEXdjDIHex5_8MDYFlEXL7Ht7A7E8Sy-zQ8ULYoKqDSvKtp5plJVGdAowrtQ68NaHWQNk-UlAAaSHexn9Ivyycc-KWDbVI70pSa76gaBC6B8Pe4OmcMRxVWMBGp08',
                    name: 'Ethan',
                    message: 'Hi Aiden, I\'m looking for events happening this weekend.',
                    isUser: true,
                  ),
                  _AssistantBubble(
                    avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAZc3I_AuI9NJ-rsxck37lwB_J7jDLuxuaqRodzy6VQ5EQwk9XDdE7QnmC0azRZ4owxHIPJIU5CwO-90gRbQUsJS3MzkiBWo7NMVqk-BclNfXxehlYiGS7pJdko_wI6eegSZDD7YyPlKoud_RIoo2vRK4MmByyxlIBhqzXIAgyfnFXR5kOGbw7RLsf-XX6H5unQlUd7kzZLyWVwAjyGX3Io85TW-71KiQJr-h4nHtMkcuDvthTyunAHpXrwSD9qc-UUJaTe5BUp1S2U',
                    name: 'Aiden',
                    message: 'I\'m on it! Let me fetch some events for you.',
                    isUser: false,
                  ),
                  _AssistantBubble(
                    avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDSDosE-8NSY6hekDwq5iAc0oh1kDZeGK7LThGmBJha3w9bq7BpHncavadu-osVCW12Bw2C9vs5lVcHil09CigiX36ZpoSuBye_XJRUF8EG0dhZsqYtPtdL-lkjkEvpFoJ5KEHEWbN9qNjQTeWiLwhYIHFaM37Tfz-b6Name_i0eHagyFthK1HTcubABH0UeE0YBlzB3oHAVIm71MDeSAljew8R_5fP42Dz1OISV0bZ2vQm1uPO4uI0G6dmraA5HY2sOxMGbFo2vXUg',
                    name: 'Aiden',
                    message: '...',
                    isUser: false,
                  ),
                ],
              ),
            ),
            // Suggestions
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: const [
                  _SuggestionCard(
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB3v1JPP9-4CCXN4nE2343nTQnRQjng7XA8_1uiyBGC9ph-d2IOSuuVSq44lT4JtTIy4NeSA0nAk-1Gdx-2vHxkr3VD50vn3VuT2wJ_YwHADQ62HefTLJSVwYocy7MHjhpwcYka0-_peDnbVE9PUX_vYKxSuABC_am1-QAeATLdKZ6TKInArBHQ7kuCG6jfmyF7Lmr7i7oDhFs8kPZ8TGeoGV8GQalGoK2whwb6F1zuonk2M0IrJcVYnqtQSP47Ogb4dSqqFgOs4Itg',
                    label: 'Suggest events for me',
                  ),
                  SizedBox(width: 16),
                  _SuggestionCard(
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAwrFaA70JjUFLy2n_I2_qgEz9060PG_hFui0l38ywojVagb4z08dBvcSEQg6N-WaZWHsi3ePi5lNP0mJlWTtPcRrhebUBJnE88jmQ1lGLFJKycK5Oqv0T3JgcklSO8b8Lz683OdC10om83ySyvTpdnKVti6HZEJHqncMYR3JJDhipk7WZPczEi_aCjcGOXhOt64N-N2podx9GZ0VCe5K84rE2IIPOm4B8mF8g68_IME2n7EI9AR3ULc3QSucugyl9R9PBKEauj1h0A',
                    label: 'Draft a post',
                  ),
                ],
              ),
            ),
            // Input bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: const TextStyle(color: Color(0xFF9cb2ba)),
                        filled: true,
                        fillColor: const Color(0xFF283539),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic, color: Color(0xFF9cb2ba)),
                    onPressed: () {},
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0cb9f2),
                        foregroundColor: const Color(0xFF111618),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () {},
                      child: const Text('Send'),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom nav bar
            const _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String message;
  final bool isUser;
  const _AssistantBubble({required this.avatarUrl, required this.name, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 20,
            ),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 2, left: 8, right: 8),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF9cb2ba),
                    fontSize: 13,
                  ),
                  textAlign: isUser ? TextAlign.right : TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isUser ? const Color(0xFF0cb9f2) : const Color(0xFF283539),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isUser ? const Color(0xFF111618) : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isUser)
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 20,
            ),
          ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  const _SuggestionCard({required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1b2427),
        border: Border(
          top: BorderSide(color: Color(0xFF283539)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(icon: Icons.home, label: 'Home', active: false),
          _NavBarItem(icon: Icons.calendar_today, label: 'Events', active: false),
          _NavBarItem(icon: Icons.add_box, label: 'Create', active: false),
          _NavBarItem(icon: Icons.smart_toy, label: 'Assistant', active: true),
          _NavBarItem(icon: Icons.person, label: 'Profile', active: false),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavBarItem({required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? Colors.white : const Color(0xFF9cb2ba),
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF9cb2ba),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 