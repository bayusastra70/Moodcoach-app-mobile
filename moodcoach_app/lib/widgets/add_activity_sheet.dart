import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../services/activity_service.dart';

class AddActivitySheet extends StatefulWidget {
  final String token;
  final DateTime date;

  const AddActivitySheet({super.key, required this.token, required this.date});

  @override
  State<AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends State<AddActivitySheet> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _noteController = TextEditingController();

  String _type = 'work';
  bool _loading = false;

  final _types = ['work', 'exercise', 'social', 'sleep', 'hobby', 'other'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A11CB),
              ),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _type,
              decoration: _inputDecoration('Activity Type'),
              items:
                  _types
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toUpperCase()),
                        ),
                      )
                      .toList(),
              onChanged: (v) => setState(() => _type = v!),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Duration (minutes)'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (int.tryParse(v) == null) return 'Invalid number';
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: _inputDecoration('Note (optional)'),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A11CB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child:
                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Save Activity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final activity = Activity(
      id: 0,
      type: _type,
      durationMinutes: int.parse(_durationController.text),
      note: _noteController.text.isEmpty ? null : _noteController.text,
      date: widget.date.toIso8601String().substring(0, 10),
    );

    await ActivityService.createActivity(
      token: widget.token,
      activity: activity,
    );

    if (mounted) Navigator.pop(context, true);
  }
}
