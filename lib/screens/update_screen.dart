import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen>{

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();

  final AuthService authService = AuthService();

  @override
  void initState(){
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      _nomeController.text = user.displayName ?? '';
      _emailController.text = user.email ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Usuário")),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.manage_accounts_rounded,
                    size: 100,
                  ),
                ),
                accountName: null,
                accountEmail: null,
              ),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "E-mail"),
              ),
              TextField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: "Senha"),
                obscureText: true,
              ),
              TextField(
                controller: _confirmaSenhaController,
                decoration: const InputDecoration(labelText: "Confirmar senha"),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_senhaController.text == _confirmaSenhaController.text) {
                    authService
                        .editarUsuario(
                      email: _emailController.text,
                      senha: _senhaController.text,
                      nome: _nomeController.text,
                    )
                        .then((String? erro) {
                      if (erro != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(erro),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Usuário atualizado com sucesso!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: const Text("Salvar Alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


