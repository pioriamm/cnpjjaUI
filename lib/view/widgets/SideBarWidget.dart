import 'package:flutter/material.dart';
import 'package:proj_flutter/model/enum_MenuItem.dart';
import '../../helprs/Cores.dart';
import '../tela_empresas.dart';
import '../tela_empresasCadastro.dart';
import '../tela_socio.dart';
import '../tela_pesquisa.dart';
import '../tela_socioCadastro.dart';

class SideBarWidget extends StatefulWidget {
  final MenuItem selectedItem;
  final Function(MenuItem item) onItemSelected;

  SideBarWidget({super.key, required this.selectedItem, required this.onItemSelected});

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: Cores.verde_escuro,
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            "conciliadora",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, letterSpacing: 1),
          ),

          const SizedBox(height: 30),
          const Divider(color: Colors.white24),

          _menuItem(
            context: context,
            icon: Icons.home_outlined,
            title: "Pesquisa",
            item: MenuItem.pesquisa,
            page: TelaPesquisa(),
          ),

          _menuItem(
            context: context,
            icon: Icons.group_outlined,
            title: "Sócios",
            item: MenuItem.socios,
            page: TelaSocio(),
          ),

          _menuItem(
            context: context,
            icon: Icons.apartment_outlined,
            title: "Empresas",
            item: MenuItem.empresas,
            page: const TelaEmpresas(),
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.white24),
          const SizedBox(height: 30),
          _menuItem(
            context: context,
            icon: Icons.edit_outlined,
            title: "Cadastro Sócios",
            item: MenuItem.sociosCadastro,
            page: TelaSocioCadastro(),
          ),

          _menuItem(
            context: context,
            icon: Icons.edit_outlined,
            title: "Cadastro Empresas",
            item: MenuItem.empresasCadastro,
            page: const TelaEmpresasCadastro(),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text("v1.0 · Conciliadora", style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  MenuItem? _hoveredItem;

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required MenuItem item,
    required Widget page,
  }) {
    final bool isSelected = widget.selectedItem == item;
    final bool isHovered = _hoveredItem == item;

    Color backgroundColor() {
      if (isSelected) return Cores.verde_claro;
      if (isHovered) return Colors.white.withOpacity(0.5);
      return Colors.transparent;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredItem = item),
        onExit: (_) => setState(() => _hoveredItem = null),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (!isSelected) {
              widget.onItemSelected(item);

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: page),
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(color: backgroundColor(), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.white70),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
