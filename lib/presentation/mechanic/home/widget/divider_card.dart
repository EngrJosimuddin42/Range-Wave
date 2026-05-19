import 'package:flutter/material.dart';

class DriverCard extends StatelessWidget {
  final String name;
  final String address;
  final double rating;
  final String duration;
  final String distance;
  final String imageUrl;

  const DriverCard({
    super.key,
    required this.name,
    required this.address,
    required this.rating,
    required this.duration,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(width: 14),

          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),

                // Address
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating + Duration + Distance
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFC107), size: 18),
                    const SizedBox(width: 3),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '•',
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '•',
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      distance,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              _ActionButton(
                icon: Icons.phone_outlined,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _ActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: const Color(0xFF4A4A6A),
        ),
      ),
    );
  }
}