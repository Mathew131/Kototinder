import 'package:flutter/material.dart';

class LikedCatsButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LikedCatsButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.favorite),
      label: const Text('Liked Cats'),
    );
  }
}

class LikeButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LikeButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.favorite),
      label: const Text('Like'),
    );
  }
}

class DislikeButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DislikeButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.close),
      label: const Text('Dislike'),
    );
  }
}
