import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_file/models/categoria.dart';
import 'package:path_provider/path_provider.dart';

import '../models/documento.dart';
import '../models/notificacoes.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // print(documentsDirectory.path);
    // String path = documentsDirectory.path + '/' + 'twofile.db';

    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'twoFile.db');

    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(documentos);
    await db.execute(categoria);
    await db.execute(notificacoes);
    await _populateDefaultCategoria(db);
  }

  Future _populateDefaultCategoria(Database db) async {
    List<dynamic> categorias = [
      Categoria(
          nome: 'Recibo', nomeIcone: 'recibo.png', criadoEm: DateTime.now()),
      Categoria(
          nome: 'Fatura', nomeIcone: 'fatura.png', criadoEm: DateTime.now()),
      Categoria(
          nome: 'Extrato Bancário',
          nomeIcone: 'extrato-bancario.png',
          criadoEm: DateTime.now()),
      Categoria(
          nome: 'Nota Fiscal',
          nomeIcone: 'notaFiscal.png',
          criadoEm: DateTime.now()),
      Categoria(
          nome: 'Contrato',
          nomeIcone: 'contrato.png',
          criadoEm: DateTime.now()),
      Categoria(
          nome: 'Boleto', nomeIcone: 'boleto.png', criadoEm: DateTime.now()),
      Categoria(
          nome: 'Pessoal', nomeIcone: 'pessoal.png', criadoEm: DateTime.now())
    ];

    for (var categoria in categorias) {
      await db.rawInsert('''
        INSERT INTO categorias (nome,nomeIcone,criadoEm)
        VALUES (?, ?, ?)''', [
        categoria.nome,
        categoria.nomeIcone,
        categoria.criadoEm.toIso8601String()
      ]);
    }
  }

  String documentos = '''
    CREATE TABLE documentos(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome VARCHAR(255) NOT NULL, 
      dataCompetencia DATE NULL,
      dataValidade DATE NULL,
      criadoEm DATE NULL,
      categoria_id INT NOT NULL, 
      FOREIGN KEY (categoria_id) REFERENCES categorias (id)
    )''';

  String notificacoes = '''
    CREATE TABLE notificacoes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      criadoEm DateTime
    )''';

  String categoria = '''
    CREATE TABLE categorias(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      nomeIcone TEXT,
      criadoEm DateTime
    )
    ''';

  //Return Lista de documentos por id categoria
  Future<List<Documento>> listDocumentosByCategoriaId(int id) async {
    Database db = await instance.database;
    var documentos = await db.query('documentos',
        orderBy: 'nome', where: 'categoria_id = ?', whereArgs: [id]);
    List<Documento> documentosList = documentos.isNotEmpty
        ? documentos.map((document) => Documento.fromMap(document)).toList()
        : [];
    return documentosList;
  }

  //lista de documentos
  Future<List<Documento>> listDocumentos() async {
    Database db = await instance.database;
    var documentos = await db.query(
      'documentos',
      orderBy: 'nome',
    );
    List<Documento> documentosList = documentos.isNotEmpty
        ? documentos.map((document) => Documento.fromMap(document)).toList()
        : [];
    return documentosList;
  }

  //adicionar Documento
  Future<int> addDocumento(Documento documento) async {
    Database db = await instance.database;
    return await db.insert('documentos', documento.toMap());
  }

  //remover documento
  Future<int> removeDocumento(int id) async {
    Database db = await instance.database;
    return await db.delete('documentos', where: 'id = ?', whereArgs: [id]);
  }

  //editar documento
  Future<int> updateDocumento(Documento documento) async {
    Database db = await instance.database;
    return await db.update('documentos', documento.toMap(),
        where: 'id = ?', whereArgs: [documento.id]);
  }

  // ============CATEGORIA ==============================================
  Future<List<Categoria>> getCategoriaById(int id) async {
    Database db = await instance.database;
    var categorias =
        await db.query('categorias', where: 'id = ?', whereArgs: [id]);
    //alterar o orderby para id_categoria
    List<Categoria> categoriaList = categorias.isNotEmpty
        ? categorias.map((e) => Categoria.fromMap(e)).toList()
        : [];
    return categoriaList;
  }

  //retorna uma categoria específica.
  Future<Categoria> getCategoria(int id) async {
    Database db = await instance.database;
    Categoria? cat;
    var categorias =
        await db.query('categorias', where: 'id = ?', whereArgs: [id]);
    //alterar o orderby para id_categoria
    List<Categoria> categoriaList = categorias.isNotEmpty
        ? categorias.map((e) => Categoria.fromMap(e)).toList()
        : [];
    for (Categoria c in categoriaList) {
      cat = c;
    }
    return cat!;
  }

  // Retorna todas as categorias
  Future<List<Categoria>> todasCategorias() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> allRows = await db.query('categorias');
    List<Categoria> categorias =
        allRows.map((categoria) => Categoria.fromMap(categoria)).toList();
    return categorias;
  }

  //Return Lista de dcategorias
  Future<List<Categoria>> listCategoriaById() async {
    Database db = await instance.database;
    var categorias = await db.query('categorias', orderBy: 'id');
    List<Categoria> categoriaList = categorias.isNotEmpty
        ? categorias.map((e) => Categoria.fromMap(e)).toList()
        : [];
    return categoriaList;
  }

  //adicionar Categoria
  Future<int> addCategoria(Categoria categoria) async {
    Database db = await instance.database;
    return await db.insert('categorias', categoria.toMap());
  }

  //remover categoria
  Future<int> removeCategoria(int id) async {
    Database db = await instance.database;
    return await db.delete('categorias', where: 'id = ?', whereArgs: [id]);
  }

  //editar categoria
  Future<int> updateCategoria(Categoria categoria) async {
    Database db = await instance.database;
    return await db.update('categorias', categoria.toMap(),
        where: 'id = ?', whereArgs: [categoria.id]);
  }

  // ============NOTIFICAÇÕES ==============================================

  //Get notificação por id
  Future<List<Notificacao>> getNotificacaoById(int id_documento) async {
    Database db = await instance.database;
    var notificacoes = await db.query('notificacoes',
        where: 'id_documento = ?', whereArgs: [id_documento]);
    //alterar o orderby para id_categoria
    List<Notificacao> notificacaoList = notificacoes.isNotEmpty
        ? notificacoes.map((e) => Notificacao.fromMap(e)).toList()
        : [];
    return notificacaoList;
  }

  //Lista de notificacoes
  Future<List<Notificacao>> listaNotificaoes() async {
    Database db = await instance.database;
    var notificacoes = await db.query('notificacoes', orderBy: 'id');
    List<Notificacao> notificacoesList = notificacoes.isNotEmpty
        ? notificacoes.map((e) => Notificacao.fromMap(e)).toList()
        : [];
    return notificacoesList;
  }

  //adicionar notificacao
  Future<int> addNotificacao(Notificacao notificacao) async {
    Database db = await instance.database;
    return await db.insert('notificacoes', notificacao.toMap());
  }

  //remover notificacao
  Future<int> removeNotificacao(int id) async {
    Database db = await instance.database;
    return await db.delete('notificacoes', where: 'id = ?', whereArgs: [id]);
  }
}
