import 'dart:async';

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
  bool _showWelcome = true;
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
      home: _showWelcome
          ? WelcomeFlow(
              isDark: _themeMode == ThemeMode.dark,
              onToggleTheme: _toggleTheme,
              onFinished: () {
                if (mounted) setState(() => _showWelcome = false);
              },
            )
          : const DashboardScreen(),
    );
  }
}

class WelcomeFlow extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onFinished;

  const WelcomeFlow({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onFinished,
  });

  @override
  State<WelcomeFlow> createState() => _WelcomeFlowState();
}

class _WelcomeFlowState extends State<WelcomeFlow> {
  final PageController _pageController = PageController();
  Timer? _autoAdvanceTimer;
  int _page = 0;
  static const Duration _pageDuration = Duration(seconds: 7);
  static const Duration _transitionDuration = Duration(milliseconds: 650);

  @override
  void initState() {
    super.initState();
    _scheduleAutoAdvance();
  }

  void _scheduleAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(_pageDuration, () {
      if (!mounted) return;
      _next();
    });
  }

  void _skip() {
    _autoAdvanceTimer?.cancel();
    widget.onFinished();
  }

  // New onboarding content based on the four reference screens supplied:
  // splash screen, Track Expenses, Secure & Private, and Savings Goals.
  static const _pages = <_WelcomePageData>[
    _WelcomePageData(
      title: 'Budget Buddy',
      subtitle: 'Achieve more together',
      description:
          'A smarter way to understand your money and build better habits.',
      illustration: _WelcomeIllustration.budget,
    ),
    _WelcomePageData(
      title: 'Track Expenses with Ease',
      subtitle: 'Stay on top of your spending',
      description: 'Stay on top of your spending with real-time tracking, easy categorization, and instant updates.',
      illustration: _WelcomeIllustration.tracking,
    ),
    _WelcomePageData(
      title: 'Your Data, Secure and Private',
      subtitle: 'Your privacy comes first',
      description: 'Rest assured with bank-level encryption and privacy controls that keep your information safe every step of the way.',
      illustration: _WelcomeIllustration.security,
    ),
    _WelcomePageData(
      title: 'Achieve Savings Goals as a Team',
      subtitle: 'Make progress together',
      description: 'Share goals and track progress with visual milestones. Make it easy to save for trips, emergencies, and more.',
      illustration: _WelcomeIllustration.savings,
    ),
  ];

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    _autoAdvanceTimer?.cancel();
    if (_page == _pages.length - 1) {
      widget.onFinished();
      return;
    }
    _pageController.nextPage(
      duration: _transitionDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skip,
                    child: Text(_page == 0 ? 'Skip intro' : 'Skip'),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: widget.isDark
                            ? 'Switch to light theme'
                            : 'Switch to dark theme',
                        onPressed: widget.onToggleTheme,
                        icon: Icon(
                          widget.isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _page = index);
                  _scheduleAutoAdvance();
                },
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(28, 8, 28, 12),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: _WelcomeIllustrationView(
                              kind: item.illustration,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? const Color(0xFF064E4A)
                                  : const Color(0xFFDDF8EE),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        height: 1.15,
                                        color: widget.isDark
                                            ? Colors.white
                                            : const Color(0xFF123B39),
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.subtitle,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: widget.isDark
                                        ? AppColors.teal
                                        : AppColors.lightTeal,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: widget.isDark
                                        ? Colors.white.withValues(alpha: 0.78)
                                        : const Color(0xFF315B56),
                                    height: 1.45,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(_pages.length, (
                                    dotIndex,
                                  ) {
                                    final selected = dotIndex == _page;
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: selected ? 22 : 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? (widget.isDark
                                                  ? AppColors.teal
                                                  : AppColors.lightTeal)
                                            : (widget.isDark
                                                  ? Colors.white38
                                                  : Colors.black26),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: FilledButton(
                                    onPressed: _next,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFFB8FFD0),
                                      foregroundColor: const Color(0xFF124A3C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      _page == _pages.length - 1
                                          ? 'Get Started'
                                          : 'Next',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '— BRAJ MOHAN —',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w700,
                  color: widget.isDark
                      ? AppColors.pink
                      : const Color(0xFFAD5279),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomePageData {
  final String title;
  final String subtitle;
  final String description;
  final _WelcomeIllustration illustration;

  const _WelcomePageData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.illustration,
  });
}

enum _WelcomeIllustration { budget, security, tracking, savings }

class _WelcomeIllustrationView extends StatelessWidget {
  final _WelcomeIllustration kind;
  const _WelcomeIllustrationView({required this.kind});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF123E3D) : const Color(0xFFC7F1E5);
    final green = isDark ? const Color(0xFF6AF0A2) : const Color(0xFF15966D);
    final pale = isDark ? const Color(0xFFB8FFD0) : const Color(0xFF087E69);
    final icon = switch (kind) {
      _WelcomeIllustration.budget => Icons.savings_rounded,
      _WelcomeIllustration.security => Icons.shield_rounded,
      _WelcomeIllustration.tracking => Icons.analytics_rounded,
      _WelcomeIllustration.savings => Icons.account_balance_wallet_rounded,
    };
    final label = switch (kind) {
      _WelcomeIllustration.budget => 'BUDGET BUDDY',
      _WelcomeIllustration.security => 'PRIVATE & SECURE',
      _WelcomeIllustration.tracking => 'SPENDING INSIGHTS',
      _WelcomeIllustration.savings => 'SAVINGS GOALS',
    };

    return Container(
      constraints: const BoxConstraints(maxWidth: 340, maxHeight: 330),
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: green.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.17),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 60, color: green),
          ),
          const SizedBox(height: 20),
          if (kind == _WelcomeIllustration.tracking)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Bar(height: 42, color: green),
                const SizedBox(width: 10),
                _Bar(height: 72, color: pale),
                const SizedBox(width: 10),
                _Bar(height: 54, color: green),
                const SizedBox(width: 10),
                _Bar(height: 88, color: pale),
              ],
            )
          else if (kind == _WelcomeIllustration.savings)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.savings_rounded, size: 42, color: green),
                const SizedBox(width: 14),
                Icon(Icons.trending_up_rounded, size: 42, color: pale),
                const SizedBox(width: 14),
                Icon(Icons.savings_rounded, size: 42, color: green),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.currency_rupee_rounded, size: 32, color: pale),
                const SizedBox(width: 14),
                Icon(Icons.check_circle_rounded, size: 32, color: green),
                const SizedBox(width: 14),
                Icon(Icons.currency_rupee_rounded, size: 32, color: pale),
              ],
            ),
          const SizedBox(height: 22),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF164E45),
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;
  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(7),
    ),
  );
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
            const SizedBox(height: 20),
            _CandlestickChartCard(transactions: _transactions),
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

class _CandlestickChartCard extends StatelessWidget {
  final List<TransactionModel> transactions;

  const _CandlestickChartCard({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final monthItems =
        transactions
            .where(
              (item) =>
                  item.date.year == now.year && item.date.month == now.month,
            )
            .toList()
          ..sort((a, b) {
            final dateCompare = a.date.compareTo(b.date);
            if (dateCompare != 0) return dateCompare;
            return (a.id ?? 0).compareTo(b.id ?? 0);
          });

    final Map<int, List<TransactionModel>> byDay = {};
    for (final item in monthItems) {
      byDay.putIfAbsent(item.date.day, () => []).add(item);
    }
    final candles = <_CandleData>[];
    var runningBalance = 0.0;
    for (final entry in byDay.entries) {
      final open = runningBalance;
      var high = open;
      var low = open;
      for (final item in entry.value) {
        final isIncome = item.type.toLowerCase() == 'income';
        runningBalance += isIncome ? item.amount : -item.amount;
        if (runningBalance > high) high = runningBalance;
        if (runningBalance < low) low = runningBalance;
      }
      candles.add(
        _CandleData(
          day: entry.key,
          open: open,
          high: high,
          low: low,
          close: runningBalance,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.violet.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cash Flow Candlestick Chart',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Daily balance movement • ${DateFormatters.monthYear(now)}',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 18),
          if (candles.isEmpty)
            SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'Add this month’s transactions to see the candlestick chart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            )
          else
            SizedBox(
              height: 190,
              width: double.infinity,
              child: CustomPaint(
                painter: _CandlestickPainter(
                  candles: candles,
                  positiveColor: AppColors.teal,
                  negativeColor: const Color(0xFFFB7185),
                  axisColor: colors.onSurface.withValues(alpha: 0.22),
                  labelColor: colors.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.circle, color: AppColors.teal, size: 10),
              SizedBox(width: 6),
              Text('Balance increased', style: TextStyle(fontSize: 11)),
              SizedBox(width: 16),
              Icon(Icons.circle, color: Color(0xFFFB7185), size: 10),
              SizedBox(width: 6),
              Text('Balance decreased', style: TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CandleData {
  final int day;
  final double open, high, low, close;
  const _CandleData({
    required this.day,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

class _CandlestickPainter extends CustomPainter {
  final List<_CandleData> candles;
  final Color positiveColor, negativeColor, axisColor, labelColor;
  const _CandlestickPainter({
    required this.candles,
    required this.positiveColor,
    required this.negativeColor,
    required this.axisColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty || size.width <= 0 || size.height <= 0) return;
    const left = 8.0, right = 8.0, top = 8.0, bottom = 24.0;
    final plot = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    var minValue = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    var maxValue = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    if ((maxValue - minValue).abs() < 0.01) {
      minValue -= 1;
      maxValue += 1;
    }
    final range = maxValue - minValue;
    double y(double value) =>
        plot.bottom - ((value - minValue) / range) * plot.height;
    final gridPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 0.7;
    for (var i = 0; i < 4; i++) {
      final gy = plot.top + plot.height * i / 3;
      canvas.drawLine(Offset(plot.left, gy), Offset(plot.right, gy), gridPaint);
    }
    final slot = plot.width / candles.length;
    final bodyWidth = (slot * 0.52).clamp(3.0, 14.0);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = plot.left + slot * (i + 0.5);
      final color = c.close >= c.open ? positiveColor : negativeColor;
      final wick = Paint()
        ..color = color
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(x, y(c.high)), Offset(x, y(c.low)), wick);
      final topY = y(c.open < c.close ? c.close : c.open);
      final bottomY = y(c.open < c.close ? c.open : c.close);
      final body = Rect.fromLTRB(
        x - bodyWidth / 2,
        topY,
        x + bodyWidth / 2,
        (bottomY - topY).abs() < 2 ? topY + 2 : bottomY,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(body, const Radius.circular(2)),
        Paint()..color = color,
      );
      if (candles.length <= 12 ||
          i == 0 ||
          i == candles.length - 1 ||
          i % 5 == 0) {
        textPainter.text = TextSpan(
          text: '${c.day}',
          style: TextStyle(color: labelColor, fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, plot.bottom + 6),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CandlestickPainter oldDelegate) =>
      oldDelegate.candles != candles ||
      oldDelegate.positiveColor != positiveColor ||
      oldDelegate.negativeColor != negativeColor ||
      oldDelegate.axisColor != axisColor;
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
