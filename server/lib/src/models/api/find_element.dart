class FindElementModel {
  String strategy;
  String selector;
  String? context;
  Duration? timeout;

  FindElementModel({required this.strategy, required this.selector, this.context, this.timeout});

  factory FindElementModel.fromJson(Map<String, dynamic> json) => FindElementModel(
        strategy: (json['strategy'] ?? json['using']) as String,
        selector: (json['selector'] ?? json['value']) as String,
        context: json['context'] as String?,
        timeout: json['timeout'] != null
            ? Duration(milliseconds: (json['timeout'] as num).toInt())
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'strategy': strategy,
        'selector': selector,
        "using": strategy,
        "value": selector,
        'context': context,
        'timeout': timeout?.inMilliseconds,
      };
}
