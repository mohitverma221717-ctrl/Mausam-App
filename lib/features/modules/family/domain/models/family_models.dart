class FamilyMemberCard {
  final String id;
  final String name; // e.g. "Rohan (Son)"
  final String placeName; // "Delhi Public School, Gomti Nagar"
  final String category; // School, College, Work, Elderly
  final double currentTemp;
  final int rainChance;
  final String morningStatus; // "Good Conditions"
  final String? alertNotice; // "Light drizzle expected at 2 PM pick-up"

  const FamilyMemberCard({
    required this.id,
    required this.name,
    required this.placeName,
    required this.category,
    required this.currentTemp,
    required this.rainChance,
    required this.morningStatus,
    this.alertNotice,
  });
}

class FamilyData {
  final String
      schoolCommuteSummary; // "Good Conditions across all school routes"
  final List<FamilyMemberCard> members;
  final bool hasActiveFamilyAlert;

  const FamilyData({
    required this.schoolCommuteSummary,
    required this.members,
    required this.hasActiveFamilyAlert,
  });
}
