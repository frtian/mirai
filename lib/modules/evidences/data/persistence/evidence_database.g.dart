// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_database.dart';

// ignore_for_file: type=lint
class $EvidencesTable extends Evidences
    with TableInfo<$EvidencesTable, EvidenceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturePointIdMeta = const VerificationMeta(
    'capturePointId',
  );
  @override
  late final GeneratedColumn<String> capturePointId = GeneratedColumn<String>(
    'capture_point_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedByMeta = const VerificationMeta(
    'uploadedBy',
  );
  @override
  late final GeneratedColumn<String> uploadedBy = GeneratedColumn<String>(
    'uploaded_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localImagePathMeta = const VerificationMeta(
    'localImagePath',
  );
  @override
  late final GeneratedColumn<String> localImagePath = GeneratedColumn<String>(
    'local_image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMeta = const VerificationMeta(
    'altitude',
  );
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
    'altitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceModelMeta = const VerificationMeta(
    'deviceModel',
  );
  @override
  late final GeneratedColumn<String> deviceModel = GeneratedColumn<String>(
    'device_model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    capturePointId,
    uploadedBy,
    localImagePath,
    imageUrl,
    thumbnailUrl,
    capturedAt,
    uploadedAt,
    latitude,
    longitude,
    altitude,
    accuracyMeters,
    deviceModel,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidences';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('capture_point_id')) {
      context.handle(
        _capturePointIdMeta,
        capturePointId.isAcceptableOrUnknown(
          data['capture_point_id']!,
          _capturePointIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_capturePointIdMeta);
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
        _uploadedByMeta,
        uploadedBy.isAcceptableOrUnknown(data['uploaded_by']!, _uploadedByMeta),
      );
    }
    if (data.containsKey('local_image_path')) {
      context.handle(
        _localImagePathMeta,
        localImagePath.isAcceptableOrUnknown(
          data['local_image_path']!,
          _localImagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localImagePathMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('altitude')) {
      context.handle(
        _altitudeMeta,
        altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta),
      );
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    }
    if (data.containsKey('device_model')) {
      context.handle(
        _deviceModelMeta,
        deviceModel.isAcceptableOrUnknown(
          data['device_model']!,
          _deviceModelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deviceModelMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EvidenceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      capturePointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capture_point_id'],
      )!,
      uploadedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uploaded_by'],
      ),
      localImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_image_path'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      altitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude'],
      ),
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      ),
      deviceModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_model'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EvidencesTable createAlias(String alias) {
    return $EvidencesTable(attachedDatabase, alias);
  }
}

class EvidenceRecord extends DataClass implements Insertable<EvidenceRecord> {
  final String id;
  final String capturePointId;
  final String? uploadedBy;
  final String localImagePath;
  final String? imageUrl;
  final String? thumbnailUrl;
  final DateTime capturedAt;
  final DateTime? uploadedAt;
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? accuracyMeters;
  final String deviceModel;
  final String status;
  final DateTime createdAt;
  const EvidenceRecord({
    required this.id,
    required this.capturePointId,
    this.uploadedBy,
    required this.localImagePath,
    this.imageUrl,
    this.thumbnailUrl,
    required this.capturedAt,
    this.uploadedAt,
    this.latitude,
    this.longitude,
    this.altitude,
    this.accuracyMeters,
    required this.deviceModel,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['capture_point_id'] = Variable<String>(capturePointId);
    if (!nullToAbsent || uploadedBy != null) {
      map['uploaded_by'] = Variable<String>(uploadedBy);
    }
    map['local_image_path'] = Variable<String>(localImagePath);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    map['captured_at'] = Variable<DateTime>(capturedAt);
    if (!nullToAbsent || uploadedAt != null) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || accuracyMeters != null) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters);
    }
    map['device_model'] = Variable<String>(deviceModel);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EvidencesCompanion toCompanion(bool nullToAbsent) {
    return EvidencesCompanion(
      id: Value(id),
      capturePointId: Value(capturePointId),
      uploadedBy: uploadedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedBy),
      localImagePath: Value(localImagePath),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      capturedAt: Value(capturedAt),
      uploadedAt: uploadedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedAt),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      accuracyMeters: accuracyMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyMeters),
      deviceModel: Value(deviceModel),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory EvidenceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceRecord(
      id: serializer.fromJson<String>(json['id']),
      capturePointId: serializer.fromJson<String>(json['capturePointId']),
      uploadedBy: serializer.fromJson<String?>(json['uploadedBy']),
      localImagePath: serializer.fromJson<String>(json['localImagePath']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      uploadedAt: serializer.fromJson<DateTime?>(json['uploadedAt']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      accuracyMeters: serializer.fromJson<double?>(json['accuracyMeters']),
      deviceModel: serializer.fromJson<String>(json['deviceModel']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'capturePointId': serializer.toJson<String>(capturePointId),
      'uploadedBy': serializer.toJson<String?>(uploadedBy),
      'localImagePath': serializer.toJson<String>(localImagePath),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'uploadedAt': serializer.toJson<DateTime?>(uploadedAt),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'altitude': serializer.toJson<double?>(altitude),
      'accuracyMeters': serializer.toJson<double?>(accuracyMeters),
      'deviceModel': serializer.toJson<String>(deviceModel),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EvidenceRecord copyWith({
    String? id,
    String? capturePointId,
    Value<String?> uploadedBy = const Value.absent(),
    String? localImagePath,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> thumbnailUrl = const Value.absent(),
    DateTime? capturedAt,
    Value<DateTime?> uploadedAt = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<double?> altitude = const Value.absent(),
    Value<double?> accuracyMeters = const Value.absent(),
    String? deviceModel,
    String? status,
    DateTime? createdAt,
  }) => EvidenceRecord(
    id: id ?? this.id,
    capturePointId: capturePointId ?? this.capturePointId,
    uploadedBy: uploadedBy.present ? uploadedBy.value : this.uploadedBy,
    localImagePath: localImagePath ?? this.localImagePath,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    capturedAt: capturedAt ?? this.capturedAt,
    uploadedAt: uploadedAt.present ? uploadedAt.value : this.uploadedAt,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    altitude: altitude.present ? altitude.value : this.altitude,
    accuracyMeters: accuracyMeters.present
        ? accuracyMeters.value
        : this.accuracyMeters,
    deviceModel: deviceModel ?? this.deviceModel,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  EvidenceRecord copyWithCompanion(EvidencesCompanion data) {
    return EvidenceRecord(
      id: data.id.present ? data.id.value : this.id,
      capturePointId: data.capturePointId.present
          ? data.capturePointId.value
          : this.capturePointId,
      uploadedBy: data.uploadedBy.present
          ? data.uploadedBy.value
          : this.uploadedBy,
      localImagePath: data.localImagePath.present
          ? data.localImagePath.value
          : this.localImagePath,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      deviceModel: data.deviceModel.present
          ? data.deviceModel.value
          : this.deviceModel,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceRecord(')
          ..write('id: $id, ')
          ..write('capturePointId: $capturePointId, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('localImagePath: $localImagePath, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('deviceModel: $deviceModel, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    capturePointId,
    uploadedBy,
    localImagePath,
    imageUrl,
    thumbnailUrl,
    capturedAt,
    uploadedAt,
    latitude,
    longitude,
    altitude,
    accuracyMeters,
    deviceModel,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceRecord &&
          other.id == this.id &&
          other.capturePointId == this.capturePointId &&
          other.uploadedBy == this.uploadedBy &&
          other.localImagePath == this.localImagePath &&
          other.imageUrl == this.imageUrl &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.capturedAt == this.capturedAt &&
          other.uploadedAt == this.uploadedAt &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitude == this.altitude &&
          other.accuracyMeters == this.accuracyMeters &&
          other.deviceModel == this.deviceModel &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class EvidencesCompanion extends UpdateCompanion<EvidenceRecord> {
  final Value<String> id;
  final Value<String> capturePointId;
  final Value<String?> uploadedBy;
  final Value<String> localImagePath;
  final Value<String?> imageUrl;
  final Value<String?> thumbnailUrl;
  final Value<DateTime> capturedAt;
  final Value<DateTime?> uploadedAt;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> altitude;
  final Value<double?> accuracyMeters;
  final Value<String> deviceModel;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EvidencesCompanion({
    this.id = const Value.absent(),
    this.capturePointId = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.localImagePath = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.deviceModel = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidencesCompanion.insert({
    required String id,
    required String capturePointId,
    this.uploadedBy = const Value.absent(),
    required String localImagePath,
    this.imageUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    required DateTime capturedAt,
    this.uploadedAt = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    required String deviceModel,
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       capturePointId = Value(capturePointId),
       localImagePath = Value(localImagePath),
       capturedAt = Value(capturedAt),
       deviceModel = Value(deviceModel),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<EvidenceRecord> custom({
    Expression<String>? id,
    Expression<String>? capturePointId,
    Expression<String>? uploadedBy,
    Expression<String>? localImagePath,
    Expression<String>? imageUrl,
    Expression<String>? thumbnailUrl,
    Expression<DateTime>? capturedAt,
    Expression<DateTime>? uploadedAt,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitude,
    Expression<double>? accuracyMeters,
    Expression<String>? deviceModel,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (capturePointId != null) 'capture_point_id': capturePointId,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
      if (localImagePath != null) 'local_image_path': localImagePath,
      if (imageUrl != null) 'image_url': imageUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitude != null) 'altitude': altitude,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (deviceModel != null) 'device_model': deviceModel,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidencesCompanion copyWith({
    Value<String>? id,
    Value<String>? capturePointId,
    Value<String?>? uploadedBy,
    Value<String>? localImagePath,
    Value<String?>? imageUrl,
    Value<String?>? thumbnailUrl,
    Value<DateTime>? capturedAt,
    Value<DateTime?>? uploadedAt,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<double?>? altitude,
    Value<double?>? accuracyMeters,
    Value<String>? deviceModel,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EvidencesCompanion(
      id: id ?? this.id,
      capturePointId: capturePointId ?? this.capturePointId,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      localImagePath: localImagePath ?? this.localImagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      capturedAt: capturedAt ?? this.capturedAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      deviceModel: deviceModel ?? this.deviceModel,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (capturePointId.present) {
      map['capture_point_id'] = Variable<String>(capturePointId.value);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<String>(uploadedBy.value);
    }
    if (localImagePath.present) {
      map['local_image_path'] = Variable<String>(localImagePath.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (deviceModel.present) {
      map['device_model'] = Variable<String>(deviceModel.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidencesCompanion(')
          ..write('id: $id, ')
          ..write('capturePointId: $capturePointId, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('localImagePath: $localImagePath, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('deviceModel: $deviceModel, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$EvidenceDatabase extends GeneratedDatabase {
  _$EvidenceDatabase(QueryExecutor e) : super(e);
  $EvidenceDatabaseManager get managers => $EvidenceDatabaseManager(this);
  late final $EvidencesTable evidences = $EvidencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [evidences];
}

typedef $$EvidencesTableCreateCompanionBuilder =
    EvidencesCompanion Function({
      required String id,
      required String capturePointId,
      Value<String?> uploadedBy,
      required String localImagePath,
      Value<String?> imageUrl,
      Value<String?> thumbnailUrl,
      required DateTime capturedAt,
      Value<DateTime?> uploadedAt,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> altitude,
      Value<double?> accuracyMeters,
      required String deviceModel,
      required String status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$EvidencesTableUpdateCompanionBuilder =
    EvidencesCompanion Function({
      Value<String> id,
      Value<String> capturePointId,
      Value<String?> uploadedBy,
      Value<String> localImagePath,
      Value<String?> imageUrl,
      Value<String?> thumbnailUrl,
      Value<DateTime> capturedAt,
      Value<DateTime?> uploadedAt,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> altitude,
      Value<double?> accuracyMeters,
      Value<String> deviceModel,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$EvidencesTableFilterComposer
    extends Composer<_$EvidenceDatabase, $EvidencesTable> {
  $$EvidencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capturePointId => $composableBuilder(
    column: $table.capturePointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EvidencesTableOrderingComposer
    extends Composer<_$EvidenceDatabase, $EvidencesTable> {
  $$EvidencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capturePointId => $composableBuilder(
    column: $table.capturePointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EvidencesTableAnnotationComposer
    extends Composer<_$EvidenceDatabase, $EvidencesTable> {
  $$EvidencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get capturePointId => $composableBuilder(
    column: $table.capturePointId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EvidencesTableTableManager
    extends
        RootTableManager<
          _$EvidenceDatabase,
          $EvidencesTable,
          EvidenceRecord,
          $$EvidencesTableFilterComposer,
          $$EvidencesTableOrderingComposer,
          $$EvidencesTableAnnotationComposer,
          $$EvidencesTableCreateCompanionBuilder,
          $$EvidencesTableUpdateCompanionBuilder,
          (
            EvidenceRecord,
            BaseReferences<_$EvidenceDatabase, $EvidencesTable, EvidenceRecord>,
          ),
          EvidenceRecord,
          PrefetchHooks Function()
        > {
  $$EvidencesTableTableManager(_$EvidenceDatabase db, $EvidencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> capturePointId = const Value.absent(),
                Value<String?> uploadedBy = const Value.absent(),
                Value<String> localImagePath = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<DateTime?> uploadedAt = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> accuracyMeters = const Value.absent(),
                Value<String> deviceModel = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidencesCompanion(
                id: id,
                capturePointId: capturePointId,
                uploadedBy: uploadedBy,
                localImagePath: localImagePath,
                imageUrl: imageUrl,
                thumbnailUrl: thumbnailUrl,
                capturedAt: capturedAt,
                uploadedAt: uploadedAt,
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
                accuracyMeters: accuracyMeters,
                deviceModel: deviceModel,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String capturePointId,
                Value<String?> uploadedBy = const Value.absent(),
                required String localImagePath,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                required DateTime capturedAt,
                Value<DateTime?> uploadedAt = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> accuracyMeters = const Value.absent(),
                required String deviceModel,
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => EvidencesCompanion.insert(
                id: id,
                capturePointId: capturePointId,
                uploadedBy: uploadedBy,
                localImagePath: localImagePath,
                imageUrl: imageUrl,
                thumbnailUrl: thumbnailUrl,
                capturedAt: capturedAt,
                uploadedAt: uploadedAt,
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
                accuracyMeters: accuracyMeters,
                deviceModel: deviceModel,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EvidencesTableProcessedTableManager =
    ProcessedTableManager<
      _$EvidenceDatabase,
      $EvidencesTable,
      EvidenceRecord,
      $$EvidencesTableFilterComposer,
      $$EvidencesTableOrderingComposer,
      $$EvidencesTableAnnotationComposer,
      $$EvidencesTableCreateCompanionBuilder,
      $$EvidencesTableUpdateCompanionBuilder,
      (
        EvidenceRecord,
        BaseReferences<_$EvidenceDatabase, $EvidencesTable, EvidenceRecord>,
      ),
      EvidenceRecord,
      PrefetchHooks Function()
    >;

class $EvidenceDatabaseManager {
  final _$EvidenceDatabase _db;
  $EvidenceDatabaseManager(this._db);
  $$EvidencesTableTableManager get evidences =>
      $$EvidencesTableTableManager(_db, _db.evidences);
}
