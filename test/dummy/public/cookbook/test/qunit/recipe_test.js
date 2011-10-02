module("Model: Cookbook.Models.Recipe")

asyncTest("findAll", function(){
	stop(2000);
	Cookbook.Models.Recipe.findAll({}, function(recipes){
		ok(recipes)
        ok(recipes.length)
        ok(recipes[0].name)
        ok(recipes[0].description)
		start()
	});
	
})

asyncTest("create", function(){
	stop(2000);
	new Cookbook.Models.Recipe({name: "dry cleaning", description: "take to street corner"}).save(function(recipe){
		ok(recipe);
        ok(recipe.id);
        equals(recipe.name,"dry cleaning")
        recipe.destroy()
		start();
	})
})
asyncTest("update" , function(){
	stop();
	new Cookbook.Models.Recipe({name: "cook dinner", description: "chicken"}).
            save(function(recipe){
            	equals(recipe.description,"chicken");
        		recipe.update({description: "steak"},function(recipe){
        			equals(recipe.description,"steak");
        			recipe.destroy();
        			start()
        		})
            })

});
asyncTest("destroy", function(){
	stop(2000);
	new Cookbook.Models.Recipe({name: "mow grass", description: "use riding mower"}).
            destroy(function(recipe){
            	ok( true ,"Destroy called" )
            	start();
            })
})

test("isTasty", function(){
  var Recipe = Cookbook.Models.Recipe,
      r1 = new Recipe({name: "tea",
                       description: "leaves and water"}),
      r2 = new Recipe({name: "mushroom soup",
                       description: "mushrooms and water"});
  ok(r1.isTasty(), "tea is tasty")
  ok(!r2.isTasty(), "mushroom soup is not tasty")
})


