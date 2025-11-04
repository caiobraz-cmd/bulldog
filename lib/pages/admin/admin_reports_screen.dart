import 'package:flutter/material.dart';

/// Tela administrativa para visualização de relatórios.
///
/// Permite ao admin filtrar saídas por período e visualizar
/// um histórico de todas as saídas de estoque (atualmente com dados simulados).
class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  /// Controladores para os campos de texto de data "De:" e "Até:".
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  /// Função (placeholder) para buscar os relatórios na API
  /// com base nas datas selecionadas.
  void _fetchReports() {
    // TODO: Implementar a lógica de busca na API usando
    // _startDateController.text e _endDateController.text.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buscando relatórios... (Lógica não implementada)'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Exibe um [showDatePicker] para selecionar uma data e
  /// atualiza o [controller] fornecido com a data formatada.
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      // TODO: Implementar um tema escuro/vermelho para o DatePicker
      // para combinar com a identidade visual do app.
    );

    if (picked != null) {
      setState(() {
        // Formata a data para o padrão dd/MM/yyyy
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
          // Gradiente padrão do app
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF9c0707)],
          ),
        ),
        // Alinha o conteúdo no topo e limita a largura
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              // Limita a largura máxima em telas maiores
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    /// Card para o filtro "Relatório por Período"
                    _buildReportCard(
                      cardColor: cardColor,
                      title: 'Relatório por Período',
                      child: _buildDateFilter(textFieldColor, primaryColor),
                    ),
                    const SizedBox(height: 32),

                    /// Card para o "Histórico de Saídas de Estoque"
                    _buildReportCard(
                      cardColor: cardColor,
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

  /// Helper para construir o [Card] padrão da tela de relatórios.
  Widget _buildReportCard({
    required Color cardColor,
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

  /// Helper para construir o widget de filtro de data.
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
                readOnly: true, // Campo não é editável diretamente
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

  /// Helper para construir a tabela de resultados.
  /// (Atualmente, usa dados de exemplo).
  Widget _buildReportTable() {
    // Dados de exemplo baseados no PDF (Página 8)
    final data = [
      {'item': 'Salsicha', 'data': '24/04/2024 10:32', 'qtd': '4'},
      {'item': 'Pão de Hambúrguer', 'data': '24/04/2024 09:47', 'qtd': '6'},
      {'item': 'Queijo', 'data': '24/04/2024 08:15', 'qtd': '2'},
    ];

    /// A [DataTable] é envolvida por um [SingleChildScrollView] horizontal
    /// para evitar o 'RenderFlex overflow' (estouro de pixels) em telas
    /// pequenas (mobile).
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
            // Mapeia os dados de exemplo para as linhas da tabela
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

  /// Helper para construir a decoração padrão dos [TextFormField] desta tela.
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
      // Adicionado 'enabledBorder' para consistência
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
