//  allNotes should filter the given notes inside the Stream. Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;
// Stream has a function called where. it allows you to grab the current content of that stream and then you can pass a test on that
// we want to filter out and change the contents of this stream based on the current user and we need to then filter the list based on the current user's id and only return the database notes that are relevant for that user
// it allows us to filter a stream of a list of something and then where clause is going to get that something
// and then should that something pass the test, then it will be included in the final list

extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
