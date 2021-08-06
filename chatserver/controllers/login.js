const sql=require('../db/sql');
const vertoken=require('../token/tokens')
exports.login=async(req,res)=>{
    console.log('login.....');
    try {
        var response = {
            "username": req.body.username,
            "pass": req.body.pass
        }
        console.log(`login request body=${response}`);
        if (response === null || response.username === null || response.pass === null || response.username === "" || response.pass === "") {
            console.log('empty username and password');
            return res.status(200).json({
                data:null,
                msg:'Username and password required'
            });
        }

        var user=await sql.checkUserPass(response);
        if (user.rows.length === 0) {

            var userSerchResult=await sql.checkHaveUsers(response);
            if(userSerchResult.rows.length===0){
                console.log('user no');
                res.status(200).json({
                    data:null,
                    msg:'This user dose not exist!'
                }); 
            }else {
                if(response.username===userSerchResult.rows[0].username && response.pass!==userSerchResult.rows[0].pass){
                    console.log('pass err');
                    res.status(200).json({
                        data:null,
                        msg:'Password error!'
                    }); 
                }else if(response.username===userSerchResult.rows[0].username && response.pass===userSerchResult.rows[0].pass){
                    console.log('login err');
                    res.status(200).json({
                        data:null,
                        msg:'Login error!'
                    }); 
                }
            }
        }else{
            console.log('login succe');

            console.log(user.rows)
            vertoken.setToken(user.rows[0].username,user.rows[0].id).then(token=>{
                res.status(200).json({
                    data:{
                        token:token,
                        userId:user.rows[0].id,
                        userName:user.rows[0].username,
                    },
                    msg:'Login successfully!'
                });
            })    
        }
    } catch (err) {
        console.error(err.message);
    }
};