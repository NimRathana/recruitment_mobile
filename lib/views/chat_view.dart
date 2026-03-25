import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recruitment_mobile/controllers/setting_controller.dart';
import '../core/themes/app_theme.dart';

class ChatView extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ChatView({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingController>();

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: true,
            floating: true,
            pinned: true,
            snap: true,
            expandedHeight: 120,
            elevation: 0,

            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                );
              },
            ),

            title: const Text(
              "Messenger",
              style: TextStyle(
                color: Color(0xFF0084FF),
                fontWeight: FontWeight.bold,
              ),
            ),

            actions: [
              IconButton(icon: const Icon(Icons.edit_note), onPressed: () {}),
              IconButton(icon: const Icon(Icons.facebook), onPressed: () {}),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  const SizedBox(height: 60),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 40,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stories / Active Friends (Messenger style)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 105,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  final bool isActive = index != 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isActive ? const Color(0xFF0084FF) : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(
                                  "https://i.pravatar.cc/150?u=active$index",
                                ),
                              ),
                            ),
                            if (isActive)
                              Obx(() {
                                final darkMode = settingController.isDarkMode.value ?? false;
                                return Positioned(
                                  right: 4,
                                  bottom: 4,
                                  child: Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: darkMode ? darkBg : lightBg,
                                        width: 2.5,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          index == 0 ? "You" : "Friend",
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Chat List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) => _buildMessengerChatTile(context, index), childCount: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMessengerChatTile(BuildContext context, int index) {
    final names = ["Alex Rivera", "Sarah Chen", "Mike Johnson", "Emma Watson", "David Kim", "Lisa Park"];
    final name = names[index % names.length];
    final bool hasUnread = index % 3 == 0 || index % 3 == 1;
    final bool isOnline = index % 4 != 0;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatDetailScreen(name: name, avatar: "https://i.pravatar.cc/150?u=$index"),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$index"),
                ),
                if (isOnline)
                  Obx(() {
                    final darkMode = settingController.isDarkMode.value ?? false;
                    return Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: darkMode ? darkBg : lightBg,
                            width: 2.5,
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasUnread
                        ? "You: That's awesome! 👍"
                        : "See you tomorrow at 3pm",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "12:45",
                  style: TextStyle(
                    fontSize: 13,
                    color: hasUnread ? const Color(0xFF0084FF) : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 6),
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0084FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      "2",
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ====================== REAL MESSENGER-STYLE CHAT DETAIL ======================
class ChatDetailScreen extends StatelessWidget {
  final String name;
  final String avatar;

  const ChatDetailScreen({super.key, required this.name, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(radius: 19, backgroundImage: NetworkImage(avatar)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const Text("Active now", style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call, color: Color(0xFF0084FF)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam, color: Color(0xFF0084FF)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              reverse: true,
              itemCount: 20,
              itemBuilder: (context, index) {
                final bool isMe = index % 2 == 0;
                return _MessengerBubble(isMe: isMe);
              },
            ),
          ),
          _buildMessengerInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessengerInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 28),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Color(0xFF0084FF)),
              onPressed: () {},
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Aa",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.emoji_emotions_outlined, color: Color(0xFF0084FF)),
            const SizedBox(width: 8),
            const Icon(Icons.mic, color: Color(0xFF0084FF)),
          ],
        ),
      ),
    );
  }
}

class _MessengerBubble extends StatelessWidget {
  final bool isMe;

  const _MessengerBubble({required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF0084FF) : Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 6),
            bottomRight: Radius.circular(isMe ? 6 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          isMe
              ? "Hey, are you free this weekend? 😊"
              : "Yeah sure! What time works for you?",
          style: TextStyle(
            color: isMe ? Colors.white : null,
            fontSize: 16.5,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}