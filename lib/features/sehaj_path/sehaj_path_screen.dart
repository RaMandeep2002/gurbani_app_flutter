import 'package:flutter/material.dart';

class SehajPathScreen extends StatelessWidget {
  const SehajPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const totalAng = 1430;
    const currentAng = 523;

    final progress = currentAng / totalAng;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sehaj Path",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            Text(
              "Your journey through Sri Guru Granth Sahib Ji",
              style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
            ),

            const SizedBox(height: 30),

            // PROGRESS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFF8B6F00)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Overall Progress",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 170,
                          height: 170,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: Colors.white24,
                            color: Colors.white,
                          ),
                        ),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${(progress * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              "Completed",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "$currentAng / $totalAng Ang",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // CURRENT READING
            const Text(
              "Current Reading",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ang 523",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Continue from where you left off",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Continue Reading"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // STATS
            const Text(
              "Statistics",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "Days",
                    value: "38",
                    icon: Icons.calendar_month,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "Streak",
                    value: "12",
                    icon: Icons.local_fire_department,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "Read",
                    value: "523",
                    icon: Icons.menu_book,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "Remaining",
                    value: "907",
                    icon: Icons.auto_stories,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // MILESTONES
            const Text(
              "Milestones",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 14),

            Column(
              children: const [
                _MilestoneTile(title: "25% Completed", completed: true),
                _MilestoneTile(title: "50% Completed", completed: false),
                _MilestoneTile(title: "75% Completed", completed: false),
                _MilestoneTile(title: "100% Completed", completed: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFD4AF37)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  final String title;
  final bool completed;

  const _MilestoneTile({required this.title, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).cardColor,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: completed ? Colors.green : Colors.grey,
          child: Icon(
            completed ? Icons.check : Icons.lock_outline,
            color: Colors.white,
          ),
        ),
        title: Text(title),
      ),
    );
  }
}
