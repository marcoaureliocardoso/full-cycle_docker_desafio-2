const express = require("express");
const fs = require("fs");
const mysql = require("mysql2");

const app = express();
const port = 3000;

const dbconfig = {
  host: "mysql",
  user: "",
  password: "",
  database: "desafio2db",
};

try {
  dbconfig.user = fs.readFileSync("/run/secrets/mysql_user", "utf8");
  dbconfig.password = fs.readFileSync("/run/secrets/mysql_password", "utf8");
} catch (err) {
  console.error("Error reading secret files:", err);
  process.exit(1); // Exit the application in case of an error
}

const connection = mysql.createConnection(dbconfig);

const table_exists_query = `
  SELECT COUNT(*) table_exists 
    FROM information_schema.TABLES 
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_TYPE = 'BASE TABLE'
     AND TABLE_NAME = ?;`;

// The callback function to handle selecting data
function selectData(res) {
  const select_people_query = `SELECT * FROM people`;
  connection.query(select_people_query, (error, results) => {
    if (error) throw error;

    // console.log(results);

    let html = "<h1>Full Cycle Rocks!</h1><ul>";
    results.forEach((result) => {
      html += `<li>${result.name}</li>`;
    });
    html += "</ul>";

    res.send(html);
  });
}

// Check if the table exists and then proceed with insert/select operations
connection.query(table_exists_query, ["people"], (error, results) => {
  if (error) throw error;
  if (results[0].table_exists == 0) {
    const create_table_query = `
      CREATE TABLE people (
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        PRIMARY KEY (id)
      );`;
    connection.query(create_table_query, (error) => {
      if (error) throw error;
      console.log("Table created");
    });
  }

  // Insert the person after table creation or if the table already exists
  const insert_people_query = `INSERT INTO people(name) values('Marco Aurélio Cardoso')`;
  connection.query(insert_people_query, (error) => {
    if (error) throw error;
    console.log("Data inserted");
  });
});

app.get("/", (req, res) => {
  // When the user accesses the root path ("/"), call selectData with the response object.
  selectData(res);
});

app.listen(port, () => console.log(`Listening on port ${port}!`));
