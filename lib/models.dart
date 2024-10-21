import 'package:objectbox/objectbox.dart';

@Entity()
class FeelingsLog {
  @Id()
  int id = 0;

  late List<String> emotions;

  @Index()
  @Property(type: PropertyType.date)
  late DateTime createdAt;

  FeelingsLog(this.emotions, {this.id = 0, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
}
