var express = require('express');
var router = express.Router();
const register=require('../controllers/register');
const login=require('../controllers/login');
const chatlist=require('../controllers/chatlist');
const message=require('../controllers/message');
const connect=require('../controllers/connect');

router.post('/register',register.register)
router.post('/login',login.login)
router.get('/chat_list',chatlist.getChatList)
router.get('/message',message.getMessage)
//router.ws('/connect',connect.connnect)

module.exports = router;
