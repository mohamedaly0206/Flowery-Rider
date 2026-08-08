import 'dart:async';
import 'dart:io';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/features/profile/my_profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/edit_my_info/view_model/cubit/edit_profile_cubit.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/edit_my_info/view_model/intent/edit_profile_intent.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/edit_my_info/view_model/state/edit_profile_state.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/edit_my_info/widgets/gender_selection_widget.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditMyInfoView extends StatefulWidget {
  final DriverProfileEntity driver;

  const EditMyInfoView({super.key, required this.driver});

  @override
  State<EditMyInfoView> createState() => _EditMyInfoViewState();
}

class _EditMyInfoViewState extends State<EditMyInfoView> {
  late final StreamSubscription<BaseEvent> _eventSubscription;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late String _gender;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(text: widget.driver.firstName);
    _lastNameController = TextEditingController(text: widget.driver.lastName);
    _emailController = TextEditingController(text: widget.driver.email);
    _phoneController = TextEditingController(text: widget.driver.phone);
    _gender = widget.driver.gender;

    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);

    _eventSubscription = context.read<EditProfileCubit>().eventStream.listen((
      event,
    ) {
      if (!mounted) return;

      if (event is DisplaySuccess) {
        AppMessages.showSuccess(context, message: event.message);
        context.pop(true);
      } else if (event is DisplayError) {
        AppMessages.showError(context, message: event.message);
      }
    });
  }

  void _onFieldChanged() {
    setState(() {});
  }

  bool get _isFormChanged {
    final isFirstNameChanged =
        _firstNameController.text.trim() != widget.driver.firstName;
    final isLastNameChanged =
        _lastNameController.text.trim() != widget.driver.lastName;
    final isEmailChanged = _emailController.text.trim() != widget.driver.email;
    final isPhoneChanged = _phoneController.text.trim() != widget.driver.phone;
    final isGenderChanged = _gender != widget.driver.gender;
    final isImageChanged = _selectedImage != null;

    return isFirstNameChanged ||
        isLastNameChanged ||
        isEmailChanged ||
        isPhoneChanged ||
        isGenderChanged ||
        isImageChanged;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    _firstNameController.removeListener(_onFieldChanged);
    _lastNameController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: localizations.editProfile),
      body: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : NetworkImage(widget.driver.photo),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.whiteColor,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.greyColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: localizations.firstName,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: localizations.lastName,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: localizations.email,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: localizations.phoneNumber,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: localizations.password,
                        prefixText: '*******',
                        prefixStyle: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 25,
                        ),
                        suffix: InkWell(
                          onTap: () {},
                          child: Text(
                            localizations.change,
                            style: TextStyle(color: AppColors.greyColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GenderSelectionWidget(
                      selectedGender: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormChanged
                              ? AppColors
                                    .primaryColor
                              : AppColors
                                    .placeHolderColor,
                          disabledBackgroundColor: AppColors.placeHolderColor,
                        ),
                        onPressed: _isFormChanged && !state.isLoading
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.handleIntent(
                                    UpdateProfileFieldsIntent(
                                      firstName: _firstNameController.text
                                          .trim(),
                                      lastName: _lastNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      gender: _gender,
                                      imageFile:
                                          _selectedImage,
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Text(
                          localizations.update,
                          style: const TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isLoading)
                Positioned.fill(
                  child: ColoredBox(
                    color: AppColors.transparentColor,
                    child: Center(
                      child: SpinKitFadingCircle(
                        color: Theme.of(context).colorScheme.primary,
                        size: 50,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
