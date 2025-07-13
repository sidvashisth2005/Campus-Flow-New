import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'services/club_service.dart';
import 'models/club.dart';
import 'package:uuid/uuid.dart';

class CreateClubScreen extends StatefulWidget {
  const CreateClubScreen({Key? key}) : super(key: key);

  @override
  State<CreateClubScreen> createState() => _CreateClubScreenState();
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String? _category;
  bool _loading = false;
  String? _error;

  final List<String> _categories = [
    'Tech', 'Music', 'Sports', 'Cultural', 'Literary', 'Academic', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final isClubSecretaryOrAdmin = user?.role == 'club_secretaries' || user?.role == 'admins';
    if (!isClubSecretaryOrAdmin) {
      return Scaffold(
        backgroundColor: const Color(0xFF111618),
        body: const Center(
          child: Text('You do not have permission to create a club.', style: TextStyle(color: Colors.white70)),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111618),
          elevation: 0,
          title: const Text('Create Club', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Club Name',
                    style: TextStyle(color: Color(0xFF47c1ea), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Enter club name'),
                    onChanged: (v) => _name = v,
                    validator: (v) => v == null || v.isEmpty ? 'Enter club name' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(color: Color(0xFF47c1ea), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Enter club description'),
                    maxLines: 3,
                    onChanged: (v) => _description = v,
                    validator: (v) => v == null || v.isEmpty ? 'Enter club description' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Category',
                    style: TextStyle(color: Color(0xFF47c1ea), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _category,
                    dropdownColor: const Color(0xFF1c2426),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Select category'),
                    items: _categories.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    )).toList(),
                    onChanged: (v) => setState(() => _category = v),
                    validator: (v) => v == null || v.isEmpty ? 'Select a category' : null,
                  ),
                  const SizedBox(height: 32),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF47c1ea),
                        foregroundColor: const Color(0xFF111618),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      onPressed: _loading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() { _loading = true; _error = null; });
                          try {
                            final club = Club(
                              id: const Uuid().v4(),
                              name: _name.trim(),
                              description: _description.trim(),
                              category: _category,
                              createdBy: user!.id,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );
                            await ClubService().createClub(club);
                            if (mounted) {
                              showNeonSnackbar(context, 'Club created successfully!');
                              Navigator.of(context).pop(); // Go back to Community tab
                            }
                          } catch (e) {
                            setState(() { _error = 'Failed to create club: $e'; });
                          } finally {
                            setState(() { _loading = false; });
                          }
                        }
                      },
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF111618)),
                            )
                          : const Text('Create Club'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9db2b8)),
      filled: true,
      fillColor: const Color(0xFF1c2426),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF293438)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF293438)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF47c1ea)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
} 