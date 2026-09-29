/// 앱 경로. 문자열을 직접 쓰지 말고 항상 이 enum을 사용한다.
enum AppRoute {
  splash('/splash'),
  login('/login'),
  home('/home'),
  chat('/chat'),
  my('/my');

  const AppRoute(this.path);

  final String path;
}
