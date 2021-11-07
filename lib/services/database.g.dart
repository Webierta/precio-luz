// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatabaseAdapter extends TypeAdapter<Database> {
  @override
  final int typeId = 1;

  @override
  Database read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Database(
      fecha: fields[0] as String,
      preciosHora: (fields[1] as List)?.cast<double>(),
      mapRenovables: (fields[2] as Map)?.cast<String, double>(),
      mapNoRenovables: (fields[3] as Map)?.cast<String, double>(),
      generacion: (fields[4] as Map)?.cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, Database obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fecha)
      ..writeByte(1)
      ..write(obj.preciosHora)
      ..writeByte(2)
      ..write(obj.mapRenovables)
      ..writeByte(3)
      ..write(obj.mapNoRenovables)
      ..writeByte(4)
      ..write(obj.generacion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
