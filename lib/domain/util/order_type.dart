import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_type.freezed.dart';

// 노트 리스트의 오름차순, 내림차순 정렬
@freezed
abstract class OrderType<T> with _$OrderType<T> {
  const factory OrderType.ascending() = Ascending;
  const factory OrderType.descending() = Descending;
}
