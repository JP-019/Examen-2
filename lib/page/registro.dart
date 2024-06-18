import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/services/usuarios.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Ingresa un email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Contraseña'),
                obscureText: true,
                validator: (val) => val!.length < 6
                    ? 'Ingresa una contraseña de 6+ caracteres'
                    : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Registrar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email, password);
                    if (result == null) {
                      setState(
                          () => error = 'Por favor ingresa un email válido');
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              TextButton(
                child: Text('¿Ya tienes cuenta? Inicia sesión aquí'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
