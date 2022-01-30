part of 'poly_cubit.dart';

class PolyState {
  final PolyStatus status;
  final String? error;
  final num? result;
  PolyState({
    this.status = PolyStatus.initial,
    this.error,
    this.result,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PolyState &&
        other.status == status &&
        other.error == error &&
        other.result == result;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ result.hashCode;

  @override
  String toString() =>
      'PolyState(status: $status, error: $error, result: $result)';

  PolyState copyWith({
    required PolyStatus? status,
    String? error,
    num? result,
  }) {
    return PolyState(
      status: status ?? this.status,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }
}

enum PolyStatus { initial, loading, error, success }
