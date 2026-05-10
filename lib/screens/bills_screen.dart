import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mess_provider.dart';
import '../models/models.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({Key? key}) : super(key: key);

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  late TextEditingController _amountController;
  late TextEditingController _paidController;

  String? _selectedMember;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _paidController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  void _showGenerateBillDialog() {
    _amountController.clear();
    _paidController.clear();
    _selectedMember = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Bill'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<MessProvider>(
                  builder: (context, provider, _) => DropdownButton<String>(
                    value: _selectedMember,
                    onChanged: (value) {
                      setState(() => _selectedMember = value);
                    },
                    items: provider.members
                        .map((member) => DropdownMenuItem(
                          value: member.id,
                          child: Text(member.name),
                        ))
                        .toList(),
                    isExpanded: true,
                    hint: const Text('Select member'),
                  ),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Total Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _paidController,
                  decoration: const InputDecoration(labelText: 'Amount Paid (optional)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_selectedMember == null || _amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill required fields')),
                );
                return;
              }

              final bill = Bill(
                memberId: _selectedMember!,
                totalAmount: double.parse(_amountController.text),
                paid: _paidController.text.isEmpty ? 0 : double.parse(_paidController.text),
                expenseIds: [],
              );

              context.read<MessProvider>().addBill(bill);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bill generated successfully')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(Bill bill) {
    _paidController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pending: ₹${bill.pending.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: _paidController,
              decoration: const InputDecoration(labelText: 'Amount Paid'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_paidController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter amount')),
                );
                return;
              }

              final amount = double.parse(_paidController.text);
              final newPaid = bill.paid + amount;
              final status = newPaid >= bill.totalAmount ? 'paid' : 'pending';

              final updated = bill.copyWith(
                paid: newPaid,
                status: status,
              );

              context.read<MessProvider>().updateBill(updated);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment recorded')),
              );
            },
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
      ),
      body: Consumer<MessProvider>(
        builder: (context, provider, _) {
          if (provider.bills.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bill_outline, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No bills generated yet'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showGenerateBillDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Generate Bill'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.bills.length,
            itemBuilder: (context, index) {
              final bill = provider.bills[index];
              final member = provider.members.firstWhere(
                (m) => m.id == bill.memberId,
                orElse: () => Member(name: 'Unknown', email: '', phone: ''),
              );

              Color statusColor = Colors.grey;
              IconData statusIcon = Icons.info;

              if (bill.status == 'paid') {
                statusColor = Colors.green;
                statusIcon = Icons.check_circle;
              } else if (bill.isOverdue) {
                statusColor = Colors.red;
                statusIcon = Icons.error;
              } else if (bill.status == 'pending') {
                statusColor = Colors.orange;
                statusIcon = Icons.schedule;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor.withOpacity(0.2),
                    child: Icon(statusIcon, color: statusColor),
                  ),
                  title: Text(member.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total: ₹${bill.totalAmount.toStringAsFixed(2)}'),
                      Text('Paid: ₹${bill.paid.toStringAsFixed(2)}'),
                      Text(
                        'Pending: ₹${bill.pending.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: bill.isOverdue ? Colors.red : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () => _showPaymentDialog(bill),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.blue),
                        const SizedBox(height: 4),
                        const Text(
                          'Pay',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Bill?'),
                        content: const Text('This action cannot be undone'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              provider.deleteBill(bill.id);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Bill deleted')),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showGenerateBillDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
