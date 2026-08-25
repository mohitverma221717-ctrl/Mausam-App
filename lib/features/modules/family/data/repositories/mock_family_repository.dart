import '../../domain/models/family_models.dart';

class MockFamilyRepository {
  Future<FamilyData> getFamilyData() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const FamilyData(
      schoolCommuteSummary: 'Good Conditions across morning school routes.',
      hasActiveFamilyAlert: false,
      members: [
        FamilyMemberCard(
          id: 'fam-1',
          name: 'Aarav (Son)',
          placeName: 'Delhi Public School, Gomti Nagar',
          category: 'School',
          currentTemp: 28.0,
          rainChance: 30,
          morningStatus: 'Good Conditions',
          alertNotice: 'Passing light cloud cover; no morning delay.',
        ),
        FamilyMemberCard(
          id: 'fam-2',
          name: 'Pooja (Spouse)',
          placeName: 'Cyber Heights Tech Park, Vibhuti Khand',
          category: 'Work',
          currentTemp: 29.0,
          rainChance: 20,
          morningStatus: 'Clear Roads',
        ),
        FamilyMemberCard(
          id: 'fam-3',
          name: 'Parents Home',
          placeName: 'Indira Nagar, Sector 14',
          category: 'Elderly',
          currentTemp: 28.0,
          rainChance: 15,
          morningStatus: 'Pleasant & Mild AQI',
        ),
      ],
    );
  }
}
