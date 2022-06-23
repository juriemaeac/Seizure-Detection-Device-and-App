// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalInfoAdapter extends TypeAdapter<PersonalInfo> {
  @override
  final int typeId = 0;

  @override
  PersonalInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalInfo(
      nickname: fields[1] as String,
      firstName: fields[2] as String,
      middleName: fields[3] as String,
      lastName: fields[4] as String,
      guardianName: fields[5] as String,
      email: fields[6] as String,
      contactNumber: fields[7] as int,
      address: fields[8] as String,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, PersonalInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nickname)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.middleName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.guardianName)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.contactNumber)
      ..writeByte(8)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
