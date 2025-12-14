class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  const Result._({this.data, this.error, required this.isSuccess});
  
  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }
  
  factory Result.failure(String error) {
    return Result._(error: error, isSuccess: false);
  }
  
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onFailure,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    } else {
      return onFailure(error ?? 'Unknown error');
    }
  }
}