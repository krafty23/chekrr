library my_prj.globals;

import 'package:mysql1/mysql1.dart';

bool isLoggedIn = false;
int uid = 0;
var fullname = '';
var foto_filename = '';
int SelectedState = 1;
var globalProtocol = 'https://';
var globalURL = 'chekrr.cz';
var dbSettings = new ConnectionSettings(
  host: 'chekrr.cz',
  port: 3306,
  user: 'krafty',
  password: 'kompucha',
  db: 'chekrr',
);
