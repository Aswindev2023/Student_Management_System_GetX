import 'package:flutter/material.dart';

import 'dart:io';

import 'package:get/get.dart';
import 'package:students_getx/getX_services/home_getx.dart';
import 'package:students_getx/pages/add_student.dart';
import 'package:students_getx/pages/edit_user.dart';
import 'package:students_getx/pages/view_user.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeGetx>();

    return Scaffold(
      appBar: AppBar(
        leading: Obx(
          () {
            return homeController.isSearching.value
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      homeController.clearSearch();
                    },
                  )
                : const SizedBox();
          },
        ),
        title: Obx(
          () {
            return Text(
              homeController.isSearching.value ? 'Search Results' : 'Students',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 249, 255, 71),
        actions: [
          Obx(
            () {
              return IconButton(
                icon: homeController.isGridView.value
                    ? const Icon(Icons.list)
                    : const Icon(Icons.grid_on),
                onPressed: () {
                  homeController.toggleView();
                },
              );
            },
          ),
          IconButton(
            onPressed: () {
              _showSearchDialog(context);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Obx(
        () {
          return homeController.filteredUserList.isEmpty
              ? const Center(
                  child: Text(
                    'No students available.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : homeController.isGridView.value
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: homeController.filteredUserList.length,
                        itemBuilder: (context, index) {
                          return _buildGridTile(context, index, homeController);
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: homeController.filteredUserList.length,
                        itemBuilder: (context, index) {
                          return _buildListTile(context, index, homeController);
                        },
                      ),
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(() => AddStudentPage());
          if (result != null) {
            homeController.getAllUserDetails();
            _showSuccessSnackBar('New Student added successfully');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, int index, HomeGetx homeController) {
    final user = homeController.filteredUserList[index];
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Get.to(() => ViewUser(user: user));
        },
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: user.imagePath != null
              ? FileImage(File(user.imagePath!))
              : const AssetImage('assets/background.jpg') as ImageProvider,
        ),
        title: Text(user.name ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => EditStudent(user: user))?.then((data) {
                  if (data != null) {
                    homeController.getAllUserDetails();
                    _showSuccessSnackBar(
                        'Student details Updated Successfully');
                  }
                });
              },
              icon: const Icon(Icons.edit, color: Colors.blue),
            ),
            IconButton(
              onPressed: () {
                homeController.deleteUser(user.id!);
                _showSuccessSnackBar('Student details Deleted');
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(
      BuildContext context, int index, HomeGetx homeController) {
    final user = homeController.filteredUserList[index];
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewUser(user: user));
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Expanded(
              child: Image.file(
                File(user.imagePath!),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user.name ?? '',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(() => EditStudent(user: user))?.then((data) {
                      if (data != null) {
                        homeController.getAllUserDetails();
                        _showSuccessSnackBar(
                            'Student details Updated Successfully');
                      }
                    });
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    homeController.deleteUser(user.id!);
                    _showSuccessSnackBar('Student details Deleted');
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Students'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter student name',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                final query = searchController.text.trim();
                final homeController = Get.find<HomeGetx>();
                homeController.updateDisplayedUsers(query);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(6),
      duration: const Duration(seconds: 3),
    );
  }
}
