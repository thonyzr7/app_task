import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/view/components/H1.dart';
import 'package:flutter_application_1/app/view/components/shape.dart';
import 'package:flutter_application_1/app/view/task_list/task_list_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Row(
          children: [
            const Shape(),
          ],
        ),
        const SizedBox(height: 79),
        Image.asset('assets/images/onboarding-image.png',
            width: 180, height: 168),
        const SizedBox(height: 99),
        const H1('LISTA DE TAREAS', color: Colors.blue), //WIDGET CREADO
        const SizedBox(height: 21),
        GestureDetector(
          //funcion par hacer click y me pase a la siguiente widget
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const TaskListPage();
          })),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
                'La mejor forma para que no se te olvide nada es anotarlo. Guardar tus tareas y ve completando poco a poco para aumentar tu productividad',
                textAlign: TextAlign.center),
          ),
        ),
      ]),
    );
  }
}
