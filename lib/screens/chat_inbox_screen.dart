import 'package:flutter/material.dart';
import '/theme/colors.dart'; // tu archivo de colores
import 'ChatDetailScreen.dart'; // pantalla de detalle del chat

class ChatInboxScreen extends StatelessWidget {
  const ChatInboxScreen({super.key});

  // Lista de conversaciones dummy
  final List<Map<String, String>> dummyConversations = const [
    {
      'name': 'Juan',
      'lastMessage': 'Hola, ¿aún tienes la laptop?',
      'time': '12:30'
    },
    {
      'name': 'María',
      'lastMessage': 'Perfecto, nos vemos mañana.',
      'time': '09:15'
    },
    {
      'name': 'Carlos',
      'lastMessage': 'Gracias por el envío rápido!',
      'time': '15:45'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bandeja de Entrada",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: dummyConversations.length,
        itemBuilder: (_, index) {
          final convo = dummyConversations[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: secondaryColor,
              child: Text(
                convo['name']![0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(convo['name']!),
            subtitle: Text(
              convo['lastMessage']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              convo['time']!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              // Navega a ChatDetailScreen al presionar la conversación
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(
                    contactName: convo['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
