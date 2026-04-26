// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_payment_method_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOfflinePaymentMethodCollection on Isar {
  IsarCollection<OfflinePaymentMethod> get offlinePaymentMethods =>
      this.collection();
}

const OfflinePaymentMethodSchema = CollectionSchema(
  name: r'OfflinePaymentMethod',
  id: 8824789115153983516,
  properties: {
    r'cachedAt': PropertySchema(
      id: 0,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'icon': PropertySchema(
      id: 1,
      name: r'icon',
      type: IsarType.string,
    ),
    r'isCash': PropertySchema(
      id: 2,
      name: r'isCash',
      type: IsarType.bool,
    ),
    r'isCredit': PropertySchema(
      id: 3,
      name: r'isCredit',
      type: IsarType.bool,
    ),
    r'isDebit': PropertySchema(
      id: 4,
      name: r'isDebit',
      type: IsarType.bool,
    ),
    r'isLocal': PropertySchema(
      id: 5,
      name: r'isLocal',
      type: IsarType.bool,
    ),
    r'isWallet': PropertySchema(
      id: 6,
      name: r'isWallet',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 7,
      name: r'name',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 8,
      name: r'remoteId',
      type: IsarType.long,
    )
  },
  estimateSize: _offlinePaymentMethodEstimateSize,
  serialize: _offlinePaymentMethodSerialize,
  deserialize: _offlinePaymentMethodDeserialize,
  deserializeProp: _offlinePaymentMethodDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _offlinePaymentMethodGetId,
  getLinks: _offlinePaymentMethodGetLinks,
  attach: _offlinePaymentMethodAttach,
  version: '3.1.0+1',
);

int _offlinePaymentMethodEstimateSize(
  OfflinePaymentMethod object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.icon;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _offlinePaymentMethodSerialize(
  OfflinePaymentMethod object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cachedAt);
  writer.writeString(offsets[1], object.icon);
  writer.writeBool(offsets[2], object.isCash);
  writer.writeBool(offsets[3], object.isCredit);
  writer.writeBool(offsets[4], object.isDebit);
  writer.writeBool(offsets[5], object.isLocal);
  writer.writeBool(offsets[6], object.isWallet);
  writer.writeString(offsets[7], object.name);
  writer.writeLong(offsets[8], object.remoteId);
}

OfflinePaymentMethod _offlinePaymentMethodDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OfflinePaymentMethod();
  object.cachedAt = reader.readDateTimeOrNull(offsets[0]);
  object.icon = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.isCash = reader.readBool(offsets[2]);
  object.isCredit = reader.readBool(offsets[3]);
  object.isDebit = reader.readBool(offsets[4]);
  object.isLocal = reader.readBool(offsets[5]);
  object.isWallet = reader.readBool(offsets[6]);
  object.name = reader.readString(offsets[7]);
  object.remoteId = reader.readLongOrNull(offsets[8]);
  return object;
}

P _offlinePaymentMethodDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _offlinePaymentMethodGetId(OfflinePaymentMethod object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _offlinePaymentMethodGetLinks(
    OfflinePaymentMethod object) {
  return [];
}

void _offlinePaymentMethodAttach(
    IsarCollection<dynamic> col, Id id, OfflinePaymentMethod object) {
  object.id = id;
}

extension OfflinePaymentMethodQueryWhereSort
    on QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QWhere> {
  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OfflinePaymentMethodQueryWhere
    on QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QWhereClause> {
  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterWhereClause>
      idBetween(
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

extension OfflinePaymentMethodQueryFilter on QueryBuilder<OfflinePaymentMethod,
    OfflinePaymentMethod, QFilterCondition> {
  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> cachedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cachedAt',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> cachedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cachedAt',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> cachedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> cachedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> cachedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> cachedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cachedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
          QAfterFilterCondition>
      iconContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
          QAfterFilterCondition>
      iconMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'icon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
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

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
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

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
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

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> isCashEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCash',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> isCreditEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCredit',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> isDebitEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDebit',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> isLocalEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLocal',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> isWalletEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWallet',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> remoteIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> remoteIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> remoteIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod,
      QAfterFilterCondition> remoteIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OfflinePaymentMethodQueryObject on QueryBuilder<OfflinePaymentMethod,
    OfflinePaymentMethod, QFilterCondition> {}

extension OfflinePaymentMethodQueryLinks on QueryBuilder<OfflinePaymentMethod,
    OfflinePaymentMethod, QFilterCondition> {}

extension OfflinePaymentMethodQuerySortBy
    on QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QSortBy> {
  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCash', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCash', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredit', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsCreditDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredit', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsDebit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDebit', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsDebitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDebit', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsWallet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWallet', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByIsWalletDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWallet', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }
}

extension OfflinePaymentMethodQuerySortThenBy
    on QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QSortThenBy> {
  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCash', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCash', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredit', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsCreditDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredit', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsDebit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDebit', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsDebitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDebit', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsWallet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWallet', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByIsWalletDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWallet', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }
}

extension OfflinePaymentMethodQueryWhereDistinct
    on QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct> {
  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByIcon({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByIsCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCash');
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByIsCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCredit');
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByIsDebit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDebit');
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLocal');
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByIsWallet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWallet');
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflinePaymentMethod, OfflinePaymentMethod, QDistinct>
      distinctByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId');
    });
  }
}

extension OfflinePaymentMethodQueryProperty on QueryBuilder<
    OfflinePaymentMethod, OfflinePaymentMethod, QQueryProperty> {
  QueryBuilder<OfflinePaymentMethod, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OfflinePaymentMethod, DateTime?, QQueryOperations>
      cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<OfflinePaymentMethod, String?, QQueryOperations> iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<OfflinePaymentMethod, bool, QQueryOperations> isCashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCash');
    });
  }

  QueryBuilder<OfflinePaymentMethod, bool, QQueryOperations>
      isCreditProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCredit');
    });
  }

  QueryBuilder<OfflinePaymentMethod, bool, QQueryOperations> isDebitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDebit');
    });
  }

  QueryBuilder<OfflinePaymentMethod, bool, QQueryOperations> isLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLocal');
    });
  }

  QueryBuilder<OfflinePaymentMethod, bool, QQueryOperations>
      isWalletProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWallet');
    });
  }

  QueryBuilder<OfflinePaymentMethod, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<OfflinePaymentMethod, int?, QQueryOperations>
      remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }
}
