enum DataState {
  initial,
  fetched,
  loading,
  failed;

  bool get isInitial => this == DataState.initial;
  bool get isFetched => this == DataState.fetched;
  bool get isLoading => this == DataState.loading;
  bool get isFailed => this == DataState.failed;
}

sealed class Ds<T> {
  Ds({required this.state, this.valueOrNull, this.error});

  T? valueOrNull;
  Object? error;
  DataState state;

  T get value => valueOrNull!;

  factory Ds.empty() = Empty<T>;
  factory Ds.loading() = Loading<T>;
  factory Ds.success(T data) = Fetched<T>;
  factory Ds.error(Object err) = Failed<T>;

  R onState<R>({
    required R Function(T data) fetched,
    required R Function(Object error) failed,
    required R Function() loading,
    R Function()? initial,
  }) {
    if (state.isFailed) {
      return failed(error!);
    } else if (state.isLoading) {
      return loading();
    } else if (state.isInitial) {
      return (initial ?? loading)();
    } else {
      return fetched(valueOrNull as T);
    }
  }
}

// 초기(빈) 상태 — 아직 요청이 시작되지 않은 경우
class Empty<T> extends Ds<T> {
  Empty() : super(state: DataState.initial);
}

// 성공적으로 데이터를 가져왔을 때의 데이터 상태 클래스
class Fetched<T> extends Ds<T> {
  final T data;

  Fetched(this.data) : super(state: DataState.fetched, valueOrNull: data);
}

// 로딩 중일 때의 데이터 상태 클래스
class Loading<T> extends Ds<T> {
  Loading() : super(state: DataState.loading);
}

// 데이터 가져오기 실패했을 때의 데이터 상태 클래스
class Failed<T> extends Ds<T> {
  @override
  final Object error;
  Failed(this.error) : super(state: DataState.failed, error: error);
}
