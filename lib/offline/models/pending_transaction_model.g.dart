// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_transaction_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOfflinePendingTransactionCollection on Isar {
  IsarCollection<OfflinePendingTransaction> get offlinePendingTransactions =>
      this.collection();
}

const OfflinePendingTransactionSchema = CollectionSchema(
  name: r'OfflinePendingTransaction',
  id: 681117768304326736,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'discountPrice': PropertySchema(
      id: 1,
      name: r'discountPrice',
      type: IsarType.double,
    ),
    r'errorMessage': PropertySchema(
      id: 2,
      name: r'errorMessage',
      type: IsarType.string,
    ),
    r'friendPrice': PropertySchema(
      id: 3,
      name: r'friendPrice',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 4,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'itemsJson': PropertySchema(
      id: 5,
      name: r'itemsJson',
      type: IsarType.string,
    ),
    r'memberId': PropertySchema(
      id: 6,
      name: r'memberId',
      type: IsarType.long,
    ),
    r'note': PropertySchema(
      id: 7,
      name: r'note',
      type: IsarType.string,
    ),
    r'offlineReceiptNumber': PropertySchema(
      id: 8,
      name: r'offlineReceiptNumber',
      type: IsarType.string,
    ),
    r'payedMoney': PropertySchema(
      id: 9,
      name: r'payedMoney',
      type: IsarType.double,
    ),
    r'retryCount': PropertySchema(
      id: 10,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'serverTransactionId': PropertySchema(
      id: 11,
      name: r'serverTransactionId',
      type: IsarType.string,
    ),
    r'tax': PropertySchema(
      id: 12,
      name: r'tax',
      type: IsarType.double,
    )
  },
  estimateSize: _offlinePendingTransactionEstimateSize,
  serialize: _offlinePendingTransactionSerialize,
  deserialize: _offlinePendingTransactionDeserialize,
  deserializeProp: _offlinePendingTransactionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _offlinePendingTransactionGetId,
  getLinks: _offlinePendingTransactionGetLinks,
  attach: _offlinePendingTransactionAttach,
  version: '3.1.0+1',
);

int _offlinePendingTransactionEstimateSize(
  OfflinePendingTransaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.errorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.itemsJson.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.offlineReceiptNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.serverTransactionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _offlinePendingTransactionSerialize(
  OfflinePendingTransaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDouble(offsets[1], object.discountPrice);
  writer.writeString(offsets[2], object.errorMessage);
  writer.writeBool(offsets[3], object.friendPrice);
  writer.writeBool(offsets[4], object.isSynced);
  writer.writeString(offsets[5], object.itemsJson);
  writer.writeLong(offsets[6], object.memberId);
  writer.writeString(offsets[7], object.note);
  writer.writeString(offsets[8], object.offlineReceiptNumber);
  writer.writeDouble(offsets[9], object.payedMoney);
  writer.writeLong(offsets[10], object.retryCount);
  writer.writeString(offsets[11], object.serverTransactionId);
  writer.writeDouble(offsets[12], object.tax);
}

OfflinePendingTransaction _offlinePendingTransactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OfflinePendingTransaction();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.discountPrice = reader.readDouble(offsets[1]);
  object.errorMessage = reader.readStringOrNull(offsets[2]);
  object.friendPrice = reader.readBoolOrNull(offsets[3]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[4]);
  object.itemsJson = reader.readString(offsets[5]);
  object.memberId = reader.readLongOrNull(offsets[6]);
  object.note = reader.readStringOrNull(offsets[7]);
  object.offlineReceiptNumber = reader.readStringOrNull(offsets[8]);
  object.payedMoney = reader.readDoubleOrNull(offsets[9]);
  object.retryCount = reader.readLong(offsets[10]);
  object.serverTransactionId = reader.readStringOrNull(offsets[11]);
  object.tax = reader.readDoubleOrNull(offsets[12]);
  return object;
}

P _offlinePendingTransactionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _offlinePendingTransactionGetId(OfflinePendingTransaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _offlinePendingTransactionGetLinks(
    OfflinePendingTransaction object) {
  return [];
}

void _offlinePendingTransactionAttach(
    IsarCollection<dynamic> col, Id id, OfflinePendingTransaction object) {
  object.id = id;
}

extension OfflinePendingTransactionQueryWhereSort on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QWhere> {
  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OfflinePendingTransactionQueryWhere on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QWhereClause> {
  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OfflinePendingTransactionQueryFilter on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QFilterCondition> {
  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> discountPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discountPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> discountPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discountPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> discountPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discountPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> discountPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discountPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'errorMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      errorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      errorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'errorMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> errorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> friendPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'friendPrice',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> friendPriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'friendPrice',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> friendPriceEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'friendPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> itemsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> itemsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> itemsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> itemsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> itemsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> itemsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      itemsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      itemsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> itemsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> itemsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> memberIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'memberId',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> memberIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'memberId',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> memberIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memberId',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> memberIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'memberId',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> memberIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'memberId',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> memberIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'memberId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'offlineReceiptNumber',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'offlineReceiptNumber',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offlineReceiptNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offlineReceiptNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offlineReceiptNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offlineReceiptNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'offlineReceiptNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'offlineReceiptNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      offlineReceiptNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'offlineReceiptNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      offlineReceiptNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'offlineReceiptNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offlineReceiptNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> offlineReceiptNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'offlineReceiptNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> payedMoneyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'payedMoney',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> payedMoneyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'payedMoney',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> payedMoneyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payedMoney',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> payedMoneyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payedMoney',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> payedMoneyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payedMoney',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> payedMoneyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payedMoney',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> retryCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> retryCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> retryCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retryCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverTransactionId',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverTransactionId',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverTransactionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serverTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serverTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      serverTransactionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
          QAfterFilterCondition>
      serverTransactionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverTransactionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverTransactionId',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> serverTransactionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverTransactionId',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> taxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tax',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> taxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tax',
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> taxEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> taxGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> taxLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterFilterCondition> taxBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tax',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension OfflinePendingTransactionQueryObject on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QFilterCondition> {}

extension OfflinePendingTransactionQueryLinks on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QFilterCondition> {}

extension OfflinePendingTransactionQuerySortBy on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QSortBy> {
  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByDiscountPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountPrice', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByDiscountPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountPrice', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByFriendPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendPrice', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByFriendPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendPrice', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByItemsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByItemsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByMemberIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByOfflineReceiptNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offlineReceiptNumber', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByOfflineReceiptNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offlineReceiptNumber', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByPayedMoney() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payedMoney', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByPayedMoneyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payedMoney', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByServerTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverTransactionId', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByServerTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverTransactionId', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> sortByTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.desc);
    });
  }
}

extension OfflinePendingTransactionQuerySortThenBy on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QSortThenBy> {
  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByDiscountPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountPrice', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByDiscountPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountPrice', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByFriendPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendPrice', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByFriendPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendPrice', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByItemsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByItemsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByMemberIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByOfflineReceiptNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offlineReceiptNumber', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByOfflineReceiptNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offlineReceiptNumber', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByPayedMoney() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payedMoney', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByPayedMoneyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payedMoney', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByServerTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverTransactionId', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByServerTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverTransactionId', Sort.desc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.asc);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction,
      QAfterSortBy> thenByTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.desc);
    });
  }
}

extension OfflinePendingTransactionQueryWhereDistinct on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QDistinct> {
  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByDiscountPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discountPrice');
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByFriendPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'friendPrice');
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memberId');
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByOfflineReceiptNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'offlineReceiptNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByPayedMoney() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payedMoney');
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByServerTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverTransactionId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflinePendingTransaction, OfflinePendingTransaction, QDistinct>
      distinctByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tax');
    });
  }
}

extension OfflinePendingTransactionQueryProperty on QueryBuilder<
    OfflinePendingTransaction, OfflinePendingTransaction, QQueryProperty> {
  QueryBuilder<OfflinePendingTransaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OfflinePendingTransaction, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OfflinePendingTransaction, double, QQueryOperations>
      discountPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discountPrice');
    });
  }

  QueryBuilder<OfflinePendingTransaction, String?, QQueryOperations>
      errorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorMessage');
    });
  }

  QueryBuilder<OfflinePendingTransaction, bool?, QQueryOperations>
      friendPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'friendPrice');
    });
  }

  QueryBuilder<OfflinePendingTransaction, bool, QQueryOperations>
      isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<OfflinePendingTransaction, String, QQueryOperations>
      itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemsJson');
    });
  }

  QueryBuilder<OfflinePendingTransaction, int?, QQueryOperations>
      memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memberId');
    });
  }

  QueryBuilder<OfflinePendingTransaction, String?, QQueryOperations>
      noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<OfflinePendingTransaction, String?, QQueryOperations>
      offlineReceiptNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'offlineReceiptNumber');
    });
  }

  QueryBuilder<OfflinePendingTransaction, double?, QQueryOperations>
      payedMoneyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payedMoney');
    });
  }

  QueryBuilder<OfflinePendingTransaction, int, QQueryOperations>
      retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<OfflinePendingTransaction, String?, QQueryOperations>
      serverTransactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverTransactionId');
    });
  }

  QueryBuilder<OfflinePendingTransaction, double?, QQueryOperations>
      taxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tax');
    });
  }
}
