import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../service/user_service.dart';
import '../component/mask.dart';
import '../model/user_model.dart';


part 'sign_in_http.g.dart';

@JsonSerializable()
class FormSignIn {
  String? matricula;
  String? nome;
  String? password;

  FormSignIn({
    this.matricula,
    this.nome,
    this.password,
  });

  factory FormSignIn.fromJson(Map<String, dynamic> json) =>
      _$FormSignInFromJson(json);

  Map<String, dynamic> toJson() => _$FormSignInToJson(this);
}

class SignIn extends StatefulWidget {
  
  const SignIn({
    super.key
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  Mask mask = Mask(formatter: MaskTextInputFormatter(mask: "#####"), hint: '', textInputType: TextInputType.phone);
  
  FormSignIn formData = FormSignIn();
  
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  
  User? user;
  String nome = "";

  @override
  void initState() {
    // TODO: implement initState

      UserService.get().then((value) {
        setState(() {
          user = value;
          if (user!=null) {
            nome = user!.nome??"";
            mask.textController.text = user!.matricula!;
          }

        });
        
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login do Usuário'),
      ),
      body:  Form(
        key: _formkey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
             child:Card(
        color: Colors.blue[100] ,
        elevation: 20,
        shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),child: Column(
              children: [
                ...[ 
                  user!=null?  Text(nome) : Text(''),
                  TextFormField(
                    autofocus: true,
                    inputFormatters: [mask.formatter],
                    controller: mask.textController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Informe a matricula',
                      labelText: 'Matricula'
                    ),
                    onChanged: (value) {
                      formData.matricula = value;
                    },
                  ),
                  TextFormField(
                    maxLength: 6,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Senha',
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      formData.password = value;
                    },
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                   SizedBox(
                        width: 100,child: ElevatedButton(
                      child: const Text('Entra'),
                      onPressed: () {
                        user?.connected = true;
                        UserService.save(user!);
                        context.go('/');
                      },
                    )),
                    SizedBox(width: 20),
                   SizedBox(
                        width: 100,child:  ElevatedButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        context.go('/');
                      },
                    )
            )]),
                ].expand(
                  (widget) => [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
