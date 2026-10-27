import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../providers/course_provider.dart';
import '../../providers/employer_provider.dart';
import '../../widgets/stat_card.dart';

class EmployerDashboardScreen extends StatelessWidget {
  const EmployerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employer = context.watch<EmployerProvider>();
    final courseProv = context.watch<CourseProvider>();
    final org = employer.organization;

    return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Executive Organization Header & Action Bar
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.corporate_fare_rounded, color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    org.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFBFDBFE)),
                                    ),
                                    child: const Text(
                                      'ENTERPRISE HR CONSOLE',
                                      style: TextStyle(
                                        color: Color(0xFF1E40AF),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Organization overview, employee masterclass assignments & departmental emotional agility analytics.',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddEmployeeDialog(context, employer),
                        icon: const Icon(Icons.person_add_rounded, size: 16),
                        label: const Text('Add Employee'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // KPI Stat Cards
                Wrap(
                  spacing: 16,
                  runSpacing: 14,
                  children: [
                    SizedBox(
                      width: 360,
                      child: StatCard(
                        title: 'Total Seats Purchased',
                        value: '${org.totalSeatsPurchased}',
                        subtitle: '${employer.totalEmployees} seats assigned',
                        icon: Icons.people_alt_outlined,
                        color: AppConstants.primaryDarkBlue,
                      ),
                    ),
                    SizedBox(
                      width: 360,
                      child: StatCard(
                        title: 'Team Avg Progress',
                        value: '${(employer.teamAverageProgress * 100).toStringAsFixed(1)}%',
                        subtitle: '${employer.totalCoursesCompleted} of ${employer.totalCoursesAssigned} courses completed',
                        icon: Icons.trending_up,
                        color: AppConstants.accentPurple,
                        progress: employer.teamAverageProgress,
                      ),
                    ),
                    SizedBox(
                      width: 360,
                      child: StatCard(
                        title: 'Courses Completed',
                        value: '${employer.totalCoursesCompleted}',
                        subtitle: '${employer.totalCoursesAssigned} active enrollments',
                        icon: Icons.school_outlined,
                        color: AppConstants.mindfulnessTeal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Department Analytics Chart (Visual Custom Containers)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Departmental EQ & Well-Being Engagement Analytics',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Breakdown of active learners across company business divisions',
                          style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        ...employer.departmentDistribution.entries.map((entry) {
                          final pct = (entry.value / employer.totalEmployees).clamp(0.0, 1.0);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${entry.key} Department',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    Text(
                                      '${entry.value} Members (${(pct * 100).round()}%)',
                                      style: const TextStyle(
                                        color: AppConstants.accentPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.accentPurple),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Employee Roster & Course Assignment Table
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Enrolled Employee Roster',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${employer.employees.length} Active Employees',
                              style: const TextStyle(color: AppConstants.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Employee Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Assigned Courses', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Progress', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: employer.employees.map((emp) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(emp.email, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(emp.department)),
                                  DataCell(
                                    Text(
                                      '${emp.assignedCourseIds.length} Assigned (${emp.completedCourseIds.length} Done)',
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: emp.averageProgress,
                                              minHeight: 6,
                                              backgroundColor: Colors.grey.shade200,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                emp.averageProgress >= 1.0
                                                    ? AppConstants.successGreen
                                                    : AppConstants.accentPurple,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${(emp.averageProgress * 100).round()}%',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _showAssignCourseDialog(context, employer, courseProv, emp.id);
                                      },
                                      icon: const Icon(Icons.add, size: 14),
                                      label: const Text('Assign Course'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppConstants.primaryDarkBlue,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        textStyle: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  void _showAddEmployeeDialog(BuildContext context, EmployerProvider employer) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String department = 'Engineering';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Employee to Organization'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Employee Full Name *'),
                  validator: (val) => AppValidators.validateRequired(val, 'Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Corporate Email *'),
                  validator: (val) => AppValidators.validateEmail(val),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: department,
                  decoration: const InputDecoration(labelText: 'Department'),
                  items: const [
                    DropdownMenuItem(value: 'Engineering', child: Text('Engineering')),
                    DropdownMenuItem(value: 'Product Management', child: Text('Product Management')),
                    DropdownMenuItem(value: 'People Operations', child: Text('People Operations')),
                    DropdownMenuItem(value: 'Customer Success', child: Text('Customer Success')),
                    DropdownMenuItem(value: 'Finance & Legal', child: Text('Finance & Legal')),
                  ],
                  onChanged: (val) => department = val!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  employer.addEmployee(
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    department: department,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Employee added to organization roster!'),
                      backgroundColor: AppConstants.successGreen,
                    ),
                  );
                }
              },
              child: const Text('Add Employee'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignCourseDialog(
    BuildContext context,
    EmployerProvider employer,
    CourseProvider courseProv,
    String employeeId,
  ) {
    String selectedCourseId = courseProv.courses.first.id;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Assign Course to Employee'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                initialValue: selectedCourseId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Select Course'),
                items: courseProv.courses.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(c.title, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedCourseId = val!),
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                employer.assignCourseToEmployee(employeeId, selectedCourseId);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Course assigned successfully! (Journey D Step)'),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }
}

