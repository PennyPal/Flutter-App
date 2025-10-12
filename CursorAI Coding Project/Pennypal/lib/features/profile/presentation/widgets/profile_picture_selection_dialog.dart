import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../shared/services/profile_picture_service.dart';
import '../../../../shared/services/user_service.dart';

/// Dialog for selecting profile pictures
class ProfilePictureSelectionDialog extends StatefulWidget {
  final Function(String pictureValue, String pictureType)? onPictureSelected;
  
  const ProfilePictureSelectionDialog({
    super.key,
    this.onPictureSelected,
  });

  @override
  State<ProfilePictureSelectionDialog> createState() => _ProfilePictureSelectionDialogState();
}

class _ProfilePictureSelectionDialogState extends State<ProfilePictureSelectionDialog> {
  final _profilePictureService = ProfilePictureService();
  final _userService = UserService();
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose Profile Picture',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Upload from Gallery
            _buildUploadSection(),
            
            const SizedBox(height: 20),
            
            // Finance Icons
            const Text(
              'Finance Icons',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Finance icons grid
            _buildFinanceIconsGrid(),
            
            const SizedBox(height: 20),
            
            // User's uploaded images
            _buildUserImagesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload from Gallery',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _pickImageFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('Choose from Gallery'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B2C91),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceIconsGrid() {
    final financePictures = _profilePictureService.getAllProfilePictures();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: financePictures.length,
      itemBuilder: (context, index) {
        final picture = financePictures[index];
        final isSelected = _userService.profilePictureType == 'finance_icon' &&
            _userService.profilePicture == picture['id'];
        
        return GestureDetector(
          onTap: () => _selectFinanceIcon(picture['id'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xFF6B2C91) : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              picture['icon'] as IconData,
              color: picture['color'] as Color,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserImagesSection() {
    final userImages = _profilePictureService.getUserUploadedImages(_userService.userName);
    
    if (userImages.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Photos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userImages.length,
            itemBuilder: (context, index) {
              final imagePath = userImages[index];
              final isSelected = _userService.profilePictureType == 'uploaded_image' &&
                  _userService.profilePicture == imagePath;
              
              return GestureDetector(
                onTap: () => _selectUploadedImage(imagePath),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF6B2C91) : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 80,
      );
      
      if (image != null) {
        // Add to user's uploaded images
        _profilePictureService.addUserImage(_userService.userName, image.path);
        
        // Call the callback with the selected image
        widget.onPictureSelected?.call(image.path, 'uploaded_image');
        
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectFinanceIcon(String iconId) {
    // Call the callback with the selected finance icon
    widget.onPictureSelected?.call(iconId, 'finance_icon');
    
    Navigator.pop(context);
  }

  void _selectUploadedImage(String imagePath) {
    // Call the callback with the selected uploaded image
    widget.onPictureSelected?.call(imagePath, 'uploaded_image');
    
    Navigator.pop(context);
  }
}
