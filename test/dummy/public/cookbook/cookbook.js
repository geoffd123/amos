steal.plugins(	
	'jquery/controller',			// a widget factory
	'jquery/controller/subscribe',	// subscribe to OpenAjax.hub
	'jquery/view/ejs',				// client side templates
	'jquery/controller/view',		// lookup views with the controller's name
	'jquery/model',					// Ajax wrappers
	'jquery/dom/fixture',			// simulated Ajax requests
	'jquery/dom/form_params')		// form data helper
	
	.css('cookbook')	// loads styles

	.resources()					// 3rd party script's (like jQueryUI), in resources folder

	.models('recipe')						// loads files in models folder 

	.controllers('recipe')					// loads files in controllers folder

	.views();						// adds views to be added to build

steal.plugins('steal/coffee').then(function(){
	steal.coffee('coffee/log', 'coffee/underscore', 'coffee/coffeekup');	
});	