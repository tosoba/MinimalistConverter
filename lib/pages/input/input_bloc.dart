import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/pages/input/input_event.dart';
import 'package:minimalist_converter/pages/input/input_state.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
  InputBloc() : super(InputState.initial()) {
    on<AppendNewCharacter>((event, emit) =>
        emit(InputState.withNewCharacter(state, event.character)));
    on<RemoveLastCharacter>(
        (event, emit) => emit(InputState.withLastCharacterRemoved(state)));
    on<Clear>((event, emit) => emit(InputState.initial()));
  }
}
