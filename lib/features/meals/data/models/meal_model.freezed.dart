// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MealModel _$MealModelFromJson(Map<String, dynamic> json) {
  return _MealModel.fromJson(json);
}

/// @nodoc
mixin _$MealModel {
  @JsonKey(name: 'idMeal')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'strMeal')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'strMealThumb')
  String? get thumbnail => throw _privateConstructorUsedError;
  @JsonKey(name: 'strCategory')
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'strInstructions')
  String get instructions => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _ingredientsFromJson, readValue: _readWholeJson)
  Map<String, String> get ingredients => throw _privateConstructorUsedError;

  /// Serializes this MealModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealModelCopyWith<MealModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealModelCopyWith<$Res> {
  factory $MealModelCopyWith(MealModel value, $Res Function(MealModel) then) =
      _$MealModelCopyWithImpl<$Res, MealModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'idMeal') String id,
    @JsonKey(name: 'strMeal') String name,
    @JsonKey(name: 'strMealThumb') String? thumbnail,
    @JsonKey(name: 'strCategory') String category,
    @JsonKey(name: 'strInstructions') String instructions,
    @JsonKey(fromJson: _ingredientsFromJson, readValue: _readWholeJson)
    Map<String, String> ingredients,
  });
}

/// @nodoc
class _$MealModelCopyWithImpl<$Res, $Val extends MealModel>
    implements $MealModelCopyWith<$Res> {
  _$MealModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealModel
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealModelImplCopyWith<$Res>
    implements $MealModelCopyWith<$Res> {
  factory _$$MealModelImplCopyWith(
    _$MealModelImpl value,
    $Res Function(_$MealModelImpl) then,
  ) = __$$MealModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'idMeal') String id,
    @JsonKey(name: 'strMeal') String name,
    @JsonKey(name: 'strMealThumb') String? thumbnail,
    @JsonKey(name: 'strCategory') String category,
    @JsonKey(name: 'strInstructions') String instructions,
    @JsonKey(fromJson: _ingredientsFromJson, readValue: _readWholeJson)
    Map<String, String> ingredients,
  });
}

/// @nodoc
class __$$MealModelImplCopyWithImpl<$Res>
    extends _$MealModelCopyWithImpl<$Res, _$MealModelImpl>
    implements _$$MealModelImplCopyWith<$Res> {
  __$$MealModelImplCopyWithImpl(
    _$MealModelImpl _value,
    $Res Function(_$MealModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealModel
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
  }) {
    return _then(
      _$MealModelImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealModelImpl with DiagnosticableTreeMixin implements _MealModel {
  const _$MealModelImpl({
    @JsonKey(name: 'idMeal') required this.id,
    @JsonKey(name: 'strMeal') required this.name,
    @JsonKey(name: 'strMealThumb') required this.thumbnail,
    @JsonKey(name: 'strCategory') this.category = '',
    @JsonKey(name: 'strInstructions') this.instructions = '',
    @JsonKey(fromJson: _ingredientsFromJson, readValue: _readWholeJson)
    final Map<String, String> ingredients = const <String, String>{},
  }) : _ingredients = ingredients;

  factory _$MealModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealModelImplFromJson(json);

  @override
  @JsonKey(name: 'idMeal')
  final String id;
  @override
  @JsonKey(name: 'strMeal')
  final String name;
  @override
  @JsonKey(name: 'strMealThumb')
  final String? thumbnail;
  @override
  @JsonKey(name: 'strCategory')
  final String category;
  @override
  @JsonKey(name: 'strInstructions')
  final String instructions;
  final Map<String, String> _ingredients;
  @override
  @JsonKey(fromJson: _ingredientsFromJson, readValue: _readWholeJson)
  Map<String, String> get ingredients {
    if (_ingredients is EqualUnmodifiableMapView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ingredients);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MealModel(id: $id, name: $name, thumbnail: $thumbnail, category: $category, instructions: $instructions, ingredients: $ingredients)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MealModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('thumbnail', thumbnail))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('instructions', instructions))
      ..add(DiagnosticsProperty('ingredients', ingredients));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealModelImpl &&
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
            ));
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
  );

  /// Create a copy of MealModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealModelImplCopyWith<_$MealModelImpl> get copyWith =>
      __$$MealModelImplCopyWithImpl<_$MealModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealModelImplToJson(this);
  }
}

abstract class _MealModel implements MealModel {
  const factory _MealModel({
    @JsonKey(name: 'idMeal') required final String id,
    @JsonKey(name: 'strMeal') required final String name,
    @JsonKey(name: 'strMealThumb') required final String? thumbnail,
    @JsonKey(name: 'strCategory') final String category,
    @JsonKey(name: 'strInstructions') final String instructions,
    @JsonKey(fromJson: _ingredientsFromJson, readValue: _readWholeJson)
    final Map<String, String> ingredients,
  }) = _$MealModelImpl;

  factory _MealModel.fromJson(Map<String, dynamic> json) =
      _$MealModelImpl.fromJson;

  @override
  @JsonKey(name: 'idMeal')
  String get id;
  @override
  @JsonKey(name: 'strMeal')
  String get name;
  @override
  @JsonKey(name: 'strMealThumb')
  String? get thumbnail;
  @override
  @JsonKey(name: 'strCategory')
  String get category;
  @override
  @JsonKey(name: 'strInstructions')
  String get instructions;
  @override
  @JsonKey(fromJson: _ingredientsFromJson, readValue: _readWholeJson)
  Map<String, String> get ingredients;

  /// Create a copy of MealModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealModelImplCopyWith<_$MealModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
