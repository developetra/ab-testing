class ConsoleLogger {
  final String domain;

  ConsoleLogger(this.domain);

  void log(String entry) {
    print('[$domain] ${entry.toString()}'); // ignore: avoid_print
  }
}
