import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lit_eracy/core/di.dart';
import 'package:lit_eracy/presentation/blocs/content/content_bloc.dart';
import 'package:lit_eracy/presentation/widgets/lesson_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContentBloc>()..add(LoadLessons(1)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Lessons')),
        body: BlocBuilder<ContentBloc, ContentState>(
          builder: (context, state) {
            if (state is ContentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContentLoaded) {
              return ListView.builder(
                itemCount: state.lessons.length,
                itemBuilder: (context, index) =>
                    LessonCard(lesson: state.lessons[index]),
              );
            } else if (state is ContentError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
