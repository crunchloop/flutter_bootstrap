import 'package:freezed_annotation/freezed_annotation.dart';

part 'step.freezed.dart';
part 'step.g.dart';

@freezed
class Step with _$Step {

  const factory Step() = _Step;

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
}