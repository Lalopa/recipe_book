// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_meal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FavoriteMealModel _$FavoriteMealModelFromJson(Map<String, dynamic> json) {
  return _FavoriteMealModel.fromJson(json);
}

/// @nodoc
mixin _$FavoriteMealModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get instructions => throw _privateConstructorUsedError;
  Map<String, String> get ingredients => throw _privateConstructorUsedError;
  DateTime? get addedAt => throw _privateConstructorUsedError;

  /// Serializes this FavoriteMealModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavoriteMealModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteMealModelCopyWith<FavoriteMealModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteMealModelCopyWith<$Res> {
  factory $FavoriteMealModelCopyWith(
    FavoriteMealModel value,
    $Res Function(FavoriteMealModel) then,
  ) = _$FavoriteMealModelCopyWithImpl<$Res, FavoriteMealModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String? thumbnail,
    String category,
    String instructions,
    Map<String, String> ingredients,
    DateTime? addedAt,
  });
}

/// @nodoc
class _$FavoriteMealModelCopyWithImpl<$Res, $Val extends FavoriteMealModel>
    implements $FavoriteMealModelCopyWith<$Res> {
  _$FavoriteMealModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoriteMealModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnail = freezed,
    Object? category = null,
    Object? instructions = null,
    Object? ingredients = null,
    Object? addedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnail: freezed == thumbnail
                ? _value.thumbnail
                : thumbnail // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            instructions: null == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as String,
            ingredients: null == ingredients
                ? _value.ingredients
                : ingredients // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            addedAt: freezed == addedAt
                ? _value.addedAt
                : addedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FavoriteMealModelImplCopyWith<$Res>
    implements $FavoriteMealModelCopyWith<$Res> {
  factory _$$FavoriteMealModelImplCopyWith(
    _$FavoriteMealModelImpl value,
    $Res Function(_$FavoriteMealModelImpl) then,
  ) = __$$FavoriteMealModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? thumbnail,
    String category,
    String instructions,
    Map<String, String> ingredients,
    DateTime? addedAt,
  });
}

/// @nodoc
class __$$FavoriteMealModelImplCopyWithImpl<$Res>
    extends _$FavoriteMealModelCopyWithImpl<$Res, _$FavoriteMealModelImpl>
    implements _$$FavoriteMealModelImplCopyWith<$Res> {
  __$$FavoriteMealModelImplCopyWithImpl(
    _$FavoriteMealModelImpl _value,
    $Res Function(_$FavoriteMealModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FavoriteMealModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnail = freezed,
    Object? category = null,
    Object? instructions = null,
    Object? ingredients = null,
    Object? addedAt = freezed,
  }) {
    return _then(
      _$FavoriteMealModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnail: freezed == thumbnail
            ? _value.thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        instructions: null == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as String,
        ingredients: null == ingredients
            ? _value._ingredients
            : ingredients // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        addedAt: freezed == addedAt
            ? _value.addedAt
            : addedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteMealModelImpl implements _FavoriteMealModel {
  const _$FavoriteMealModelImpl({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.instructions,
    required final Map<String, String> ingredients,
    required this.addedAt,
  }) : _ingredients = ingredients;

  factory _$FavoriteMealModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteMealModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? thumbnail;
  @override
  final String category;
  @override
  final String instructions;
  final Map<String, String> _ingredients;
  @override
  Map<String, String> get ingredients {
    if (_ingredients is EqualUnmodifiableMapView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ingredients);
  }

  @override
  final DateTime? addedAt;

  @override
  String toString() {
    return 'FavoriteMealModel(id: $id, name: $name, thumbnail: $thumbnail, category: $category, instructions: $instructions, ingredients: $ingredients, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteMealModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            const DeepCollectionEquality().equals(
              other._ingredients,
              _ingredients,
            ) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    thumbnail,
    category,
    instructions,
    const DeepCollectionEquality().hash(_ingredients),
    addedAt,
  );

  /// Create a copy of FavoriteMealModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteMealModelImplCopyWith<_$FavoriteMealModelImpl> get copyWith =>
      __$$FavoriteMealModelImplCopyWithImpl<_$FavoriteMealModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteMealModelImplToJson(this);
  }
}

abstract class _FavoriteMealModel implements FavoriteMealModel {
  const factory _FavoriteMealModel({
    required final String id,
    required final String name,
    required final String? thumbnail,
    required final String category,
    required final String instructions,
    required final Map<String, String> ingredients,
    required final DateTime? addedAt,
  }) = _$FavoriteMealModelImpl;

  factory _FavoriteMealModel.fromJson(Map<String, dynamic> json) =
      _$FavoriteMealModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get thumbnail;
  @override
  String get category;
  @override
  String get instructions;
  @override
  Map<String, String> get ingredients;
  @override
  DateTime? get addedAt;

  /// Create a copy of FavoriteMealModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteMealModelImplCopyWith<_$FavoriteMealModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
