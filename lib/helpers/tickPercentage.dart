String getTickPercentage(double total, double faultyTicks) {
  return ((total - faultyTicks) / (total)).toStringAsFixed(2);
}
