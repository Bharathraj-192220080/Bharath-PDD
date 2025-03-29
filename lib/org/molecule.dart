import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:appmolecule/org/about.dart';
import 'package:appmolecule/org/setting.dart';
import 'dart:math' as math;

class EnhancedMolecularCharts extends StatefulWidget {
  final String sequence;
  final String transmembraneRegions;
  final String disorderedRegions;

  const EnhancedMolecularCharts({
    super.key,
    required this.sequence,
    required this.transmembraneRegions,
    required this.disorderedRegions,
  });

  @override
  State<EnhancedMolecularCharts> createState() => _EnhancedMolecularChartsState();
}

class _EnhancedMolecularChartsState extends State<EnhancedMolecularCharts>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<double> transmembraneData = [];
  List<double> disorderedData = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    calculateData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void calculateData() {
    final hydrophobicResidues = {'A', 'I', 'L', 'M', 'F', 'W', 'Y', 'V'};
    final disorderedResidues = {'S', 'T', 'Q', 'E', 'R', 'N', 'K', 'D', 'P'};

    transmembraneData = List.generate(widget.sequence.length, (index) {
      return hydrophobicResidues.contains(widget.sequence[index]) ? 1.0 : 0.0;
    });

    disorderedData = List.generate(widget.sequence.length, (index) {
      return disorderedResidues.contains(widget.sequence[index]) ? 1.0 : 0.0;
    });
  }

  Widget buildAnimatedChart({
    required List<double> data,
    required String title,
    required Color color,
    required Color gradientColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 0.5,
                    verticalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  ),
                  minX: 0,
                  maxX: data.length.toDouble() - 1,
                  minY: 0,
                  maxY: 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: false,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            gradientColor.withOpacity(0.3),
                            gradientColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Sequence Length: ${widget.sequence.length} amino acids'),
                Text('Transmembrane Regions: ${widget.transmembraneRegions}'),
                Text('Disordered Regions: ${widget.disorderedRegions}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        buildAnimatedChart(
          data: transmembraneData,
          title: 'Transmembrane Regions Distribution',
          color: Colors.blue,
          gradientColor: Colors.blue,
        ),
        const SizedBox(height: 16),
        buildAnimatedChart(
          data: disorderedData,
          title: 'Disordered Regions Distribution',
          color: Colors.red,
          gradientColor: Colors.red,
        ),
      ],
    );
  }
}

// Main Screen
class MolecularAnalyzerScreen extends StatefulWidget {
  const MolecularAnalyzerScreen({super.key});

  @override
  _MolecularAnalyzerScreenState createState() => _MolecularAnalyzerScreenState();
}

class _MolecularAnalyzerScreenState extends State<MolecularAnalyzerScreen> {
  final TextEditingController _sequenceController = TextEditingController();
  String hydrophobicity = '';
  String molecularWeight = '';
  String isoelectricPoint = '';
  String snps = '';
  String transmembraneRegions = '';
  String disorderedRegions = '';

  String calculateHydrophobicity(String sequence) {
    return sequence.length > 10 ? 'High' : 'Low';
  }

  String calculateMolecularWeight(String sequence) {
    final Map<String, double> weights = {
      'A': 89.1, 'C': 121.2, 'D': 133.1, 'E': 147.1, 'F': 165.2, 'G': 75.1,
      'H': 155.2, 'I': 131.2, 'K': 146.2, 'L': 131.2, 'M': 149.2, 'N': 132.1,
      'P': 115.1, 'Q': 146.2, 'R': 174.2, 'S': 105.1, 'T': 119.1, 'V': 117.1,
      'W': 204.2, 'Y': 181.2,
    };
    double totalWeight = 0.0;
    for (var char in sequence.split('')) {
      totalWeight += weights[char] ?? 0.0;
    }
    return '${totalWeight.toStringAsFixed(2)} g/mol';
  }

  String calculateIsoelectricPoint(String sequence) {
    return (sequence.length % 7 + 4.5).toStringAsFixed(2);
  }

  String detectSNPs(String sequence) {
    return sequence.contains('G') ? 'SNP Detected' : 'No SNPs Detected';
  }

  String calculateTransmembraneRegions(String sequence) {
    final hydrophobicResidues = {'A', 'I', 'L', 'M', 'F', 'W', 'Y', 'V'};
    int count = 0;
    bool inRegion = false;
    for (var char in sequence.split('')) {
      if (hydrophobicResidues.contains(char)) {
        if (!inRegion) {
          inRegion = true;
          count++;
        }
      } else {
        inRegion = false;
      }
    }
    return '$count regions detected';
  }

  String calculateDisorderedRegions(String sequence) {
    final disorderedResidues = {'S', 'T', 'Q', 'E', 'R', 'N', 'K', 'D', 'P'};
    int count = 0;
    bool inRegion = false;
    for (var char in sequence.split('')) {
      if (disorderedResidues.contains(char)) {
        if (!inRegion) {
          inRegion = true;
          count++;
        }
      } else {
        inRegion = false;
      }
    }
    return '$count regions detected';
  }

  void analyzeProperties() {
    String sequence = _sequenceController.text.trim().toUpperCase();

    if (sequence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a sequence'))
      );
      return;
    }

    final validAminoAcids = RegExp(r'^[ACDEFGHIKLMNPQRSTVWY]+$');
    if (!validAminoAcids.hasMatch(sequence)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid sequence! Use only amino acid letters (A, C, D, E, F, G, H, I, K, L, M, N, P, Q, R, S, T, V, W, Y).'))
      );
      return;
    }

    if (sequence.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sequence too short! Enter at least 5 amino acids.'))
      );
      return;
    }

    setState(() {
      hydrophobicity = calculateHydrophobicity(sequence);
      molecularWeight = calculateMolecularWeight(sequence);
      isoelectricPoint = calculateIsoelectricPoint(sequence);
      snps = detectSNPs(sequence);
      transmembraneRegions = calculateTransmembraneRegions(sequence);
      disorderedRegions = calculateDisorderedRegions(sequence);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Molecular Property Analyzer'),
        elevation: 2,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.science, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Analyzer Menu',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Molecular Analysis'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingNow()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
      Positioned.fill(
      child: Opacity(
      opacity: 0.1,
        child: Center(
          child: Image.asset(
            'assets/logo.webp',
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),

    SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    TextField(
    controller: _sequenceController,
    decoration: const InputDecoration(
    labelText: 'Enter Molecular Sequence',
    border: OutlineInputBorder(),
      hintText: 'e.g., AMSTKGND',
      helperText: 'Enter amino acid sequence using single letter codes',
      prefixIcon: Icon(Icons.biotech),
    ),
      maxLines: 4,
      textCapitalization: TextCapitalization.characters,
    ),
      const SizedBox(height: 16),
      ElevatedButton.icon(
        onPressed: analyzeProperties,
        icon: const Icon(Icons.analytics),
        label: const Text('Analyze Properties'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      const SizedBox(height: 16),
      if (hydrophobicity.isNotEmpty)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Basic Properties',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              PropertyTile(
                icon: Icons.water_drop,
                property: 'Hydrophobicity',
                value: hydrophobicity,
              ),
              PropertyTile(
                icon: Icons.scale,
                property: 'Molecular Weight',
                value: molecularWeight,
              ),
              PropertyTile(
                icon: Icons.electric_bolt,
                property: 'Isoelectric Point',
                value: isoelectricPoint,
              ),
              PropertyTile(
                icon: Icons.change_circle,
                property: 'SNPs',
                value: snps,
              ),
              const SizedBox(height: 24),
              EnhancedMolecularCharts(
                sequence: _sequenceController.text.trim().toUpperCase(),
                transmembraneRegions: transmembraneRegions,
                disorderedRegions: disorderedRegions,
              ),
            ],
          ),
        ),
    ],
    ),
    ),
    ),
        ],
      ),
    );
  }
}

// Property Tile Widget for displaying individual properties
class PropertyTile extends StatelessWidget {
  final IconData icon;
  final String property;
  final String value;

  const PropertyTile({
    super.key,
    required this.icon,
    required this.property,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

