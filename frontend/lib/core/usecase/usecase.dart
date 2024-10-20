/// Abstract class representing a Use Case in the application.
///
/// A Use Case encapsulates a specific business logic or operation
/// that can be executed. It takes input parameters of type `Params`
/// and returns a result of type `T`.
abstract class UseCase<T, Params> {
  /// Executes the use case with the provided parameters.
  ///
  /// The [params] argument is required and represents the input
  /// needed to perform the use case.
  Future<T> call({required Params params});
}
