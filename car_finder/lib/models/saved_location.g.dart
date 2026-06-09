// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedLocationAdapter extends TypeAdapter<SavedLocation> {
  @override
  final int typeId = 0;

  @override
  SavedLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedLocation(
      id: fields[0] as String?,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      address: fields[3] as String,
      note: fields[4] as String?,
      savedAt: fields[5] as DateTime?,
      temperature: fields[6] as double?,
      weatherCondition: fields[7] as String?,
      weatherIcon: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedLocation obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.savedAt)
      ..writeByte(6)
      ..write(obj.temperature)
      ..writeByte(7)
      ..write(obj.weatherCondition)
      ..writeByte(8)
      ..write(obj.weatherIcon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
