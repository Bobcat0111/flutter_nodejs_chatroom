const { Client } = require('pg');
const pool = new Client({
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false
    }
  });

  pool.connect();

  async function checkHaveUsers(response){
    var sameNameUsers = await pool.query(
        "SELECT * FROM users WHERE username= $1",
        [response.username]
    ).catch(err => {
      console.log(err);
    });
    return sameNameUsers;
  }
  

  async function insertUser(response){
    const insertres = await pool.query(
        "INSERT INTO users (username, pass) VALUES ($1, $2) RETURNING *",
        [response.username, response.pass]
    ).catch(err => {
      console.log(err);
    });
    return insertres;
  }

  async function getAllUsers(fromUserId){
    var allUsers= await pool.query(
        "SELECT * FROM users WHERE id != $1",
        [fromUserId]
        ).catch(err => {
          console.log(err);
        });
        return allUsers;
  }

  async function checkUserPass(response){
    var users = await pool.query(
        "SELECT * FROM users WHERE username= $1 AND pass= $2",
        [response.username,response.pass]
        ).catch(err => {
          console.log(err);
        });
        return users;
  }

  async function insertmsg(from,to,content,types){
    const insertres = await pool.query(
        "INSERT INTO message (fromuserid,touserid,content,types,selfuser) VALUES ($1, $2, $3, $4,$5) RETURNING *",
        [from,to,content,types,false]
    ).catch(err => {
      console.log(err);
    });

    return insertres;
  }

  async function getAllMSG(){
      const allMSG=await pool.query(
        "SELECT * FROM message ",
        ).catch(err => {
          console.log(err);
        });
        return allMSG;
  }

  async function getMSGfromUserId(fromId){
    const msgs=await pool.query(
        "SELECT * FROM message WHERE fromUserId = $1",
        [fromId]
        ).catch(err => {
          console.log(err);
        });
        return msgs;
  }

  async function getMSGtoUserId(toId){
    const msgs=await pool.query(
        "SELECT * FROM message WHERE toUserId = $1",
        [toId]
        ).catch(err => {
          console.log(err);
        });
        return msgs;
  }

  async function getMSGfromOrtoUserId(fromId,toId){
    const msgs= await pool.query(
        "SELECT * FROM message WHERE fromUserId IN ($1,$2) AND toUserId IN ($1,$2) ",
        [fromId,toId]
        ).catch(err => {
          console.log(err);
        });
        return msgs;
  }

  module.exports={
      insertmsg,
      checkHaveUsers,
      insertUser,
      getAllUsers,
      checkUserPass,
      getAllMSG,
      getMSGfromUserId,
      getMSGtoUserId,
      getMSGfromOrtoUserId,
  }
