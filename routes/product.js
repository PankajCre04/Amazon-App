const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const {Product} = require("../models/product");

//   /api/products?category=Essentials
productRouter.get("/api/products",auth,async(req,res) => {
    try{
        const products = await Product.find({category:req.query.category}); 
        res.json(products);
    }catch(err){
        res.status(500).json({error:err.message});
    }
});

productRouter.get("/api/products/",auth,async(req,res) => {
    try{
        const products = await Product.find({category:req.query.category}); 
        res.json(products);
    }catch(err){
        res.status(500).json({error:err.message});
    }
});

//  create a get request to search product and get them.
productRouter.get("/api/products/search/:name",auth,async(req,res) => {
    try{
        const products = await Product.find({
            name:{$regex: req.params.name, $options:"i"}
        }); 
        res.json(products);
    }catch(err){
        res.status(500).json({error:err.message});
    }
});

// create a post request route to rate the product
productRouter.post("/api/rate-product", auth, async (req, res) => {
    try {
      const { id, rating } = req.body;
      let product = await Product.findById(id);
  
      for (let i = 0; i < product.ratings.length; i++) {
        if (product.ratings[i].userId == req.user) {
          product.ratings.splice(i, 1);
          break;
        }
      }
  
      const ratingSchema = {
        userId: req.user,
        rating,
      };
  
      product.ratings.push(ratingSchema);
      product = await product.save();
      res.json(product);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

// Deal of the day - The Product that got highest rating 

productRouter.get("/api/deal-of-day",auth, async (req,res) => {
  try{
      let products = await Product.find({});
      products = products.sort((product1,product2) => {
        let product1_sum = 0;
        let product2_sum = 0;

        for(let i=0; i<product1.ratings.length; i++ ){
          product1_sum+=product1.ratings[i].rating;
        }
        for(let i=0; i<product2.ratings.length; i++ ){
          product2_sum+=product2.ratings[i].rating;
        }
        return product1_sum < product2_sum ? 1 : -1;
      });

      res.json(products[0]);
  }catch(err){
    res.status(500).json({ error: err.message });

  }

} );

module.exports = productRouter;