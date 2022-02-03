import 'package:flutter_note/domain/util/order_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_order.freezed.dart';

// 노트 리스트의 타이틀, 날짜, 색사 기준 정렬
@freezed
abstract class NoteOrder<T> with _$NoteOrder<T> {
  const factory NoteOrder.title(OrderType orderType) = NoteOrderTitle;
  const factory NoteOrder.date(OrderType orderType) = NoteOrderDate;
  const factory NoteOrder.color(OrderType orderType) = NoteOrderColor;
}
