import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/community_service.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  CommunityGroupType _selectedType = CommunityGroupType.nyumbaKumi;
  bool _isPrivate = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createGroup,
            child:
                _isLoading
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text('Create'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildGroupTypeSelection(),
            const SizedBox(height: 24),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildLocationField(),
            const SizedBox(height: 16),
            _buildPrivacySettings(),
            const SizedBox(height: 24),
            _buildGroupTypeInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Type',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...CommunityGroupType.values.map((type) {
          return RadioListTile<CommunityGroupType>(
            title: Text(_getGroupTypeName(type)),
            subtitle: Text(_getGroupTypeDescription(type)),
            value: type,
            groupValue: _selectedType,
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
            secondary: Icon(_getGroupTypeIcon(type)),
          );
        }),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Group Name',
        hintText: 'Enter group name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a group name';
        }
        if (value.trim().length < 3) {
          return 'Group name must be at least 3 characters';
        }
        return null;
      },
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Describe the purpose of this group',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a description';
        }
        if (value.trim().length < 10) {
          return 'Description must be at least 10 characters';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: 'Location',
        hintText: 'e.g., Westlands, Nairobi',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.location_on),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a location';
        }
        return null;
      },
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildPrivacySettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Settings',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Private Group'),
              subtitle: Text(
                _isPrivate
                    ? 'Only invited members can join'
                    : 'Anyone can discover and join this group',
              ),
              value: _isPrivate,
              onChanged: (value) {
                setState(() {
                  _isPrivate = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTypeInfo() {
    return Card(
      color: _getGroupTypeColor(_selectedType).withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getGroupTypeIcon(_selectedType),
                  color: _getGroupTypeColor(_selectedType),
                ),
                const SizedBox(width: 8),
                Text(
                  _getGroupTypeName(_selectedType),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getGroupTypeColor(_selectedType),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getGroupTypeFullDescription(_selectedType),
              style: TextStyle(
                fontSize: 12,
                color: _getGroupTypeColor(_selectedType).withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGroupTypeName(CommunityGroupType type) {
    switch (type) {
      case CommunityGroupType.nyumbaKumi:
        return 'Nyumba Kumi';
      case CommunityGroupType.estate:
        return 'Estate Community';
      case CommunityGroupType.neighborhood:
        return 'Neighborhood';
      case CommunityGroupType.building:
        return 'Building/Apartment';
    }
  }

  String _getGroupTypeDescription(CommunityGroupType type) {
    switch (type) {
      case CommunityGroupType.nyumbaKumi:
        return 'Community security and safety group';
      case CommunityGroupType.estate:
        return 'Residential estate community';
      case CommunityGroupType.neighborhood:
        return 'General neighborhood group';
      case CommunityGroupType.building:
        return 'Specific building or apartment block';
    }
  }

  String _getGroupTypeFullDescription(CommunityGroupType type) {
    switch (type) {
      case CommunityGroupType.nyumbaKumi:
        return 'Nyumba Kumi groups are community-based security initiatives that bring together 10 households for collective security, safety, and development. Members work together to prevent crime, report suspicious activities, and support each other in emergencies.';
      case CommunityGroupType.estate:
        return 'Estate communities are for residents of a specific residential estate or gated community. These groups help coordinate maintenance, security, social events, and address common concerns affecting the entire estate.';
      case CommunityGroupType.neighborhood:
        return 'Neighborhood groups bring together residents from a broader area to discuss local issues, organize community events, share information, and work on neighborhood improvement projects.';
      case CommunityGroupType.building:
        return 'Building-specific groups are for residents of the same apartment building or complex. They coordinate building maintenance, security measures, utility management, and resident communications.';
    }
  }

  IconData _getGroupTypeIcon(CommunityGroupType type) {
    switch (type) {
      case CommunityGroupType.nyumbaKumi:
        return Icons.security;
      case CommunityGroupType.estate:
        return Icons.home_work;
      case CommunityGroupType.neighborhood:
        return Icons.location_city;
      case CommunityGroupType.building:
        return Icons.apartment;
    }
  }

  Color _getGroupTypeColor(CommunityGroupType type) {
    switch (type) {
      case CommunityGroupType.nyumbaKumi:
        return Colors.blue;
      case CommunityGroupType.estate:
        return Colors.green;
      case CommunityGroupType.neighborhood:
        return Colors.orange;
      case CommunityGroupType.building:
        return Colors.purple;
    }
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      ref
          .read(communityServiceProvider)
          .createGroup(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            type: _selectedType,
            location: _locationController.text.trim(),
            isPrivate: _isPrivate,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_nameController.text.trim()} created successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
