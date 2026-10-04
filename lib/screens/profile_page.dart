import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: theme.textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person_outline,
                size: 44,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Profil Pengguna',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur profil akan hadir\npada pertemuan berikutnya.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
