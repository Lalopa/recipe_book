// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MealState {
  MealStatus get status => throw _privateConstructorUsedError;
  List<Meal> get meals => throw _privateConstructorUsedError;
  int get letterIndex => throw _privateConstructorUsedError;
  int get offsetInLetter => throw _privateConstructorUsedError;
  bool get hasReachedMax => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )
    $default, {
    required TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )
    initial,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    $default, {
    TResult? Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    initial,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    $default, {
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    initial,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealState value) $default, {
    required TResult Function(_Initial value) initial,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealState value)? $default, {
    TResult? Function(_Initial value)? initial,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealState value)? $default, {
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of MealState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealStateCopyWith<MealState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealStateCopyWith<$Res> {
  factory $MealStateCopyWith(MealState value, $Res Function(MealState) then) =
      _$MealStateCopyWithImpl<$Res, MealState>;
  @useResult
  $Res call({
    MealStatus status,
    List<Meal> meals,
    int letterIndex,
    int offsetInLetter,
    bool hasReachedMax,
  });
}

/// @nodoc
class _$MealStateCopyWithImpl<$Res, $Val extends MealState>
    implements $MealStateCopyWith<$Res> {
  _$MealStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? meals = null,
    Object? letterIndex = null,
    Object? offsetInLetter = null,
    Object? hasReachedMax = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MealStatus,
            meals: null == meals
                ? _value.meals
                : meals // ignore: cast_nullable_to_non_nullable
                      as List<Meal>,
            letterIndex: null == letterIndex
                ? _value.letterIndex
                : letterIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            offsetInLetter: null == offsetInLetter
                ? _value.offsetInLetter
                : offsetInLetter // ignore: cast_nullable_to_non_nullable
                      as int,
            hasReachedMax: null == hasReachedMax
                ? _value.hasReachedMax
                : hasReachedMax // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealStateImplCopyWith<$Res>
    implements $MealStateCopyWith<$Res> {
  factory _$$MealStateImplCopyWith(
    _$MealStateImpl value,
    $Res Function(_$MealStateImpl) then,
  ) = __$$MealStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MealStatus status,
    List<Meal> meals,
    int letterIndex,
    int offsetInLetter,
    bool hasReachedMax,
  });
}

/// @nodoc
class __$$MealStateImplCopyWithImpl<$Res>
    extends _$MealStateCopyWithImpl<$Res, _$MealStateImpl>
    implements _$$MealStateImplCopyWith<$Res> {
  __$$MealStateImplCopyWithImpl(
    _$MealStateImpl _value,
    $Res Function(_$MealStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? meals = null,
    Object? letterIndex = null,
    Object? offsetInLetter = null,
    Object? hasReachedMax = null,
  }) {
    return _then(
      _$MealStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MealStatus,
        meals: null == meals
            ? _value._meals
            : meals // ignore: cast_nullable_to_non_nullable
                  as List<Meal>,
        letterIndex: null == letterIndex
            ? _value.letterIndex
            : letterIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        offsetInLetter: null == offsetInLetter
            ? _value.offsetInLetter
            : offsetInLetter // ignore: cast_nullable_to_non_nullable
                  as int,
        hasReachedMax: null == hasReachedMax
            ? _value.hasReachedMax
            : hasReachedMax // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$MealStateImpl implements _MealState {
  const _$MealStateImpl({
    required this.status,
    required final List<Meal> meals,
    required this.letterIndex,
    required this.offsetInLetter,
    required this.hasReachedMax,
  }) : _meals = meals;

  @override
  final MealStatus status;
  final List<Meal> _meals;
  @override
  List<Meal> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  @override
  final int letterIndex;
  @override
  final int offsetInLetter;
  @override
  final bool hasReachedMax;

  @override
  String toString() {
    return 'MealState(status: $status, meals: $meals, letterIndex: $letterIndex, offsetInLetter: $offsetInLetter, hasReachedMax: $hasReachedMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            (identical(other.letterIndex, letterIndex) ||
                other.letterIndex == letterIndex) &&
            (identical(other.offsetInLetter, offsetInLetter) ||
                other.offsetInLetter == offsetInLetter) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_meals),
    letterIndex,
    offsetInLetter,
    hasReachedMax,
  );

  /// Create a copy of MealState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealStateImplCopyWith<_$MealStateImpl> get copyWith =>
      __$$MealStateImplCopyWithImpl<_$MealStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )
    $default, {
    required TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )
    initial,
  }) {
    return $default(status, meals, letterIndex, offsetInLetter, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    $default, {
    TResult? Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    initial,
  }) {
    return $default?.call(
      status,
      meals,
      letterIndex,
      offsetInLetter,
      hasReachedMax,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    $default, {
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    initial,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
        status,
        meals,
        letterIndex,
        offsetInLetter,
        hasReachedMax,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealState value) $default, {
    required TResult Function(_Initial value) initial,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealState value)? $default, {
    TResult? Function(_Initial value)? initial,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealState value)? $default, {
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _MealState implements MealState {
  const factory _MealState({
    required final MealStatus status,
    required final List<Meal> meals,
    required final int letterIndex,
    required final int offsetInLetter,
    required final bool hasReachedMax,
  }) = _$MealStateImpl;

  @override
  MealStatus get status;
  @override
  List<Meal> get meals;
  @override
  int get letterIndex;
  @override
  int get offsetInLetter;
  @override
  bool get hasReachedMax;

  /// Create a copy of MealState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealStateImplCopyWith<_$MealStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res>
    implements $MealStateCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MealStatus status,
    List<Meal> meals,
    int letterIndex,
    int offsetInLetter,
    bool hasReachedMax,
  });
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$MealStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? meals = null,
    Object? letterIndex = null,
    Object? offsetInLetter = null,
    Object? hasReachedMax = null,
  }) {
    return _then(
      _$InitialImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MealStatus,
        meals: null == meals
            ? _value._meals
            : meals // ignore: cast_nullable_to_non_nullable
                  as List<Meal>,
        letterIndex: null == letterIndex
            ? _value.letterIndex
            : letterIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        offsetInLetter: null == offsetInLetter
            ? _value.offsetInLetter
            : offsetInLetter // ignore: cast_nullable_to_non_nullable
                  as int,
        hasReachedMax: null == hasReachedMax
            ? _value.hasReachedMax
            : hasReachedMax // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl({
    this.status = MealStatus.initial,
    final List<Meal> meals = const [],
    this.letterIndex = 0,
    this.offsetInLetter = 0,
    this.hasReachedMax = false,
  }) : _meals = meals;

  @override
  @JsonKey()
  final MealStatus status;
  final List<Meal> _meals;
  @override
  @JsonKey()
  List<Meal> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  @override
  @JsonKey()
  final int letterIndex;
  @override
  @JsonKey()
  final int offsetInLetter;
  @override
  @JsonKey()
  final bool hasReachedMax;

  @override
  String toString() {
    return 'MealState.initial(status: $status, meals: $meals, letterIndex: $letterIndex, offsetInLetter: $offsetInLetter, hasReachedMax: $hasReachedMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            (identical(other.letterIndex, letterIndex) ||
                other.letterIndex == letterIndex) &&
            (identical(other.offsetInLetter, offsetInLetter) ||
                other.offsetInLetter == offsetInLetter) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_meals),
    letterIndex,
    offsetInLetter,
    hasReachedMax,
  );

  /// Create a copy of MealState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      __$$InitialImplCopyWithImpl<_$InitialImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )
    $default, {
    required TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )
    initial,
  }) {
    return initial(status, meals, letterIndex, offsetInLetter, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    $default, {
    TResult? Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    initial,
  }) {
    return initial?.call(
      status,
      meals,
      letterIndex,
      offsetInLetter,
      hasReachedMax,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    $default, {
    TResult Function(
      MealStatus status,
      List<Meal> meals,
      int letterIndex,
      int offsetInLetter,
      bool hasReachedMax,
    )?
    initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(status, meals, letterIndex, offsetInLetter, hasReachedMax);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealState value) $default, {
    required TResult Function(_Initial value) initial,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealState value)? $default, {
    TResult? Function(_Initial value)? initial,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealState value)? $default, {
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements MealState {
  const factory _Initial({
    final MealStatus status,
    final List<Meal> meals,
    final int letterIndex,
    final int offsetInLetter,
    final bool hasReachedMax,
  }) = _$InitialImpl;

  @override
  MealStatus get status;
  @override
  List<Meal> get meals;
  @override
  int get letterIndex;
  @override
  int get offsetInLetter;
  @override
  bool get hasReachedMax;

  /// Create a copy of MealState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
