const sql=require('../db/sql');
exports.getChatList=async(req,res)=>{
    console.log('chat list.....');
    var fromUserId=req.data['user_id'];
    var allUsers=await sql.getAllUsers(fromUserId);
    return res.status(200).json({
        code:1,
        msg:"get friends list",
        data:allUsers.rows,
    });
   
};