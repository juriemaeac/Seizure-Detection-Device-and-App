// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensed_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensedDataAdapter extends TypeAdapter<SensedData> {
  @override
  final int typeId = 1;

  @override
  SensedData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SensedData(
      date: fields[1] as String,
      time: fields[2] as String,
      isHeightened: fields[3] as String,
      bpm: fields[4] as String,
      gsr: fields[5] as String,
      accelerometer: fields[6] as String,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, SensedData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.isHeightened)
      ..writeByte(4)
      ..write(obj.bpm)
      ..writeByte(5)
      ..write(obj.gsr)
      ..writeByte(6)
      ..write(obj.accelerometer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensedDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
