import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/application/auth/auth_state.dart';
import 'package:suebsaiyai/application/district/district_notifier.dart';
import 'package:suebsaiyai/core/constants/route_constants.dart';
import 'package:suebsaiyai/core/utils/validators.dart';
import 'package:suebsaiyai/domain/entities/district_entity.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  DistrictEntity? _selectedDistrict;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกอำเภอ')));
      return;
    }
    final error = await ref
        .read(authNotifierProvider.notifier)
        .register(_emailCtrl.text.trim(), _passwordCtrl.text, _nameCtrl.text.trim(), _selectedDistrict!.id);
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final districtsAsync = ref.watch(allDistrictsProvider);
    final isLoading = authState is AuthStateLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('สมัครสมาชิก'), leading: BackButton(onPressed: () => context.go(RouteConstants.login))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'ชื่อ-นามสกุล', prefixIcon: Icon(Icons.person_outline)), validator: (v) => Validators.required(v, fieldName: 'ชื่อ')),
                  const SizedBox(height: 16),
                  TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'อีเมล', prefixIcon: Icon(Icons.email_outlined)), keyboardType: TextInputType.emailAddress, validator: Validators.email),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                    ),
                    obscureText: _obscurePassword,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  districtsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('โหลดข้อมูลอำเภอไม่ได้: $e'),
                    data: (districts) => DropdownButtonFormField<DistrictEntity>(
                      value: _selectedDistrict,
                      decoration: const InputDecoration(labelText: 'อำเภอ', prefixIcon: Icon(Icons.location_on_outlined)),
                      items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
                      onChanged: (d) => setState(() => _selectedDistrict = d),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('สมัครสมาชิก'),
                  ),
                  const SizedBox(height: 16),
                  Text('สมัครแล้ว คุณจะได้รับสิทธิ์เป็น "นักสืบค้น"\nผู้ดูแลระบบสามารถเพิ่มสิทธิ์ในภายหลัง', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
