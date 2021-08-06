const sql=require('../db/sql');
exports.getMessage=async(req,res)=>{
    console.log('message.....');
    var fromId=req.query['fromId']; 
    var toId=req.query['toId'];
    var messageList=[];

    if(fromId==null && toId ==null){
        const allMSG=await sql.getAllMSG();
        var data=allMSG.rows;
        data.forEach(row=>{
            if(row.fromUserId==fromId){
                row.selfUser=true;
            }else{
                row.selfUser=false;
            }
            messageList.push(row);
        })
        res.status(200).json({
            code:1,
            data:messageList,
            msg:'get message!'
        }); 
    }else if(fromId!=null && toId==null){
        const msgs=await sql.getMSGfromUserId(fromId);
        var data=msgs.rows;
        data.forEach(row=>{
            if(row.fromUserId==fromId){
                row.selfUser=true;
            }else{
                row.selfUser=false;
            }
            messageList.push(row);
        })
      
        res.status(200).json({
            code:1,
            data:messageList,
            msg:'get message!'
        }); 
       
    
    }else if(fromId==null && toId!=null){

        const msgs=await sql.getMSGtoUserId(toId);
        var data=msgs.rows;
        data.forEach(row=>{
            if(row.fromUserId==fromId){
                row.selfUser=true;
            }else{
                row.selfUser=false;
            }
            messageList.push(row);
        })
       
        res.status(200).json({
            code:1,
            data:messageList,
            msg:'get message!'
        }); 
      
    }else{
        const msgs=await sql.getMSGfromOrtoUserId(fromId,toId);
        var data=msgs.rows;
        console.log(`from=${fromId}; to=${toId};`);
        data.forEach(row=>{
            if(row['fromuserid']==fromId){
                row.selfuser=true;
            }else{
                row.selfuser=false;
            }
            console.log(row);
            messageList.push(row);
        })
        res.status(200).json({
            code:1,
            data:messageList,
            msg:'get message!'
        }); 
    }
};