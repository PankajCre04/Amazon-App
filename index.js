// Imports from Packages
const express = require('express'); // Like Importing an package in flutter 
const mongoose = require("mongoose");
const adminRouter = require('./routes/admin');
// INIT
const app = express(); // Initializing express

app.get('/', (req, res)=> {
    res.send("Amazon Backend")
})



const PORT = process.env.PORT || 3000;
const DB ="mongodb+srv://pankaj:pankaj1904@cluster0.47odx.mongodb.net/?retryWrites=true&w=majority";

// Imports from other files
const authRouter = require("./routes/auth");
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

// Connections np
mongoose.connect(DB).then( () => {
    console.log("Connection Successful");
} ).catch( (e)=>{
    console.log(e);
} );
;

app.listen(PORT,"0.0.0.0",function (){
    console.log(`connected port ${PORT}`);
} );
