import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';

class AddPhotosScreen extends StatefulWidget {
  const AddPhotosScreen({super.key});

  @override
  State<AddPhotosScreen> createState() => _AddPhotosScreenState();
}

class _AddPhotosScreenState extends State<AddPhotosScreen> {
  final List<String> _selectedPhotos = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1c2426),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Add Photos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          actions: [
            TextButton(
              onPressed: _selectedPhotos.isNotEmpty ? _savePhotos : null,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF47c1ea),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select photos for your event',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose up to 5 photos to showcase your event',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9db2b8),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 15, // Placeholder for photo grid
                  itemBuilder: (context, index) {
                    return _buildPhotoTile(index);
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF47c1ea),
          onPressed: _addPhoto,
          child: const Icon(Icons.add_a_photo, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPhotoTile(int index) {
    final isSelected = _selectedPhotos.contains('photo_$index');
    
    return GestureDetector(
      onTap: () => _togglePhotoSelection('photo_$index'),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1c2426),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF47c1ea) : const Color(0xFF293438),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Placeholder for photo
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF293438),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.image,
                color: Color(0xFF9db2b8),
                size: 32,
              ),
            ),
            if (isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF47c1ea),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _togglePhotoSelection(String photoId) {
    setState(() {
      if (_selectedPhotos.contains(photoId)) {
        _selectedPhotos.remove(photoId);
      } else if (_selectedPhotos.length < 5) {
        _selectedPhotos.add(photoId);
      } else {
        showNeonSnackbar(context, 'You can only select up to 5 photos');
      }
    });
  }

  void _addPhoto() {
    // Placeholder for photo picker functionality
    showNeonSnackbar(context, 'Photo picker functionality will be implemented here');
  }

  void _savePhotos() {
    // Placeholder for saving photos
    showNeonSnackbar(context, '${_selectedPhotos.length} photos selected');
    context.pop();
  }
} 