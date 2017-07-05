var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');

oracledb.getConnection(
  {
    user          : dbConfig.user,
    password      : dbConfig.password,
    connectString : dbConfig.connectString
  },
  function (err, connection)
  {
    if (err) { console.error(err.message); return; }

    var bindvars = {
      P_EMP_ID: 101,
      P_START_DATE: new Date("2007-07-25"),
      P_END_DATE: new Date("2008-07-24"),
      P_JOB_ID: 'SA_REP',
      P_DEPARTMENT_ID: 60
    };
    connection.execute(
      "BEGIN ADD_JOB_HISTORY(:P_EMP_ID, :P_START_DATE, :P_END_DATE, :P_JOB_ID, :P_DEPARTMENT_ID); END;",
      bindvars,
      function (err, result)
      {
        if (err) {
          console.error(err.message);
          doRelease(connection);
          return;
        }
        console.log(result.outBinds);
        doRelease(connection);
      });
  });

function doRelease(connection)
{
  connection.close(
    function(err) {
      if (err) {
        console.error(err.message);
      }
    });
}