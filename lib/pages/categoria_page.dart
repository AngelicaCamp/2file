import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_file/databases/documentoDbHelper.dart';
import 'package:to_file/models/categoria.dart';
import 'package:to_file/pages/imagemViewPage.dart';

import '../models/documento.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({required this.categoria});

  final Categoria categoria;

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  final DocumentoDbHelper _documentoDbHelper = DocumentoDbHelper();
  // final ImagemViewPage imagemViewPage = const ImagemViewPage();
  int? seletctedId;
  String nomeCategoria = '';

  @override
  void initState() {
    super.initState();
    atualizarNomeCategoria();
  }

  atualizarNomeCategoria() {
    setState(() {
      nomeCategoria = widget.categoria.nome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C322C),
        title: Text(nomeCategoria),
      ),
      body: Center(
        child: FutureBuilder<List<Documento>>(
          future: _documentoDbHelper
              .listDocumentosByCategoriaId(widget.categoria.id!),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Documento>> snapshot,
          ) {
            return snapshot.data != null && snapshot.data!.isEmpty
                ? const Center(
                    child: Text(
                      'Lista de documentos vazia',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView(
                    children: snapshot.data!.map((document) {
                      return Center(
                        child: Card(
                          color: const Color(0xffDEF1EB),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                leading: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ImagemViewPage(documento: document),
                                    ),
                                  ),
                                  child: Image.asset(
                                      'assets/images/icon_doc.png',
                                      height: 60),
                                ),
                                title: Text(
                                  document.nome!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      const TextSpan(
                                        text: 'Competência: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${DateFormat(DateFormat.YEAR_MONTH, 'pt-Br').format(document.dataCompetencia!)}.',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const TextSpan(
                                          text: '\nValidade: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      TextSpan(
                                        text:
                                            ' ${DateFormat('dd/MM/yyyy').format(document.dataValidade!)}.',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const TextSpan(
                                          text: '\nCriado em: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      TextSpan(
                                        text:
                                            ' ${DateFormat('dd/MM/yyyy KK:mm').format(document.criadoEm!)}',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ]),
                                  ),
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem<_ValueDialog>(
                                      value: _ValueDialog.editar,
                                      child: Text("Editar"),
                                    ),
                                    const PopupMenuItem(
                                      value: _ValueDialog.excluir,
                                      child: Text('Excluir'),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    switch (value) {
                                      case _ValueDialog.editar:
                                        //chamar cadastrarDocumento passando o documento
                                        break;
                                      case _ValueDialog.excluir:
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            elevation: 5.0,
                                            title: Text(
                                                "Deseja excluir ${document.nome} definitivamente?"),
                                            actions: [
                                              MaterialButton(
                                                child: const Text("Sim"),
                                                onPressed: () {
                                                  setState(() {
                                                    _documentoDbHelper
                                                        .removeDocumento(
                                                            document.id!);
                                                  });

                                                  Navigator.pop(context);
                                                },
                                              ),
                                              MaterialButton(
                                                child: const Text('Não'),
                                                onPressed: () {},
                                              )
                                            ],
                                          ),
                                        );
                                        break;
                                    }
                                  },
                                ),
                                isThreeLine: false,
                                onTap: () {
                                  //chamar função para abrir view documento
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
          },
        ),
      ),
    );
  }
}

enum _ValueDialog {
  editar,
  excluir,
}
