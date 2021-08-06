const express = require('express')
const expressJwt=require('express-jwt')
const moment=require('moment')
const cors=require('cors')

const app = express()
const expressWs=require('express-ws')(app);

const router=require('./routes/index');
const sql=require('./db/sql');
const vertoken=require('./token/tokens')

const port = process.env.PORT || 8080;
let connections=new Map();

app.use(cors())
app.use(express.json());

app.use(function(req,res,next){
    var token = req.headers['authorization'];
    if(token == undefined){
        next();
    }else{
        console.log(token);
        vertoken.getToken(token).then((data)=> {
           
            req.data = data;
            next();
        }).catch((error)=>{
            res.status(201).send(error);
        })
    }
});
app.use(expressJwt({
    secret:'zgs_first_token',
    algorithms:['HS256']
}).unless({
    path:['/','/login','/register']  //不需要验证的接口名称
}))

app.use('',router);

app.ws('/connect', function(ws,req){
    console.log('connected');
    let userId=req.data['user_id'];

    ws.on('message',function(msg){
        console.log(`server listen:${JSON.parse(msg)}`);
        var from=req.data['user_id'];
        handleEvent(msg,from);
    })
    ws.on('close',function(e){
        console.log('close connection');
        connections.delete(userId);
    })
    connections.set(userId,ws);
    console.log(`currently, ${connections.size} customer connnected`);

})

app.listen(port, () => {
    console.log(`example app listening at port ${port}`)
})

var handleEvent=async function(msg,from){
    console.log('handle');

    var getMSG=JSON.parse(msg);

    var to=getMSG['toUserId'];
    var content=getMSG['msg_content'];
    var types=getMSG['msg_type'];
    var time=moment(Date.now()).format('YYYY-MM-DD hh:mm:ss');

    const insertres=await sql.insertmsg(from,to,content,types);
    console.log(insertres.rows[0]);
    connections.forEach(function(channel,key){
       
        if(key==to || key==from){
           var insertmsg=insertres.rows[0];
            insertmsg.selfuser=(key==from);
            channel.send(JSON.stringify(insertmsg));
        }
    })
    return null;
}