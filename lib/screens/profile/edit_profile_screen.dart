// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../core/constants/app_colors.dart';
// import '../../providers/profile_provider.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   bool _isSaving = false;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       await context.read<ProfileProvider>().loadCurrentProfileName(_nameController);
//     });
//   }
//
//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isSaving = true);
//
//     final profileProvider = context.read<ProfileProvider>();
//     final success = await profileProvider.updateProfileName(_nameController.text);
//
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             success ? 'Profil berhasil diperbarui' : 'Gagal memperbarui profil',
//           ),
//         ),
//       );
//       if (success) Navigator.pop(context);
//     }
//
//     setState(() => _isSaving = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profil'),
//         backgroundColor: kPrimaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Nama Lengkap',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _isSaving ? null : _saveProfile,
//                 icon: const Icon(Icons.save),
//                 label: _isSaving
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('Simpan'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<ProfileProvider>().loadCurrentProfileName(_nameController);
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.updateProfileName(_nameController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Profil berhasil diperbarui' : 'Gagal memperbarui profil',
          ),
        ),
      );
      if (success) Navigator.pop(context);
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = kTeal;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: kWhite,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    );

    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: kBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBlack),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: primaryColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: outlineBorder,
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: const Icon(Icons.save),
                  label: _isSaving
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: kWhite,
                      strokeWidth: 3,
                    ),
                  )
                      : const Text('Simpan'),
                  style: buttonStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}