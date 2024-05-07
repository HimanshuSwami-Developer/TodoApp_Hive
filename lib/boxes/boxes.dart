import 'package:aesthticapp/model/modals.dart';
import 'package:hive/hive.dart';


class Boxes{

  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
 
 }