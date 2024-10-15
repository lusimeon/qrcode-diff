class ScanModel {
  ScanModel({
    this.source,
    this.target,
  });

  String? source, target;

  bool get isReady => source != null && target != null;

  factory ScanModel.fromJson(Map<String, String> json) {
    return ScanModel(
      target: json['target'],
      source: json['source'],
    );
  }
}
