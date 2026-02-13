class OrderStatusStep {
  const OrderStatusStep({
    required this.title,
    required this.description,
    required this.time,
    required this.completed,
  });

  final String title;
  final String description;
  final DateTime? time;
  final bool completed;

  OrderStatusStep copyWith({
    String? title,
    String? description,
    DateTime? time,
    bool? completed,
  }) {
    return OrderStatusStep(
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }
}
