import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _primary = Color(0xFF1A2F5A);
const Color _accent = Color(0xFFF5A623);
const Color _danger = Color(0xFFE53935);
const Color _bgStart = Color(0xFF0D1B3E);
const Color _bgEnd = Color(0xFF1E3A5F);
const Color _cardBg = Color(0xFFFFFFFF);

class CalculSolar extends StatefulWidget {
  const CalculSolar({super.key});

  @override
  State<CalculSolar> createState() => _CalculSolarState();
}

class _CalculSolarState extends State<CalculSolar>
    with SingleTickerProviderStateMixin {
  double tempscharge = 0;
  double temps_autonomie = 0;
  bool EstSurcharge = false;
  bool _hasCalculated = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final puissance_controller = TextEditingController();
  final Amperage_controller = TextEditingController();
  final capacite_controller = TextEditingController();
  final sortie_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    puissance_controller.dispose();
    Amperage_controller.dispose();
    capacite_controller.dispose();
    sortie_controller.dispose();
    super.dispose();
  }

  void _calculate() {
    final puissance = double.tryParse(puissance_controller.text);
    final amperage = double.tryParse(Amperage_controller.text);
    final capacite = double.tryParse(capacite_controller.text);
    final puissancesortie = double.tryParse(sortie_controller.text);

    if (puissance == null ||
        amperage == null ||
        capacite == null ||
        puissancesortie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                "Saisissez les valeurs en chiffres",
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: _danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() {
      EstSurcharge = (puissance / 12) > amperage;
      if (!EstSurcharge) {
        tempscharge = (capacite * 12) / puissance;
        temps_autonomie = (capacite * 12) / puissancesortie;
      } else {
        tempscharge = 0;
        temps_autonomie = 0;
      }
      _hasCalculated = true;
    });
    _animController.forward(from: 0);
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    bool isError = false,
  }) {
    final borderColor = isError ? _danger : _primary.withOpacity(0.3);
    final focusBorderColor = isError ? _danger : _accent;
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        color: isError ? _danger : Colors.grey[600],
      ),
      prefixIcon: Icon(icon, color: isError ? _danger : _primary, size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusBorderColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgStart,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_bgStart, _bgEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // En-tête
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _accent.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.wb_sunny_rounded,
                          color: _accent,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "CalcSol",
                        style: GoogleFonts.kavoon(
                          color: Colors.white,
                          fontSize: 28,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Calculatrice de système solaire",
                        style: GoogleFonts.inter(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Carte principale
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Paramètres du système",
                            style: GoogleFonts.inter(
                              color: _primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Renseignez les données de votre installation",
                            style: GoogleFonts.inter(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Champ de la puissance de panneau
                          TextField(
                            controller: puissance_controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                            ],
                            decoration: _fieldDecoration(
                              label: "Puissance du panneau solaire (W)",
                              icon: Icons.solar_power_rounded,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Champ de l'ampérage
                          TextField(
                            controller: Amperage_controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                            ],
                            decoration: _fieldDecoration(
                              label: "Ampérage du contrôleur (A)",
                              icon: Icons.electrical_services_rounded,
                              isError: EstSurcharge,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Champ de la capacité de la batterie
                          TextField(
                            controller: capacite_controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                            ],
                            decoration: _fieldDecoration(
                              label: "Capacité de la batterie (Ah)",
                              icon: Icons.battery_charging_full_rounded,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Champ de la puissance de sortie
                          TextField(
                            controller: sortie_controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                            ],
                            decoration: _fieldDecoration(
                              label: "Puissance de sortie (W)",
                              icon: Icons.power_rounded,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Bouton Calculer
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _calculate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: _primary.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calculate_rounded, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Calculer",
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Section résultats
                          if (_hasCalculated) ...[
                            const SizedBox(height: 32),
                            FadeTransition(
                              opacity: _fadeAnim,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.analytics_rounded,
                                        color: _primary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Résultats",
                                        style: GoogleFonts.inter(
                                          color: _primary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  if (EstSurcharge)
                                    _AlertCard()
                                  else
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _ResultCard(
                                            label: "Temps de charge",
                                            value: _formatHours(tempscharge),
                                            icon: Icons.bolt_rounded,
                                            color: _primary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _ResultCard(
                                            label: "Autonomie",
                                            value: _formatHours(
                                              temps_autonomie,
                                            ),
                                            icon: Icons.access_time_rounded,
                                            color: const Color(0xFF1B6CA8),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatHours(double h) {
    if (h <= 0) return "0 h";
    final hInt = h.floor();
    final min = ((h - hInt) * 60).round();
    if (min == 0) return "$hInt h";
    return "$hInt h $min min";
  }
}

class _ResultCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ResultCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _danger.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _danger.withOpacity(0.3), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _danger.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: _danger,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Surcharge détectée",
                  style: GoogleFonts.inter(
                    color: _danger,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Le courant du panneau dépasse l'ampérage du contrôleur. Augmentez la capacité du contrôleur.",
                  style: GoogleFonts.inter(
                    color: Colors.grey[700],
                    fontSize: 12,
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
