class TeamModel {
  final String id;
  final String name;
  final String logoUrl;
  final List<TeamMember> members;

  TeamModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.members,
  });
}

class TeamMember {
  final String id;
  final String name;
  final String photoUrl;
  final String position;

  TeamMember({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.position,
  });
}