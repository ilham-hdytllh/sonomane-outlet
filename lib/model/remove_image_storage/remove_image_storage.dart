import 'package:firebase_storage/firebase_storage.dart';

class RemoveImageStorage {
  Future removeImageFromStorage(String url) {
    return FirebaseStorage.instance.refFromURL(url).delete();
  }
}
