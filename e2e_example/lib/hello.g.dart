// GENERATED CODE - DO NOT MODIFY BY HAND

part of hello;

// **************************************************************************
// Generator: DobxGenerator
// Target: abstract class Todo
// **************************************************************************

class _Todo extends PubSub implements Todo {
  String _title;
  String get title {
    $sub(1);
    return _title;
  }

  void set title(String title) {
    if (title != null && title == _title) return;
    _title = title ?? '';
    $pub(1);
  }

  bool _completed;
  bool get completed {
    $sub(2);
    return _completed;
  }

  void set completed(bool completed) {
    if (completed != null && completed == _completed) return;
    _completed = completed ?? false;
    $pub(2);
  }
}

Todo _$Todo({
  String title: '',
  bool completed: false,
}) {
  return new _Todo()
    .._title = title
    .._completed = completed;
}
