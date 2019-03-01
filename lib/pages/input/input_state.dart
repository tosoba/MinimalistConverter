class InputState {
  final String _input;

  String get input => _input;

  InputState._(this._input);

  factory InputState.initial() => InputState._("");

  factory InputState.withNewCharacter(InputState other, String newCharacter) =>
      InputState._(other._input + newCharacter);

  factory InputState.withLastCharacterRemoved(InputState other) {
    if (other.input.isEmpty)
      return InputState._("");
    else 
      return InputState._(other._input.substring(0, other._input.length - 1));
  }
}
