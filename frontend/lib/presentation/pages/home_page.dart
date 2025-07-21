import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/content/content_bloc.dart';
import '../../data/models/lesson_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContentBloc(getIt<FetchLessonsUseCase>())..add(LoadLessons(1)),
      child: Scaffold(
        appBar: AppBar(title: Text('Lessons')),
        body: BlocBuilder<ContentBloc, ContentState>(
          builder: (context, state) {
            if (state is ContentLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ContentLoaded) {
              return ListView.builder(
                itemCount: state.lessons.length,
                itemBuilder: (_, i) => LessonCard(lesson: state.lessons[i]),
              );
            } else if (state is ContentError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
