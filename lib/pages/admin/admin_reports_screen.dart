import 'package:flutter/material.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  // Controladores para os filtros de data
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Função 'placeholder' para buscar os relatórios
  void _fetchReports() {
    // com base nas datas selecionadas.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buscando relatórios... (Lógica não implementada)'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Função 'placeholder' para mostrar um seletor de data
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        // Formata a data (ex: 03/11/2025)
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const textFieldColor = Color(0xFF2e2d2d);
    const cardColor = Color(0xFF1a1a1a);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: cardColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF9c0707)],
          ),
        ),
        // Aplicando o padrão de alinhamento e largura
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // --- 1. FILTRO POR PERÍODO (Baseado no PDF, Página 8) ---
                    _buildReportCard(
                      cardColor: cardColor,
                      textFieldColor: textFieldColor,
                      primaryColor: primaryColor,
                      title: 'Relatório por Período',
                      child: _buildDateFilter(textFieldColor, primaryColor),
                    ),
                    const SizedBox(height: 32),

                    // --- 2. RELATÓRIO DE SAÍDAS (Baseado no PDF, Página 8) ---
                    _buildReportCard(
                      cardColor: cardColor,
                      textFieldColor: textFieldColor,
                      primaryColor: primaryColor,
                      title: 'Histórico de Saídas de Estoque',
                      child: _buildReportTable(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper para o card padrão
  Widget _buildReportCard({
    required Color cardColor,
    required Color textFieldColor,
    required Color primaryColor,
    required String title,
    required Widget child,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.grey, height: 32),
            child,
          ],
        ),
      ),
    );
  }

  // Helper para o filtro de data
  Widget _buildDateFilter(Color textFieldColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // Campo "De:"
            Expanded(
              child: TextFormField(
                controller: _startDateController,
                readOnly: true, // O campo não pode ser digitado
                onTap: () => _selectDate(context, _startDateController),
                decoration: _buildInputDecoration(
                  'De:',
                  Icons.calendar_today,
                  textFieldColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Campo "Até:"
            Expanded(
              child: TextFormField(
                controller: _endDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _endDateController),
                decoration: _buildInputDecoration(
                  'Até:',
                  Icons.calendar_today,
                  textFieldColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Botão Aplicar Filtro
        ElevatedButton(
          onPressed: _fetchReports,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('APLICAR FILTRO'),
        ),
      ],
    );
  }

  // Helper para a tabela de resultados (com dados de exemplo)
  Widget _buildReportTable() {
    // Dados de exemplo baseados no PDF (Página 8)
    final data = [
      {'item': 'Salsicha', 'data': '24/04/2024 10:32', 'qtd': '4'},
      {'item': 'Pão de Hambúrguer', 'data': '24/04/2024 09:47', 'qtd': '6'},
      {'item': 'Queijo', 'data': '24/04/2024 08:15', 'qtd': '2'},
    ];

    // **** CORREÇÃO APLICADA AQUI ****
    // Adicionado SingleChildScrollView com rolagem horizontal
    // e um Row para garantir que o DataTable tenha espaço infinito para rolar.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          DataTable(
            columns: const [
              DataColumn(
                label: Text(
                  'Nome do Item',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Quantidade',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Data/Hora',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: data.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row['item']!)),
                  DataCell(Text(row['qtd']!)),
                  DataCell(Text(row['data']!)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Helper de decoração (copiado das outras telas)
  InputDecoration _buildInputDecoration(
    String label,
    IconData icon,
    Color fillColor,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: fillColor,
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
