abstract class FormResult {}

class FormSuccess extends FormResult {}

class FormFailure extends FormResult {
  final String message;
  FormFailure(this.message);
}
