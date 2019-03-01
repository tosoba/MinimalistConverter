abstract class InputEvent {}

class AppendNewCharacter extends InputEvent {
  final String character;

  AppendNewCharacter(this.character);
}

class RemoveLastCharacter extends InputEvent {}
