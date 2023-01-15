library my_prj.globals;

bool isLoggedIn = false;
var dbSettings = new ConnectionSettings(
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'kompucha',
  db: 'kralovskamedialni',
);
