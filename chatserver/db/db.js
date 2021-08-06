const { Client }=require("pg");

const pool = new Client({
    user: "username",
    password: "password",
    database: "yanhongzhao",
    host: "localhost",
    port: 5432
});

module.exports = { pool };