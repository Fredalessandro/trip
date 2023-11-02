import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../component/mask.dart';
import '../component/navigation_bar.dart';
import '../model/sign_up_model.dart';
import '../model/user_model.dart';
import '../service/user_service.dart';





class SignUpPage extends StatefulWidget {
  final http.Client? httpClient;

  const SignUpPage({
    this.httpClient,
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  Mask maskPhone = Mask(
      formatter: MaskTextInputFormatter(mask: "(##)#####-####"),
      hint: '',
      textInputType: TextInputType.phone);
  Mask maskNome = Mask(
      formatter: MaskTextInputFormatter(
          mask: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"),
      hint: '',
      textInputType: TextInputType.name);
  Mask maskMatricula = Mask(
      formatter: MaskTextInputFormatter(mask: "#####"),
      hint: '',
      textInputType: TextInputType.number);



  SignUp signUp = SignUp();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  
  User? user;
  String nome = "";

  @override
  void initState() {
    // TODO: implement initState

      UserService.get().then((value) {
        setState(() {
          user = value;
          maskMatricula.textController.text = user!.matricula!;
          maskNome.textController.text      = user!.nome==null?"":user!.nome!;
          maskPhone.textController.text      = user!.phone!;
        });
        
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadatro do Usuário'),
      ),
      body: Form(
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
            ),
        child: Padding(
      padding: EdgeInsets.all(8.0), child: Column(
              children: [
                ...[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    inputFormatters: [maskMatricula.formatter],
                    controller: maskMatricula.textController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Informe a matricula',
                      labelText: 'Matricula',
                    ),
                    validator: (String? value) {
                      if (value == "") {
                        return 'Informe a matricula';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      signUp.matricula = value;
                    },
                  ),
                  TextFormField(
                    autofocus: true,
                    inputFormatters: [maskNome.formatter],
                    controller: maskNome.textController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Informe o nome completo',
                      labelText: 'Nome',
                    ),
                    validator: (String? value) {
                      if (value == "") {
                        return 'Informe o nome';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      signUp.nome = value;
                    },
                  ),
                  TextFormField(
                    autofocus: true,
                    inputFormatters: [maskPhone.formatter],
                    controller: maskPhone.textController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Informe o telefone',
                      labelText: 'Telefone',
                    ),
                    validator: (String? value) {
                      if (value == "") {
                        return 'Informe o telefone';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      signUp.phone = value;
                    },
                  ),
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Informe a senha',
                      labelText: 'Senha',
                    ),
                    validator: (String? value) {
                      if (value == "") {
                        return 'Informe o senha';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      signUp.password = value;
                    },
                  ),
                  TextFormField(
                    maxLength: 6,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Confirme a senha',
                    ),
                    obscureText: true,
                    validator: (String? value) {
                      if (value == "") {
                        return 'Confirme a senha';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      signUp.confirmPassword = value;
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           SizedBox(
                        width: 100,
                        child: ElevatedButton(
                              child: const Text('Gravar'),
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  User user = User(matricula: maskMatricula.textController.text,
                                                  nome: maskNome.textController.text,
                                                  phone: maskPhone.textController.text,
                                                  password: signUp.password);
                                  await UserService.save(user);
                                  Navigator.pop(this.context); 
                                  return;
                                } else {
                                  print("UnSuccessfull");
                                }
                              }
                              
                            )),
                           SizedBox(width: 20),
                           SizedBox(
                        width: 100,
                        child: ElevatedButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.pop(this.context); 
                              },
                            )
             ) ])),
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
      ))),
      
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
