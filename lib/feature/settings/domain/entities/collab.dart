class CollaboratorUser {
  CollaboratorUser({
    required this.uid,
    required this.email,
    required this.name,
  });
  final String uid;
  final String email;
  final String name;
}

class CollabInvite {
  CollabInvite({
    required this.uid,
    required this.email,
    required this.status,
  }); // waiting | accepted | rejected | removed

  factory CollabInvite.fromMap(Map<String, dynamic> map) => CollabInvite(
    uid: (map['uid'] as String?) ?? '',
    email: (map['email'] as String?) ?? '',
    status: (map['status'] as String?) ?? 'waiting',
  );

  final String uid;
  final String email;
  final String status;

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'status': status,
  };
}

class CollabSummary {
  const CollabSummary({
    this.collaborators = const <CollaboratorUser>[],
    this.invites = const <CollabInvite>[],
  });

  final List<CollaboratorUser> collaborators;
  final List<CollabInvite> invites;
}
