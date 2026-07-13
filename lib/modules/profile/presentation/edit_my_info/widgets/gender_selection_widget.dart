import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const GenderSelectionWidget({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(right: 55),
      child: Row(
        children: [
          Text(
            localizations.gender,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Radio<String>(
            value: 'female',
            groupValue: selectedGender.toLowerCase(),
            onChanged: (value) => onChanged(value!),
          ),
          Text(localizations.female),
          const SizedBox(width: 16),
          Radio<String>(
            value: 'male',
            groupValue: selectedGender.toLowerCase(),
            onChanged: (value) => onChanged(value!),
          ),
          Text(localizations.male),
        ],
      ),
    );
  }
}
