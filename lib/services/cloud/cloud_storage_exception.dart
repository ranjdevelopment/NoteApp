class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in Crud
class CouldNotCreateNoteException extends CloudStorageException {}

// R in Crud
class CouldNotGetAllNotesException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateNoteException extends CloudStorageException {}

//D in CRUD

class CouldNotDeleteNoteException extends CloudStorageException {}
