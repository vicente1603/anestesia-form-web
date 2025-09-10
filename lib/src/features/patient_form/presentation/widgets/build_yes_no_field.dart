import 'package:flutter/material.dart';

Widget buildYesNoField({
  required String label,
  required bool? groupValue,
  required void Function(bool?) onChanged,
  String? textValue,
  void Function(String)? onTextChanged,
  String? textLabel,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onChanged(true),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: groupValue,
                      onChanged: onChanged,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text("Sim"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => onChanged(false),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: groupValue,
                      onChanged: onChanged,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text("Não"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Se o usuário marcar "Sim", mostra o campo extra
      if (groupValue == true && textLabel != null) ...[
        const SizedBox(height: 12),
        TextFormField(
          initialValue: textValue,
          decoration: InputDecoration(labelText: textLabel),
          onChanged: onTextChanged,
          validator: (value) {
            if (groupValue == true && (value == null || value.isEmpty)) {
              return 'Por favor, descreva';
            }
            return null;
          },
        ),
      ],
      const SizedBox(height: 16),
    ],
  );
}
