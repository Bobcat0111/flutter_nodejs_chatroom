const sql=require('../db/sql');

exports.register=async(req,res)=>{
    console.log('register.....');
    try {

        var response = {
            "username": req.body.username,
            "pass": req.body.pass
        }

        if (response == null || response.username == null || response.pass == null || response.username == "" || response.pass == "") {
            return res.status(200).json({
                data:null,
                msg:'Username and password required'
            });
        }

        var sameNameUsers= await sql.checkHaveUsers(response);

        if (sameNameUsers.rows.length == 0) {
            const insertres=await sql.insertUser(response);

            res.status(200).json({
                data:insertres.rows,
                msg:'Register successfully!'
            });
        }else{
            res.status(200).json({
                data:null,
                msg:'Failed to register: user has already exist'
            });
        }
    } catch (err) {
        console.error(err.message);
    }

};