import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/services/recetas.dart';

class UsuarioScreen extends StatefulWidget {
  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  final ServiciosRecetas _serviciosRecetas = ServiciosRecetas();
  final _formKey = GlobalKey<FormState>();
  String titulo = '';
  String descripcion = '';
  bool importante = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Título'),
                    validator: (val) =>
                        val!.isEmpty ? 'Ingrese un título' : null,
                    onChanged: (val) {
                      setState(() => titulo = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descripción'),
                    validator: (val) =>
                        val!.isEmpty ? 'Ingrese una descripción' : null,
                    onChanged: (val) {
                      setState(() => descripcion = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _serviciosRecetas.addReceta(
                            titulo, descripcion, importante);
                        _formKey.currentState!.reset();
                        setState(() {
                          titulo = '';
                          descripcion = '';
                          importante = false;
                        });
                      }
                    },
                    child: Text('Agregar Receta'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _serviciosRecetas.getRecetasStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final data = snapshot.requireData;

                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    var receta = data.docs[index];

                    return ListTile(
                      title: Text(receta['titulo']),
                      subtitle: Text(receta['descripcion']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _serviciosRecetas.deleteReceta(receta.id);
                        },
                      ),
                      onTap: () async {
                        // Mostrar un cuadro de diálogo para actualizar la receta
                        await showDialog(
                          context: context,
                          builder: (context) {
                            String newTitulo = receta['titulo'];
                            String newDescripcion = receta['descripcion'];
                            return AlertDialog(
                              title: Text('Actualizar Receta'),
                              content: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      initialValue: newTitulo,
                                      decoration:
                                          InputDecoration(labelText: 'Título'),
                                      onChanged: (val) {
                                        newTitulo = val;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: newDescripcion,
                                      decoration: InputDecoration(
                                          labelText: 'Descripción'),
                                      onChanged: (val) {
                                        newDescripcion = val;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Guardar'),
                                  onPressed: () async {
                                    await _serviciosRecetas.updateReceta(
                                        receta.id, newDescripcion, newTitulo);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
