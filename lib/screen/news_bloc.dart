import 'package:bloc/bloc.dart';
import 'package:newspaper_app/customhttp.dart';
import 'package:newspaper_app/model/model.dart';

// Events
abstract class NewsEvent {}

class SearchNewsEvent extends NewsEvent {
  final String query;
  SearchNewsEvent(this.query);
}

// States
abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<Articles> articles;
  NewsLoadedState(this.articles);
}

class NewsErrorState extends NewsState {
  final String error;
  NewsErrorState(this.error);
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final CustomHttp customHttp = CustomHttp();

  NewsBloc() : super(NewsInitialState());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is SearchNewsEvent) {
      yield NewsLoadingState();
      try {
        final articles = await customHttp.fetchSearchData(query: event.query);
        yield NewsLoadedState(articles);
      } catch (error) {
        yield NewsErrorState('Error fetching news data.');
      }
    }
  }
}
