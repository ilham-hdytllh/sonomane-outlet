num roundUpToNearest500(num amount) {
  const int roundTo = 500;
  return ((amount + roundTo - 1) ~/ roundTo) * roundTo.toDouble();
}
