import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/pages/input/input_event.dart';
import 'package:minimalist_converter/pages/input/input_state.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
  @override
  InputState get initialState => InputState.initial();

  @override
  Stream<InputState> mapEventToState(
      InputState currentState, InputEvent event) async* {
    if (event is AppendNewCharacter) {
      yield InputState.withNewCharacter(currentState, event.character);
    } else if (event is RemoveLastCharacter) {
      yield InputState.withLastCharacterRemoved(currentState);
    } else if (event is Clear) {
      yield InputState.initial();
    }
  }
}
