import 'package:freezed_annotation/freezed_annotation.dart';

part 'nta_command.freezed.dart';
part 'nta_command.g.dart';

enum Error {
  calibrationError(0x0001),
  nodeTurnOff(0x0002),
  badMsg(0x0003),
  busy(0x0004),
  unknownCommand(0x0005),
  unknownLed(0x0006),
  unknownShape(0x0007),
  unknownColor(0x0008),
  unknownSensor(0x0009);

  const Error(this.code);

  final int code;
}

enum Sensor {
  off(0x00),
  outdoor(0x01),
  touch(0x02),
  hoverMin(0x13),
  hoverMed(0x23),
  hoverMax(0x33);

  const Sensor(this.code);

  final int code;
}

enum Event {
  hit(0xA0),
  hitTimeout(0xA1),
  ackReply(0xB0),
  error(0xC0);

  const Event(this.code);

  final int code;
}

mixin CodedHitEvent {
  int get eventCode => 0xD0;
}

mixin CodedHitTimeoutEvent {
  int get eventCode => 0xA1;
}

mixin CodedAckReplyEvent {
  int get eventCode => 0xB0;
}

mixin CodedErrorEvent {
  int get eventCode => 0xC0;
}

@freezed
class NtaCommand with _$NtaCommand {
  static const int commandCode = 0xD0;

  const NtaCommand._();

  factory NtaCommand.fromPayload(List<int> payload) {
    if (payload.length != 5) throw 'Invalid payload size ${payload.length}';

    final command = payload[0];

    if (command != commandCode) throw 'Invalid command, code $command for $payload';

    final transactionId = payload[1];
    final event = Event.values.firstWhere((element) => element.code == payload[2]);
    final data = payload.sublist(3).reduce((total, value) => total + value);

    return _commandFromData(transactionId, event, data);
  }

  @With<CodedHitEvent>()
  const factory NtaCommand.hitEvent({
    required int transactionId, required int timeMs
  }) = HitEvent;

  @With<CodedHitTimeoutEvent>()
  const factory NtaCommand.hitTimeoutEvent({
    required int transactionId, required int timeMs
  }) = HitTimeoutEvent;

  @With<CodedAckReplyEvent>()
  const factory NtaCommand.ackReplyEvent({
    required int transactionId, required int revisionOperation
  }) = AckReplyEvent;

  @With<CodedErrorEvent>()
  const factory NtaCommand.errorEvent({
    required int transactionId, required Error error
  }) = ErrorEvent;

  factory NtaCommand.fromJson(Map<String, dynamic> json) => _$NtaCommandFromJson(json);

  int get code => commandCode;

  static NtaCommand _commandFromData(int transactionId, Event event, int data) {
    switch (event) {
      case Event.hit:
        return NtaCommand.hitEvent(transactionId: transactionId, timeMs: data);
      case Event.hitTimeout:
        return NtaCommand.hitTimeoutEvent(transactionId: transactionId, timeMs: data);
      case Event.ackReply:
        return NtaCommand.ackReplyEvent(transactionId: transactionId, revisionOperation: data);
      case Event.error:
        final error = Error.values.firstWhere((element) => element.code == data);
        return NtaCommand.errorEvent(transactionId: transactionId, error: error);
    }
  }
}