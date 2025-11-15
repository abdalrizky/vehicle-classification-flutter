class Prediction {
  final String label;
  final double probability;

  Prediction(this.label, this.probability);

  @override
  String toString() {
    if (label == 'Objek Tidak Dikenali') {
      return label;
    }
    return '$label (${(probability * 100).toStringAsFixed(1)}%)';
  }
}
