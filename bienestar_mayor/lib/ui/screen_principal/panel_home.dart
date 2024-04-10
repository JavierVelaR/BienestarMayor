import 'package:flutter/cupertino.dart';

class PanelHome extends StatelessWidget {
  const PanelHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Gestiona y monitoriza\nfácilmente tus instalaciones"),
            const SizedBox(height: 10),
            // Row(),
            // const SizedBox(height: CONF_SPACE_AFTER_TITLE_SMALL),
            Text("Configura y/o añade tus\ndispositivos",),
            const SizedBox(height: 10),
            // _panelConfig(context),
            // const SizedBox(height: 12),
            // Row(
            //   children: [
            //     Expanded(
            //         child: CardHome(
            //           "Añadir Enersim",
            //           Assets.homeHomeAddEnersim,
            //           onTap: () => configureNewDevice(DeviceFamily.enersim),
            //         )),
            //     const SizedBox(width: 12),
            //     Expanded(
            //         child: CardHome(
            //           "Disp. no vinculados",
            //           Assets.homeHomeDevicesNotLinked,
            //           onTap: showDevicesNotLinked,
            //         )),
            //   ],
            // ),
            // const SizedBox(height: CONF_SPACE_AFTER_TITLE_SMALL),
            // Text("IP-Meter", style: Theme.of(context).textTheme.titleLarge),
            // const SizedBox(height: CONF_SPACE_AFTER_TITLE_SMALL),
            // Row(
            //   children: [
            //     Expanded(
            //         child: CardHome("Dispositivos", Assets.homeHomeIpmeter, onTap: () => _actionShowIPMeters(context))),
            //     const SizedBox(width: 12),
            //     Expanded(
            //         child: CardHome("Instalaciones", Assets.homeHomeInstallations,
            //             onTap: () => _actionShowInstallations(context))),
            //   ],
            // ),
          ],
        ));
  }
}
