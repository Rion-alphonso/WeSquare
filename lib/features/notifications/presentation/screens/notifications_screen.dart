import 'package:flutter/material.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/mesh_background.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NOTIFICATIONS', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: const MeshBackground(
        child: EmptyState(
          icon: Icons.notifications_off_outlined,
          title: 'No new notifications',
          subtitle: 'You\'re all caught up!',
        ),
      ),
    );
  }
}
