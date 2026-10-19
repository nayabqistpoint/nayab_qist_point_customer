class BenchmarkArgs {
  final int initialTabIndex;

  const BenchmarkArgs({this.initialTabIndex = 0});

  factory BenchmarkArgs.fromMap(Map<String, dynamic>? map) {
    return BenchmarkArgs(
      initialTabIndex: (map?['initialTabIndex'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'initialTabIndex': initialTabIndex};
  }
}