// every note generated by firebase database has an unique id
// it is like a primary key in Django
// other two properties you need are owner id and text

import 'package:flutter/material.dart';

// QueryDocumentSnapshot is just a wrapper around your data
import 'package:cloud_firestore/cloud_firestore.dart';

// import this for constants
import 'package:mynotes4/services/cloud/cloud_storage_constants.dart';

// this class and all its subclasses are immutable.
@immutable
class CloudNote {
  // define the properties needed
  final String documentId;
  final String ownerUserId;
  final String text;
  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  // create an constructor that gives a snapshot of cloudnote and create an instance of our cloudnote from it
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
