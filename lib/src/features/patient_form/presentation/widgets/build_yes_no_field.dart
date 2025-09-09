import 'package:flutter/material.dart';

Widget buildYesNoField({
  required String label,
  required String? groupValue,
  required void Function(String?) onChanged,
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
                onTap: () => onChanged("Sim"),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Radio<String>(
                      value: "Sim",
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
                onTap: () => onChanged("Não"),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Radio<String>(
                      value: "Não",
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
      if (groupValue == "Sim") ...[
        const SizedBox(height: 12),
        TextFormField(
          initialValue: textValue,
          decoration: InputDecoration(
            labelText: textLabel ?? "Descreva",
          ),
          onChanged: onTextChanged,
          validator: (value) {
            if (groupValue == "Sim" && (value == null || value.isEmpty)) {
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
