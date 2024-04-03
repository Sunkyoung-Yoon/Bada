abstract class SocialLogin<T> {
  Future<T> login();
  Future<T> logout();
}
