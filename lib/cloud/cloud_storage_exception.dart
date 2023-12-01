class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldnotCreateNoteException implements CloudStorageException {}

class CouldnotUpdateNoteException implements CloudStorageException {}

class CouldnotDeleteNoteException implements CloudStorageException {}

class CouldnotGetAllNotesException implements CloudStorageException {}
