import 'package:flutter/material.dart';

void main() {
  runApp(const NutritionApp());
}

class FoodItem {
  final String name;
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final String category;

  FoodItem({
    required this.name,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.category,
  });
}

class LoggedMeal {
  final String name;
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final String mealType;

  LoggedMeal({
    required this.name,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealType,
  });
}

class ChatMessage {
  final String sender;
  final String text;
  final bool isUser;

  ChatMessage({required this.sender, required this.text, required this.isUser});
}

class NutritionApp extends StatelessWidget {
  const NutritionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriLife Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          surface: const Color(0xFFF7F9F8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9F8),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  double userAge = 28;
  double userWeight = 75.0;
  double userHeight = 178.0;
  String userGender = 'Male';
  String userGoal = 'Weight Loss';

  int waterConsumed = 750;
  final int waterGoal = 2500;

  final List<FoodItem> foodDatabase = [
    FoodItem(name: 'Chicken Breast (100g)', kcal: 165, protein: 31, carbs: 0, fat: 3.6, category: 'High Protein'),
    FoodItem(name: 'Eggs (2 large)', kcal: 140, protein: 12, carbs: 1, fat: 10, category: 'High Protein'),
    FoodItem(name: 'Greek Yogurt (150g)', kcal: 130, protein: 15, carbs: 6, fat: 4, category: 'High Protein'),
    FoodItem(name: 'Brown Rice (150g)', kcal: 165, protein: 3.5, carbs: 35, fat: 1.3, category: 'Low Carb'),
    FoodItem(name: 'Avocado (100g)', kcal: 160, protein: 2, carbs: 8.5, fat: 14.7, category: 'High Fiber'),
    FoodItem(name: 'Oatmeal (50g)', kcal: 190, protein: 7, carbs: 34, fat: 3, category: 'High Fiber'),
    FoodItem(name: 'Salmon Fillet (150g)', kcal: 312, protein: 30, carbs: 0, fat: 20, category: 'High Protein'),
    FoodItem(name: 'Apple (1 medium)', kcal: 95, protein: 0.5, carbs: 25, fat: 0.3, category: 'High Fiber'),
  ];

  List<LoggedMeal> dailyLog = [
    LoggedMeal(name: 'Oatmeal & Banana', kcal: 280, protein: 8, carbs: 52, fat: 4, mealType: 'Breakfast'),
    LoggedMeal(name: 'Greek Yogurt', kcal: 130, protein: 15, carbs: 6, fat: 4, mealType: 'Breakfast'),
    LoggedMeal(name: 'Grilled Chicken Salad', kcal: 420, protein: 38, carbs: 15, fat: 18, mealType: 'Lunch'),
  ];

  final List<Map<String, dynamic>> weightHistory = [
    {'day': 'Week 1', 'weight': 78.0},
    {'day': 'Week 2', 'weight': 77.2},
    {'day': 'Week 3', 'weight': 76.5},
    {'day': 'Week 4', 'weight': 75.8},
    {'day': 'Current', 'weight': 75.0},
  ];

  List<ChatMessage> chatMessages = [
    ChatMessage(
      sender: 'NutriBot',
      text: 'Hello! I am your AI Nutrition Coach. How can I help you reach your goals today?',
      isUser: false,
    )
  ];

  double get goalKcal {
    double bmr = (10 * userWeight) + (6.25 * userHeight) - (5 * userAge) + (userGender == 'Male' ? 5 : -161);
    double tdee = bmr * 1.55;
    if (userGoal == 'Weight Loss') return (tdee - 500).roundToDouble();
    if (userGoal == 'Muscle Gain') return (tdee + 300).roundToDouble();
    return tdee.roundToDouble();
  }

  double get targetProtein => (goalKcal * 0.30) / 4;
  double get targetCarbs => (goalKcal * 0.45) / 4;
  double get targetFat => (goalKcal * 0.25) / 9;

  double get totalKcal => dailyLog.fold(0, (sum, item) => sum + item.kcal);
  double get totalProtein => dailyLog.fold(0, (sum, item) => sum + item.protein);
  double get totalCarbs => dailyLog.fold(0, (sum, item) => sum + item.carbs);
  double get totalFat => dailyLog.fold(0, (sum, item) => sum + item.fat);

  void _addWater(int amount) {
    setState(() {
      waterConsumed += amount;
    });
  }

  void _addMeal(FoodItem food, String mealType) {
    setState(() {
      dailyLog.add(LoggedMeal(
        name: food.name,
        kcal: food.kcal,
        protein: food.protein,
        carbs: food.carbs,
        fat: food.fat,
        mealType: mealType,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${food.name} added to $mealType!'), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardTab(),
      _buildLogFoodTab(),
      _buildFoodDatabaseTab(),
      _buildProgressTab(),
      _buildAIChatTab(),
      _buildProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('NutriLife Health', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: 'Log'),
          NavigationDestination(icon: Icon(Icons.search), selectedIcon: Icon(Icons.saved_search), label: 'Database'),
          NavigationDestination(icon: Icon(Icons.show_chart), selectedIcon: Icon(Icons.multiline_chart), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.smart_toy_outlined), selectedIcon: Icon(Icons.smart_toy), label: 'AI Coach'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    double progress = (totalKcal / goalKcal).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Daily Calorie Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 140,
                      width: 140,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.teal.shade50,
                        color: progress > 0.9 ? Colors.orange : Colors.teal,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${totalKcal.round()}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        Text('/ ${goalKcal.round()} kcal', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statBadge('Remaining', '${(goalKcal - totalKcal).round()} kcal', Colors.teal),
                    _statBadge('Goal', '${goalKcal.round()} kcal', Colors.grey.shade700),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Macronutrients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _macroRow('Protein', totalProtein, targetProtein, Colors.blue),
                const SizedBox(height: 10),
                _macroRow('Carbs', totalCarbs, targetCarbs, Colors.orange),
                const SizedBox(height: 10),
                _macroRow('Fat', totalFat, targetFat, Colors.redAccent),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.lightBlue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.water_drop, color: Colors.blue, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Water Tracker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('$waterConsumed / $waterGoal ml', style: TextStyle(color: Colors.blue.shade900)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addWater(250),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('+250ml'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statBadge(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _macroRow(String label, double current, double target, Color color) {
    double ratio = (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${current.round()}g / ${target.round()}g', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: ratio,
          backgroundColor: color.withOpacity(0.15),
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildLogFoodTab() {
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: mealTypes.map((type) {
        final items = dailyLog.where((m) => m.mealType == type).toList();
        final totalMealKcal = items.fold(0.0, (sum, i) => sum + i.kcal);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(type, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                    Text('${totalMealKcal.round()} kcal', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('No food logged for this meal.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  )
                else
                  ...items.map((item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text('P: ${item.protein}g | C: ${item.carbs}g | F: ${item.fat}g'),
                        trailing: Text('${item.kcal.round()} kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
                      )),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() => _currentIndex = 2);
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: Text('Add to $type'),
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFoodDatabaseTab() {
    String searchQuery = '';
    String selectedCategory = 'All';

    return StatefulBuilder(
      builder: (context, setTabState) {
        final filteredFood = foodDatabase.where((item) {
          final matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase());
          final matchesCategory = selectedCategory == 'All' || item.category == selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search food database...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
                onChanged: (val) => setTabState(() => searchQuery = val),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: ['All', 'High Protein', 'Low Carb', 'High Fiber'].map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: Colors.teal.shade100,
                      onSelected: (selected) {
                        if (selected) setTabState(() => selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredFood.length,
                itemBuilder: (context, index) {
                  final food = filteredFood[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${food.kcal} kcal | P: ${food.protein}g C: ${food.carbs}g F: ${food.fat}g'),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.add_circle, color: Colors.teal),
                        onSelected: (mealType) => _addMeal(food, mealType),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'Breakfast', child: Text('Add to Breakfast')),
                          const PopupMenuItem(value: 'Lunch', child: Text('Add to Lunch')),
                          const PopupMenuItem(value: 'Dinner', child: Text('Add to Dinner')),
                          const PopupMenuItem(value: 'Snack', child: Text('Add to Snack')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weight Log History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: weightHistory.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['day'], style: const TextStyle(fontSize: 16)),
                        Text('${item['weight']} kg', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.teal, size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You have lost 3.0 kg over 4 weeks! Keep going to reach your goal weight of 72 kg.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAIChatTab() {
    final TextEditingController textController = TextEditingController();

    void sendMessage(String query) {
      if (query.trim().isEmpty) return;

      setState(() {
        chatMessages.add(ChatMessage(sender: 'User', text: query, isUser: true));
      });

      String response = "Based on your current goal ($userGoal) and today's logs:\n";
      if (query.toLowerCase().contains('protein')) {
        double remP = targetProtein - totalProtein;
        response += "You have consumed ${totalProtein.round()}g protein out of ${targetProtein.round()}g. You still need about ${remP > 0 ? remP.round() : 0}g. Try eating 150g Grilled Chicken Breast or 2 Eggs.";
      } else if (query.toLowerCase().contains('dinner') || query.toLowerCase().contains('meal')) {
        double remKcal = goalKcal - totalKcal;
        response += "You have ${remKcal.round()} kcal remaining today. I suggest: Salmon Fillet (150g) with Steamed Broccoli for a high-protein dinner under 400 kcal.";
      } else {
        response += "Your calorie deficit is looking good today! Stay hydrated and keep your protein intake high.";
      }

      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          chatMessages.add(ChatMessage(sender: 'NutriBot', text: response, isUser: false));
        });
      });

      textController.clear();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              final msg = chatMessages[index];
              return Align(
                alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: msg.isUser ? Colors.teal : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  child: Text(
                    msg.text,
                    style: TextStyle(color: msg.isUser ? Colors.white : Colors.black87, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Ask AI Assistant...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.teal),
                onPressed: () => sendMessage(textController.text),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('User Profile & Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Age'),
                  trailing: Text('${userAge.round()} yrs'),
                ),
                ListTile(
                  title: const Text('Weight'),
                  trailing: Text('${userWeight} kg'),
                ),
                ListTile(
                  title: const Text('Height'),
                  trailing: Text('${userHeight.round()} cm'),
                ),
                ListTile(
                  title: const Text('Goal'),
                  trailing: DropdownButton<String>(
                    value: userGoal,
                    items: ['Weight Loss', 'Maintain', 'Muscle Gain'].map((g) {
                      return DropdownMenuItem(value: g, child: Text(g));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => userGoal = val);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
