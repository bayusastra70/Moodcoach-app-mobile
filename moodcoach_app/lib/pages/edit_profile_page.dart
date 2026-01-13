import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserService userService = UserService();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController ageController;
  late TextEditingController contactController;
  late TextEditingController addressController;
  String? gender;
  File? avatarFile; // file avatar yang akan diupload
  String? avatarUrl; // untuk preview

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    passwordController = TextEditingController();
    ageController = TextEditingController(
      text: widget.user.age != null ? widget.user.age.toString() : '',
    );
    contactController = TextEditingController(text: widget.user.phone ?? '');
    addressController = TextEditingController(text: widget.user.address ?? '');
    gender = widget.user.gender;
    avatarUrl = widget.user.avatar;
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => avatarFile = File(picked.path));
    }
  }

  void updateProfile() async {
    setState(() => isLoading = true);

    final updatedUser = await userService.updateProfile(
      userId: widget.user.id,
      name: nameController.text,
      email: emailController.text,
      password:
          passwordController.text.isNotEmpty ? passwordController.text : null,
      age:
          ageController.text.isNotEmpty
              ? int.tryParse(ageController.text)
              : null,
      gender: gender,
      avatarFile: avatarFile, // kirim file langsung ke backend
      phone: contactController.text.isNotEmpty ? contactController.text : null,
      address:
          addressController.text.isNotEmpty ? addressController.text : null,
    );

    setState(() => isLoading = false);

    if (updatedUser != null) {
      Navigator.pop(
        context,
        updatedUser,
      ); // kembalikan data terbaru ke UserProfilePage
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update profile")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar preview dengan tombol pick image
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      avatarFile != null
                          ? FileImage(avatarFile!)
                          : avatarUrl != null && avatarUrl!.isNotEmpty
                          ? NetworkImage(avatarUrl!)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.blue),
                    onPressed: pickImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password (leave blank to keep current)",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Age",
                prefixIcon: Icon(Icons.cake),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: gender,
              items: const [
                DropdownMenuItem(value: "male", child: Text("Male")),
                DropdownMenuItem(value: "female", child: Text("Female")),
                DropdownMenuItem(value: "other", child: Text("Other")),
              ],
              onChanged: (val) => setState(() => gender = val),
              decoration: const InputDecoration(
                labelText: "Gender",
                prefixIcon: Icon(Icons.wc),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: "Contact",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                prefixIcon: Icon(Icons.home),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : updateProfile,
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
