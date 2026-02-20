import 'package:flutter/material.dart';

import '../../Models/enum_MenuItem.dart';
import '../../helprs/Cores.dart';
import '../tela_antiga/tela_prospectar.dart';
import '../tela_empresas.dart';
import '../tela_socio.dart';
import '../tela_pesquisa.dart';

class SideBarWidget extends StatelessWidget {
  final MenuItem selectedItem;
  final Function(MenuItem item) onItemSelected;

  const SideBarWidget({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: const Color(0xFF123C3C),
      child: Column(
        children: [
          const SizedBox(height: 30),

          const Text(
            "conciliadora",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 30),
          const Divider(color: Colors.white24),

          _menuItem(
            context: context,
            icon: Icons.home_outlined,
            title: "Pesquisa",
            item: MenuItem.pesquisa,
            page:  TelaPesquisa(),
          ),

          _menuItem(
            context: context,
            icon: Icons.group_outlined,
            title: "Sócios",
            item: MenuItem.socios,
            page:  TelaSocio(),
          ),

          _menuItem(
            context: context,
            icon: Icons.apartment_outlined,
            title: "Empresas",
            item: MenuItem.empresas,
            page: const TelaEmpresas(),
          ),

          _menuItem(
            context: context,
            icon: Icons.work,
            title: "Legado Empresas",
            item: MenuItem.legado, // 🔥 IMPORTANTE: enum diferente
            page: const TelaProspectar(),
          ),

          const Spacer(),

          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              "v1.0 · Conciliadora",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required MenuItem item,
    required Widget page,
  }) {
    final bool isSelected = selectedItem == item;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (!isSelected) {
            onItemSelected(item);

            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration:
                const Duration(milliseconds: 250),
                pageBuilder: (_, animation, __) => FadeTransition(
                  opacity: animation,
                  child: page,
                ),
              ),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? Cores.verde_claro
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : Colors.white70,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}