import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, _) => MaterialApp(
        title: 'Lab 4 - Flutter Widgets',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const HomeMenu(),
      ),
    );
  }
}

//Home menu
class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, Widget)>[
      ('Core Example', 'Icon & Image widgets', const CoreExampleScreen()),
      ('Task 1', 'Checkbox & Switch', const Task1Screen()),
      ('Task 2', 'TextFormField login', const Task2Screen()),
      ('Task 3', 'FAB & buttons counter', const Task3Screen()),
      ('Task 4', 'Progress indicator & SnackBar', const Task4Screen()),
      ('Task 5', 'AlertDialog & bottom sheet', const Task5Screen()),
      ('Task 6', 'Slider & date picker', const Task6Screen()),
      ('Task 7', 'ListView.builder & Dismissible', const Task7Screen()),
      ('Task 8', 'GridView.count gallery', const Task8Screen()),
      ('Task 9.1', 'BottomNavigationBar', const Task9BottomNavScreen()),
      ('Task 9.2', 'TabBar & TabBarView', const Task9TabBarScreen()),
      ('Task 10', 'Card & ExpansionTile', const Task10Screen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4: Flutter Mobile Widgets')),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final (title, subtitle, page) = items[i];
          return ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            ),
          );
        },
      ),
    );
  }
}

//Core example
class CoreExampleScreen extends StatelessWidget {
  const CoreExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Core Example')),
        body: const Center(child: MediaProfileCard()),
      );
}

class MediaProfileCard extends StatefulWidget {
  const MediaProfileCard({super.key});

  @override
  State<MediaProfileCard> createState() => _MediaProfileCardState();
}

class _MediaProfileCardState extends State<MediaProfileCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                'assets/profile.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'User Profile Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 28.0,
              ),
              onPressed: () => setState(() => isFavorite = !isFavorite),
            ),
          ],
        ),
      ),
    );
  }
}

//Task 1
class Task1Screen extends StatefulWidget {
  const Task1Screen({super.key});

  @override
  State<Task1Screen> createState() => _Task1ScreenState();
}

class _Task1ScreenState extends State<Task1Screen> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, mode, _) => SwitchListTile(
              title: const Text('Dark Mode'),
              secondary: const Icon(Icons.dark_mode),
              value: mode == ThemeMode.dark,
              onChanged: (v) =>
                  themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light,
            ),
          ),
          CheckboxListTile(
            title: const Text('Agree to Terms'),
            value: agreed,
            onChanged: (v) => setState(() => agreed = v ?? false),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            // null onPressed => button is disabled
            onPressed: agreed
                ? () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms accepted!')),
                    )
                : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

//Task 2
class Task2Screen extends StatefulWidget {
  const Task2Screen({super.key});

  @override
  State<Task2Screen> createState() => _Task2ScreenState();
}

class _Task2ScreenState extends State<Task2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in as ${_emailCtrl.text}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Email must contain @';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Password is required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Task 3
class Task3Screen extends StatefulWidget {
  const Task3Screen({super.key});

  @override
  State<Task3Screen> createState() => _Task3ScreenState();
}

class _Task3ScreenState extends State<Task3Screen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have pushed the button this many times:'),
            Text('$counter', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              onPressed: () => setState(() => counter = 0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => counter++),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

//Task 4
class Task4Screen extends StatefulWidget {
  const Task4Screen({super.key});

  @override
  State<Task4Screen> createState() => _Task4ScreenState();
}

class _Task4ScreenState extends State<Task4Screen> {
  bool loading = false;

  Future<void> _run() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Operation completed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Action undone')),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Indicators & Feedback')),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: loading ? null : _run,
              child: const Text('Start 3-second task'),
            ),
          ),
          if (loading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x55000000),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

//Task 5
class Task5Screen extends StatelessWidget {
  const Task5Screen({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Item deleted')));
    }
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        Widget option(IconData icon, String label) => ListTile(
              leading: Icon(icon),
              title: Text(label),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Shared via $label')),
                );
              },
            );
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              option(Icons.message, 'Message'),
              option(Icons.email, 'Email'),
              option(Icons.link, 'Copy link'),
              option(Icons.more_horiz, 'More'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialogs & Modals')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Delete item'),
              onPressed: () => _confirmDelete(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              onPressed: () => _showShareSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

//Task 6
class Task6Screen extends StatefulWidget {
  const Task6Screen({super.key});

  @override
  State<Task6Screen> createState() => _Task6ScreenState();
}

class _Task6ScreenState extends State<Task6Screen> {
  double volume = 50;
  DateTime? picked;

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: picked ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => picked = d);
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sliders & Pickers')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              volume == 0 ? Icons.volume_off : Icons.volume_up,
              size: 48,
            ),
            Text('Volume: ${volume.round()}%',
                style: Theme.of(context).textTheme.headlineSmall),
            Slider(
              value: volume,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${volume.round()}%',
              onChanged: (v) => setState(() => volume = v),
            ),
            const Divider(height: 48),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Pick a date'),
              onPressed: _pickDate,
            ),
            const SizedBox(height: 12),
            Text(
              picked == null ? 'No date selected' : 'Selected: ${_fmt(picked!)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

//Task 7
class Task7Screen extends StatefulWidget {
  const Task7Screen({super.key});

  @override
  State<Task7Screen> createState() => _Task7ScreenState();
}

class _Task7ScreenState extends State<Task7Screen> {
  final List<String> items = List.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swipe to dismiss')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: ValueKey(item),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              setState(() => items.removeAt(index));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$item dismissed')),
              );
            },
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(item),
              subtitle: const Text('Swipe left or right to remove'),
            ),
          );
        },
      ),
    );
  }
}

//Task 8
class Task8Screen extends StatelessWidget {
  const Task8Screen({super.key});

  static const _colors = [
    Colors.indigo, Colors.teal, Colors.orange, Colors.pink,
    Colors.green, Colors.purple, Colors.blue, Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding: const EdgeInsets.all(12),
        children: List.generate(_colors.length, (i) {
          final color = _colors[i];
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullscreenPreview(index: i, color: color),
              ),
            ),
            child: Hero(
              tag: 'photo$i',
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.image, color: Colors.white, size: 48),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FullscreenPreview extends StatelessWidget {
  final int index;
  final Color color;
  const FullscreenPreview({super.key, required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Photo ${index + 1}'),
      ),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Hero(
          tag: 'photo$index',
          child: Container(
            color: color,
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: Icon(Icons.image, color: Colors.white, size: 120),
            ),
          ),
        ),
      ),
    );
  }
}

//Task 9.1
class Task9BottomNavScreen extends StatefulWidget {
  const Task9BottomNavScreen({super.key});

  @override
  State<Task9BottomNavScreen> createState() => _Task9BottomNavScreenState();
}

class _Task9BottomNavScreenState extends State<Task9BottomNavScreen> {
  int _index = 0;

  static const _pages = [
    Center(child: Text('Home View', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search View', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile View', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bottom Navigation')),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

//Task 9.2
class Task9TabBarScreen extends StatelessWidget {
  const Task9TabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: 'Chats'),
              Tab(icon: Icon(Icons.circle_outlined), text: 'Status'),
              Tab(icon: Icon(Icons.call), text: 'Calls'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Chats Tab', style: TextStyle(fontSize: 24))),
            Center(child: Text('Status Tab', style: TextStyle(fontSize: 24))),
            Center(child: Text('Calls Tab', style: TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}

//Task 10
class Task10Screen extends StatelessWidget {
  const Task10Screen({super.key});

  static const _faqs = [
    (
      'What is Flutter?',
      'Flutter is Google\'s UI toolkit for building natively compiled apps for mobile, web and desktop from a single codebase.'
    ),
    (
      'What is a StatefulWidget?',
      'A widget that owns mutable state. Calling setState() tells Flutter to rebuild it with the new values.'
    ),
    (
      'How do I add assets?',
      'Place files in an assets/ folder and list them under the flutter: assets: section of pubspec.yaml.'
    ),
    (
      'What is hot reload?',
      'It injects updated source code into the running app, preserving state, so UI changes appear in under a second.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cards & FAQ')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.info, size: 40, color: Colors.indigo),
              title: const Text('Information Card',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('A header, subtitle, leading icon and action.'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card action pressed')),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: Text('FAQ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          for (final (q, a) in _faqs)
            Card(
              child: ExpansionTile(
                title: Text(q),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedAlignment: Alignment.centerLeft,
                children: [Text(a)],
              ),
            ),
        ],
      ),
    );
  }
}