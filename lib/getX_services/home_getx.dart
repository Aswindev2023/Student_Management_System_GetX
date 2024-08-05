import 'package:get/get.dart';
import 'package:students_getx/model/user.dart';
import 'package:students_getx/services/user_service.dart';

class HomeGetx extends GetxController {
  final RxList<User> userList = <User>[].obs;
  final RxList<User> filteredUserList = <User>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isGridView = false.obs;

  final _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    getAllUserDetails();
  }

  Future<void> getAllUserDetails() async {
    userList.clear();
    var users = await _userService.readAllUser();

    users.forEach((student) {
      var studentModel = User();
      studentModel.id = student['id'];
      studentModel.name = student['name'];
      studentModel.batch = student['batch'];
      studentModel.contact = student['contact'];
      studentModel.address = student['address'];
      studentModel.imagePath = student['imagePath'] ?? '';

      userList.add(studentModel);
    });
    filteredUserList.value = List.from(userList);
  }

  void updateDisplayedUsers(String query) {
    isSearching.value = query.isNotEmpty;

    filteredUserList.value = userList.where((user) {
      final userName = user.name?.trim().toLowerCase() ?? '';
      final searchQuery = query.trim().toLowerCase();

      return userName.contains(searchQuery);
    }).toList();
  }

  void clearSearch() {
    isSearching.value = false;
    filteredUserList.value = List.from(userList);
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _userService.deleteUser(userId); // Update the database
      userList.removeWhere((user) => user.id == userId);
      filteredUserList.value = List.from(userList);
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  void updateUserList(User updatedUser) {
    var index = userList.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      userList[index] = updatedUser;
      filteredUserList.value = List.from(userList);
    }
  }
}
