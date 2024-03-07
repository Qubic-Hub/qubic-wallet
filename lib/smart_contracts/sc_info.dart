enum QubicSCID {
  qX(1, 'QX'),
  quottery(2, 'Quottery'),
  qRnd(3, 'Random');

  const QubicSCID(this.contractIndex, this.name);

  final int contractIndex;
  final String name;
}
