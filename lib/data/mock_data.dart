import '../models/models.dart';

/// Static seed data. Swap this file out for real API/Firestore calls later —
/// every screen only ever talks to [AppState], never to this file directly.
class MockData {
  MockData._();

  static final List<ParkInfo> parks = [
    const ParkInfo(
      id: 'park_e11',
      name: 'E-11 Iqbal Park',
      headMurabbiName: 'Hanzala Usman',
      parkAdminNames: ['Hanzala Usman', 'Usama Bilal'],
      groupIds: ['grp_a', 'grp_b'],
    ),
    const ParkInfo(
      id: 'park_f10',
      name: 'F-10 Fatima Park',
      headMurabbiName: 'Ahmad Raza',
      parkAdminNames: ['Ahmad Raza'],
      groupIds: ['grp_c', 'grp_d'],
    ),
    const ParkInfo(
      id: 'park_g9',
      name: 'G-9 Margalla Park',
      headMurabbiName: 'Bilal Tariq',
      parkAdminNames: ['Bilal Tariq'],
      groupIds: ['grp_e'],
    ),
    const ParkInfo(
      id: 'park_g11',
      name: 'G-11 Jinnah Park',
      headMurabbiName: 'Zubair Qureshi',
      parkAdminNames: ['Zubair Qureshi'],
      groupIds: ['grp_f'],
    ),
    const ParkInfo(
      id: 'park_i10',
      name: 'I-10 Islamabad Park',
      headMurabbiName: 'Usama Bin Tariq',
      parkAdminNames: ['Usama Bin Tariq'],
      groupIds: ['grp_g'],
    ),
    const ParkInfo(
      id: 'park_i12',
      name: 'I-12 Liaqat Park',
      headMurabbiName: 'Hafiz Bilal Ahmed',
      parkAdminNames: ['Hafiz Bilal Ahmed'],
      groupIds: ['grp_h'],
    ),
  ];

  static final List<GroupInfo> groups = [
    const GroupInfo(id: 'grp_a', name: 'Group A', parkId: 'park_e11', murabbiId: 'u_murabbi_1', murabbiName: 'Muhammad Hanzala Usman'),
    const GroupInfo(id: 'grp_b', name: 'Group B', parkId: 'park_e11', murabbiId: 'u_murabbi_2', murabbiName: 'Usama Bilal'),
    const GroupInfo(id: 'grp_c', name: 'Group C', parkId: 'park_f10', murabbiId: 'u_murabbi_3', murabbiName: 'Bilal Khan'),
    const GroupInfo(id: 'grp_d', name: 'Group D', parkId: 'park_f10', murabbiId: 'u_murabbi_4', murabbiName: 'Ahmed Qureshi'),
    const GroupInfo(id: 'grp_e', name: 'Group E', parkId: 'park_g9', murabbiId: 'u_murabbi_5', murabbiName: 'Ali Shan'),
    const GroupInfo(id: 'grp_f', name: 'Group F', parkId: 'park_g11', murabbiId: 'u_murabbi_6', murabbiName: 'Zubair Shah'),
    const GroupInfo(id: 'grp_g', name: 'Group G', parkId: 'park_i10', murabbiId: 'u_murabbi_7', murabbiName: 'Hamza Nabeel'),
    const GroupInfo(id: 'grp_h', name: 'Group H', parkId: 'park_i12', murabbiId: 'u_murabbi_8', murabbiName: 'Usman Ali'),
  ];

  static final List<ShababMember> members = [
    ShababMember(id: 'm1', name: 'Ahmed Khan', groupId: 'grp_a', phone: '0300 1234567', fatherName: 'Tariq Khan', cnic: '35202-1234567-1', address: 'Street 4, Sector Y, Lahore', dob: '12/04/2011', consecutiveAbsences: 3),
    ShababMember(id: 'm2', name: 'Asad Ali', groupId: 'grp_a', phone: '0300 2345678', fatherName: 'Naveed Ali', cnic: '35202-2345678-2', address: 'Street 8, Sector B, Lahore', dob: '02/09/2010'),
    ShababMember(id: 'm3', name: 'Qasim Ali', groupId: 'grp_a', phone: '0300 3456789', fatherName: 'Waqas Ali', cnic: '35202-3456789-3', address: 'Street 2, Sector Y, Lahore', dob: '20/11/2011'),
    ShababMember(id: 'm4', name: 'Bilal Tariq Jr.', groupId: 'grp_a', phone: '0300 4567890', fatherName: 'Tariq Mehmood', cnic: '35202-4567890-4', address: 'Street 6, Sector Y, Lahore', dob: '15/01/2012'),
    ShababMember(id: 'm5', name: 'Hamza Nabeel Jr.', groupId: 'grp_a', phone: '0300 5678901', fatherName: 'Nabeel Ahmed', cnic: '35202-5678901-5', address: 'Street 9, Sector B, Lahore', dob: '03/07/2011'),
    ShababMember(id: 'm6', name: 'Usman Ghani', groupId: 'grp_b', phone: '0300 6789012', fatherName: 'Ghani Akbar', cnic: '35202-6789012-6', address: 'Street 1, Sector C, Lahore', dob: '18/03/2010'),
    ShababMember(id: 'm7', name: 'Zubair Anwar', groupId: 'grp_b', phone: '0300 7890123', fatherName: 'Anwar Iqbal', cnic: '35202-7890123-7', address: 'Street 3, Sector C, Lahore', dob: '22/06/2011'),
    ShababMember(id: 'm8', name: 'Hassan Raza', groupId: 'grp_b', phone: '0300 8901234', fatherName: 'Raza Mehmood', cnic: '35202-8901234-8', address: 'Street 5, Sector C, Lahore', dob: '09/12/2010'),
  ];

  /// Demo login directory — in a real build this becomes a backend auth call
  /// that returns the user + role for the given phone number / login id.
  static final List<AppUser> users = [
    const AppUser(id: 'u_murabbi_1', name: 'Muhammad Hanzala Usman', phone: '0300 1112223', role: UserRole.murabbi, parkId: 'park_e11', ownGroupId: 'grp_a'),
    const AppUser(id: 'u_parkadmin_1', name: 'Hanzala Usman', phone: '0300 2223334', role: UserRole.parkAdmin, parkId: 'park_e11', ownGroupId: 'grp_a'),
    const AppUser(id: 'u_citymasul_1', name: 'Ahmad Raza', phone: '0300 3334445', role: UserRole.cityMasul, parkId: 'park_f10'),
  ];

  static AppUser? findUser(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    for (final u in users) {
      if (u.phone.replaceAll(RegExp(r'\s+'), '') == cleaned) return u;
    }
    return null;
  }

  static List<GroupInfo> groupsForPark(String parkId) => groups.where((g) => g.parkId == parkId).toList();

  static List<ShababMember> membersForGroup(String groupId) => members.where((m) => m.groupId == groupId).toList();

  static ParkInfo parkById(String id) => parks.firstWhere((p) => p.id == id);

  static GroupInfo groupById(String id) => groups.firstWhere((g) => g.id == id);
}
