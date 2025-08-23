import 'package:objectbox/objectbox.dart';

@Entity()
class SearchObjectBoxModel {
  SearchObjectBoxModel({
    required this.searchKey,
    required this.dataJson,
    required this.timestamp,
    required this.expiresAt,
    this.id = 0,
  });
  @Id()
  int id;

  @Unique()
  String searchKey;

  String dataJson;

  @Property(type: PropertyType.date)
  DateTime timestamp;

  @Property(type: PropertyType.date)
  DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
