// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pose.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoseAdapter extends TypeAdapter<Pose> {
  @override
  final int typeId = 0;

  @override
  Pose read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pose(
      preview: fields[0] as String,
      zoomed: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Pose obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.preview)
      ..writeByte(1)
      ..write(obj.zoomed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
