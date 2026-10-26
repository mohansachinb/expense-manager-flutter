import 'package:flutter/material.dart';

import 'screens/transaction_history_screen.dart';
import 'models/transaction_model.dart';
import 'screens/add_transaction_screen.dart';
import 'services/database_service.dart';

void main() {
  runApp(const ExpenseManagerApp());
}

class AppColors {
  static const midnight = Color(0xFF0B1220);
  static const darkSurface = Color(0xFF111F32);
  static const teal = Color(0xFF2DD4BF);
  static const violet = Color(0xFFA78BFA);
  static const pink = Color(0xFFF4A7C5);
  static const lightBackground = Color(0xFFF5F8FC);
  static const lightTeal = Color(0xFF0F9F91);
}

class ExpenseManagerApp extends StatefulWidget {
  const ExpenseManagerApp({super.key});

  @override
  State<ExpenseManagerApp> createState() => _ExpenseManagerAppState();
}

class _ExpenseManagerAppState extends State<ExpenseManagerApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.lightTeal,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          foregroundColor: Color(0xFF172033),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.midnight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.teal,
          brightness: Brightness.dark,
          surface: AppColors.darkSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.midnight,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: WelcomeScreen(
        onToggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const WelcomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -90,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.violet.withValues(alpha: 0.10),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -90,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.teal.withValues(alpha: 0.09),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                tooltip: 'Toggle theme',
                onPressed: onToggleTheme,
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 36,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.teal.withValues(alpha: 0.30),
                        ),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 48,
                        color: AppColors.teal,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Expense Manager',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Smart Spending, Better Living',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.72),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 38),
                    const _AnimatedLotus(),
                    const SizedBox(height: 18),
                    Text(
                      '— BRAJ MOHAN —',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.pink
                            : const Color(0xFFAD5279),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Take control of your money.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 42),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DashboardScreen(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          foregroundColor: AppColors.midnight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'YOUR MONEY. YOUR CONTROL.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 2,
                        color: colors.onSurface.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedLotus extends StatefulWidget {
  const _AnimatedLotus();

  @override
  State<_AnimatedLotus> createState() => _AnimatedLotusState();
}

class _AnimatedLotusState extends State<_AnimatedLotus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _tiltAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _tiltAnimation = Tween<double>(
      begin: -0.045,
      end: 0.045,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _glowAnimation = Tween<double>(
      begin: 0.10,
      end: 0.28,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: const Text('🪷', style: TextStyle(fontSize: 92)),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.rotate(
            angle: _tiltAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pink.withValues(
                      alpha: _glowAnimation.value,
                    ),
                    blurRadius: 34,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String? _error;
  double _monthlyBudget = 0;
  double _monthlySpent = 0;
  String? _lastBudgetAlertKey;

  Future<void> _checkBudgetAlert() async {
    if (!mounted || _monthlyBudget <= 0) return;

    final ratio = _monthlySpent / _monthlyBudget;

    if (ratio < 0.8) {
      _lastBudgetAlertKey = '';
      return;
    }

    final level = ratio >= 1.0 ? 100 : 80;
    final alertKey =
        '${DateTime.now().year}-'
        '${DateTime.now().month}-$level';

    // Same alert ko baar-baar dikhne se roko.
    if (_lastBudgetAlertKey == alertKey) return;

    _lastBudgetAlertKey = alertKey;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          level == 100
              ? Icons.warning_amber_rounded
              : Icons.notifications_active_rounded,
          size: 42,
          color: level == 100 ? Colors.redAccent : AppColors.violet,
        ),
        title: Text(
          level == 100 ? 'Monthly Budget Reached!' : 'Budget Alert: 80%',
        ),
        content: Text(
          level == 100
              ? 'Your monthly spending has reached or exceeded your budget.\n\n'
                    'Spent: ₹${_monthlySpent.toStringAsFixed(2)}\n'
                    'Budget: ₹${_monthlyBudget.toStringAsFixed(2)}'
              : 'You have used 80% or more of your monthly budget.\n\n'
                    'Spent: ₹${_monthlySpent.toStringAsFixed(2)}\n'
                    'Remaining: ₹${(_monthlyBudget - _monthlySpent).toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final results = await Future.wait<dynamic>([
        DatabaseService.instance.getTransactions(),
        DatabaseService.instance.getMonthlyBudget(),
      ]);

      final transactions = results[0] as List<TransactionModel>;
      final budget = (results[1] as num).toDouble();

      final now = DateTime.now();

      final spent = transactions
          .where((transaction) {
            return transaction.type.toLowerCase() == 'expense' &&
                transaction.date.year == now.year &&
                transaction.date.month == now.month;
          })
          .fold<double>(
            0.0,
            (total, transaction) => total + transaction.amount,
          );

      // Temporary debugging logs for budget alert troubleshooting.
      debugPrint('Monthly budget loaded: ₹$budget');
      debugPrint('Monthly expenses calculated: ₹$spent');

      if (!mounted) return;

      setState(() {
        _transactions = transactions;
        _monthlyBudget = budget;
        _monthlySpent = spent;
        _isLoading = false;
        _error = null;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _checkBudgetAlert();
        }
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = error.toString();
      });

      debugPrint('Budget alert loading error: $error');
    }
  }

  Future<void> _openAddTransaction() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );

    if (result == true) {
      await _loadTransactions();
    }
  }

  double get _totalIncome => _transactions
      .where((item) => item.type.toLowerCase() == 'income')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _totalExpenses => _transactions
      .where((item) => item.type.toLowerCase() == 'expense')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _thisMonthExpenses {
    final now = DateTime.now();
    return _transactions
        .where(
          (item) =>
              item.type.toLowerCase() == 'expense' &&
              item.date.year == now.year &&
              item.date.month == now.month,
        )
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  String _money(double amount) => '₹ ${amount.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Overview',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Transaction History',
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const TransactionHistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Refresh transactions',
            onPressed: _loadTransactions,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTransaction,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Transaction'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Your financial journey, at a glance.',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF123B45),
                    Color(0xFF111F32),
                    Color(0xFF282345),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.teal.withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL BALANCE',
                        style: TextStyle(
                          color: Color(0xFFB9D2D5),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppColors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (_isLoading)
                    const CircularProgressIndicator(color: AppColors.teal)
                  else
                    Text(
                      _money(_totalIncome - _totalExpenses),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.7,
                      ),
                    ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.teal,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Income minus expenses',
                        style: TextStyle(color: Color(0xFFB9D2D5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Income',
                    amount: _money(_totalIncome),
                    icon: Icons.south_west_rounded,
                    color: const Color(0xFF34D399),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Expenses',
                    amount: _money(_totalExpenses),
                    icon: Icons.north_east_rounded,
                    color: const Color(0xFFFB7185),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.violet.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.violet.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.violet,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Monthly spending',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              DateFormatters.monthYear(DateTime.now()),
                              style: TextStyle(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      if (!_isLoading)
                        Text(
                          _money(_thisMonthExpenses),
                          style: const TextStyle(
                            color: AppColors.violet,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: _totalExpenses <= 0
                          ? 0
                          : (_thisMonthExpenses / _totalExpenses).clamp(
                              0.0,
                              1.0,
                            ),
                      minHeight: 7,
                      backgroundColor: colors.onSurface.withValues(alpha: 0.08),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.violet,
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Expenses recorded during the current month',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _ExpenseBreakdownCard(
              transactions: _transactions,
              moneyFormatter: _money,
            ),
            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text('${_transactions.length} total'),
              ],
            ),
            const SizedBox(height: 12),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Could not load local transactions.'),
                      const SizedBox(height: 8),
                      Text(_error!, style: TextStyle(color: colors.error)),
                      TextButton(
                        onPressed: _loadTransactions,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_transactions.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 42,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No transactions yet',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Add your first income or expense.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._transactions.take(10).map((transaction) {
                final isIncome = transaction.type.toLowerCase() == 'income';
                final amountColor = isIncome
                    ? const Color(0xFF34D399)
                    : const Color(0xFFFB7185);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: amountColor.withValues(alpha: 0.14),
                      child: Icon(
                        isIncome
                            ? Icons.south_west_rounded
                            : Icons.north_east_rounded,
                        color: amountColor,
                      ),
                    ),
                    title: Text(
                      transaction.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${transaction.category} • '
                      '${transaction.date.day.toString().padLeft(2, '0')}/'
                      '${transaction.date.month.toString().padLeft(2, '0')}/'
                      '${transaction.date.year}',
                    ),
                    trailing: Text(
                      '${isIncome ? '+' : '-'}${_money(transaction.amount)}',
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _ExpenseBreakdownCard extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String Function(double) moneyFormatter;

  const _ExpenseBreakdownCard({
    required this.transactions,
    required this.moneyFormatter,
  });

  static const List<Color> _palette = [
    AppColors.violet,
    AppColors.teal,
    Color(0xFFFBBF24),
    Color(0xFFFB7185),
    Color(0xFF60A5FA),
    Color(0xFF34D399),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final expenses = transactions
        .where((item) => item.type.toLowerCase() == 'expense')
        .toList();
    final Map<String, double> totals = {};
    for (final item in expenses) {
      final category = item.category.trim().isEmpty ? 'Other' : item.category;
      totals[category] = (totals[category] ?? 0) + item.amount;
    }
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<double>(0, (sum, item) => sum + item.value);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expense Breakdown',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'See where your money goes',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 18),
          if (total <= 0)
            SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'Add an expense to see your chart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            )
          else ...[
            Center(
              child: SizedBox(
                width: 172,
                height: 172,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(172, 172),
                      painter: _PieChartPainter(
                        values: entries.map((e) => e.value).toList(),
                        colors: List.generate(
                          entries.length,
                          (index) => _palette[index % _palette.length],
                        ),
                        trackColor: colors.onSurface.withValues(alpha: 0.07),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total expenses',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          moneyFormatter(total),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...entries.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final color = _palette[index % _palette.length];
              final percent = total == 0 ? 0 : item.value / total * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${percent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      moneyFormatter(item.value),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final Color trackColor;

  const _PieChartPainter({
    required this.values,
    required this.colors,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.16;
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final background = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, background);

    final total = values.fold<double>(0, (sum, value) => sum + value);
    if (total <= 0) return;
    var startAngle = -1.57079632679;
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] / total * 6.28318530718;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.colors != colors ||
      oldDelegate.trackColor != trackColor;
}

class DateFormatters {
  static String monthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              amount,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
