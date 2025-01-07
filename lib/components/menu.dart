import 'package:first_app/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/services/auth_service.dart';

class Menu extends StatelessWidget {
  final User user;
  const Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.manage_accounts_rounded,
                size: 48,
              ),
            ),
            accountName: Text(
              (user.displayName != null) ? user.displayName! : '',
            ),
            accountEmail: Text(user.email!),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              AuthService().deslogar();
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Editar conta"),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateScreen(),
                  ));
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Excluir conta"),
            onTap: () {
              _excluirContaBySenha(context);
            },
          ),
        ],
      ),
    );
  }
}

void _excluirContaBySenha(BuildContext context) {
  final TextEditingController senhaController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Excluir conta"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Digite sua senha:"),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              String senha = senhaController.text.trim();
              Navigator.of(context).pop();
              String? erro = await AuthService().excluirConta(senha: senha);

              if (erro != null) {
                final snackBar = SnackBar(
                  content: Text("Erro da xuxa: $erro"),
                  backgroundColor: Colors.red,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                const snackBar = SnackBar(
                  content: Text("Conta excluída com sucesso!"),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text("Excluir"),
          ),
        ],
      );
    },
  );
}
