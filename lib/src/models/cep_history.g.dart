part of 'cep_history.dart';


class CepHistoryAdapter extends TypeAdapter<CepHistory> {
  @override
  final int typeId = 0;

  @override
  CepHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CepHistory(
      cep: fields[0] as String,
      logradouro: fields[1] as String,
      bairro: fields[2] as String,
      localidade: fields[3] as String,
      uf: fields[4] as String,
      dateTime: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CepHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.cep)
      ..writeByte(1)
      ..write(obj.logradouro)
      ..writeByte(2)
      ..write(obj.bairro)
      ..writeByte(3)
      ..write(obj.localidade)
      ..writeByte(4)
      ..write(obj.uf)
      ..writeByte(5)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CepHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
