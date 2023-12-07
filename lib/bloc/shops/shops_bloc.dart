import 'package:apps/utils/importer.dart';

part 'shops_event.dart';
part 'shops_state.dart';

class ShopsBloc extends Bloc<ShopsEvent, ShopsState> {
  final ShopsRepository _shopsRepository = ShopsRepository();
  ShopsBloc() : super(ShopsInitialState()) {
    on<ShopsEvent>((event, emit) async {
      emit(ShopsInitialState());
      if (event is LoadShopsEvent) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        try {
          int? userID = prefs.getInt('userID');
          if (userID != null) {
            final shops =
                await _shopsRepository.getShops(date: event.date, id: userID);
            emit(ShopsLoadedState(shops: shops, date: event.date));
          }
        } catch (e) {
          debugPrint('error from shop bloc $e');
          emit(const ShopsErrorState(error: 'Connection lost!'));
        }
      }
    });
  }
}
