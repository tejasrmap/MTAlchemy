import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../providers/enquiry_provider.dart';

class CorporateEnquiryScreen extends StatefulWidget {
  const CorporateEnquiryScreen({super.key});

  @override
  State<CorporateEnquiryScreen> createState() => _CorporateEnquiryScreenState();
}

class _CorporateEnquiryScreenState extends State<CorporateEnquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _requirementsController = TextEditingController();

  double _participantsCount = 30;
  String _deliveryMode = 'Hybrid (In-Person Retreat + Digital LMS)';
  final Set<String> _selectedTopics = {'Emotional Intelligence (EQ)', 'Leadership Development'};
  DateTime? _lastSubmitTime;

  @override
  void dispose() {
    _companyController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enquiryProv = context.watch<EnquiryProvider>();

    return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Journey E Notice
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppConstants.accentPurpleLight),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.handshake_outlined, color: AppConstants.accentPurple, size: 30),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'ENTERPRISE CONSULTING PROPOSAL: Partner with MT Alchemy to design customized human-centered leadership, EQ, and team culture transformations for your organization.',
                            style: TextStyle(
                              color: AppConstants.primaryDarkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Corporate Partnership & Consultation Request',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill out your organization\'s objectives and our lead consultants will prepare a custom proposal within 24 hours.',
                    style: TextStyle(color: AppConstants.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Company & Contact
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _companyController,
                          decoration: const InputDecoration(
                            labelText: 'Organization / Company Name *',
                            prefixIcon: Icon(Icons.apartment),
                          ),
                          validator: (val) => AppValidators.validateRequired(val, 'Company Name'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _contactPersonController,
                          decoration: const InputDecoration(
                            labelText: 'Contact Person & Title *',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (val) => AppValidators.validateRequired(val, 'Contact Person'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Corporate Email *',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (val) => AppValidators.validateEmail(val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Contact Phone / WhatsApp *',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (val) => AppValidators.validateRequired(val, 'Phone Number'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Expected Participants Slider
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              const Text('Estimated Number of Participants:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(
                                '${_participantsCount.round()} Leaders / Staff',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.accentPurple,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _participantsCount,
                            min: 5,
                            max: 200,
                            divisions: 39,
                            activeColor: AppConstants.accentPurple,
                            onChanged: (val) => setState(() => _participantsCount = val),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Focus Pillars Checkboxes
                  const Text('Consulting Focus Domains (Select all that apply):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 10),
                  ...AppConstants.coreDomains.map((domain) {
                    final isChecked = _selectedTopics.contains(domain);
                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(domain),
                      activeColor: AppConstants.accentPurple,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedTopics.add(domain);
                          } else {
                            _selectedTopics.remove(domain);
                          }
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 16),

                  // Delivery Mode Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _deliveryMode,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Preferred Delivery Mode *'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Hybrid (In-Person Retreat + Digital LMS)',
                        child: Text('Hybrid (In-Person Retreat + Digital LMS)', overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: 'Fully In-Person Experiential Workshop',
                        child: Text('Fully In-Person Experiential Workshop', overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: '100% Virtual Cohort Coaching & LMS',
                        child: Text('100% Virtual Cohort Coaching & LMS', overflow: TextOverflow.ellipsis),
                      ),
                    ],
                    onChanged: (val) => setState(() => _deliveryMode = val!),
                  ),
                  const SizedBox(height: 16),

                  // Custom Requirements Area
                  TextFormField(
                    controller: _requirementsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Specific Organizational Challenges & Desired Outcomes',
                      hintText: 'e.g., We recently reorganized two divisions and need to build trust and psychological safety between managers...',
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Anti-spam throttling check
                        if (_lastSubmitTime != null &&
                            DateTime.now().difference(_lastSubmitTime!).inSeconds < 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please wait a few seconds before submitting again.')),
                          );
                          return;
                        }

                        if (_formKey.currentState!.validate()) {
                          if (_selectedTopics.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select at least one focus domain.')),
                            );
                            return;
                          }

                          _lastSubmitTime = DateTime.now();

                          final created = await enquiryProv.submitEnquiry(
                            companyName: _companyController.text,
                            contactPerson: _contactPersonController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            participantsCount: _participantsCount.round(),
                            topicsInterested: _selectedTopics.toList(),
                            deliveryMode: _deliveryMode,
                            customRequirements: _requirementsController.text,
                          );

                          if (!context.mounted) return;

                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: AppConstants.successGreen),
                                  SizedBox(width: 10),
                                  Text('Enquiry Received!'),
                                ],
                              ),
                              content: Text(
                                'Thank you, ${_contactPersonController.text}. Your custom programme enquiry (${created.id}) for ${_companyController.text} has been logged successfully and saved to Cloud Firestore. Our lead consultant will contact you via ${_emailController.text}.',
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    _companyController.clear();
                                    _contactPersonController.clear();
                                    _emailController.clear();
                                    _phoneController.clear();
                                    _requirementsController.clear();
                                  },
                                  child: const Text('Done'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Submit Customized Programme Proposal Request'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.accentPurple,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}

