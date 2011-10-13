Feature: Standard data access 
    In order access data on the server
    I need should return some json.

Background:
	Given the following users exists
	  | name     | email           |
	  | J Smith  | smith@smith.com |
	  | B Bloggs | b@bloggs.com    |
	And the following recipes exists
	  | name     | description |
	  | Shopping | Go to the shops |
	  | Cakes    | Buy stuff       |
	  | Clean    | Hoover room     |
	And "Shopping" belongs to "J Smith"
	And "Cakes" belongs to "B Bloggs"
	And "Clean" belongs to "J Smith" 
	And I have setup my ability class
	"""
	class Ability
	  include CanCan::Ability

	  def initialize(user)
	    can :manage, :all
	  end
	end
	"""
	And I am not logged in

Scenario: List users
    When the client requests GET /user
    Then the response should be JSON:
	"""
	{"data" : [
		{"name": "J Smith", "email": "smith@smith.com", "id": 1},
		{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
		],
	 "count" : 2, "limit" : null, "offset": null
	}
	"""
	
Scenario: List users with field list
    When the client requests GET /user?fields[only]=email
    Then the response should be JSON:
	"""
	{"data": 
		[
			{"email": "smith@smith.com"}, 
			{"email": "b@bloggs.com"}
		], "count":2, "limit":null, "offset":null
	}
	"""

Scenario: List recipes using a dynamic finder
	Given the following recipes exists
	  | name      | description          |
	  | Shopping2 | Go to the shops      |
	  | Cakes2    | Buy stuff            |
	  | Clean2    | Hoover room          |
	  | Shopping3 | Go to the shops      |
	And "Shopping2" belongs to "J Smith"
	And "Shopping3" belongs to "B Bloggs"
 	When the client requests GET /recipes/?description=Go%20to%20the%20shops
    Then the response should be JSON:
	"""
	{
		"data" : [
	  		{"name" : "Shopping",  "description" : "Go to the shops", "id" : 1, "userId" : 1},
	  		{"name" : "Shopping2", "description" : "Go to the shops", "id" : 4, "userId" : 1},
	  		{"name" : "Shopping3", "description" : "Go to the shops", "id" : 7, "userId" : 2}
			], 
			"count" : 3, "limit" : null, "offset" : null
	}
	"""
	
Scenario: List a single user
    When the client requests GET /users/1
    Then the response should be JSON:
	"""
	{"name" : "J Smith", "email": "smith@smith.com", "id": 1}
	"""

Scenario: Tries to access an invalid record
    When the client requests GET /users/1000000
    Then the response should be JSON:
	"""
	{"error": "Record 1000000 not found"}
	"""

Scenario: List a single user with an association
    When the client requests GET /users/1?fields[include]=recipes
    Then the response should be JSON:
	"""
	{"name": "J Smith", "id": 1, "email": "smith@smith.com",  
	  "recipes": [
	    {"name": "Shopping", "id": 1, "description": "Go to the shops", "userId": 1}, 
	    {"name": "Clean", "id": 3, "description": "Hoover room", "userId": 1}
	  ]
	}
	"""
	
Scenario: List a single user with field list
    When the client requests GET /users/1?fields[only]=email
    Then the response should be JSON:
	"""
	{"email": "smith@smith.com"}  
	"""


Scenario: Successfully update a single user
    When the client requests PUT /users/1 with name "A Smith" and email "only@smith.com"
    Then the response should be JSON:
	"""
	{"name": "A Smith", "email": "only@smith.com", "id" : 1}
	"""
    And the client requests GET /user
    Then the response should be JSON:
	"""
	{ "data": 
		[
			{"name": "A Smith", "email": "only@smith.com", "id": 1},
			{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
		], "count" : 2, "limit" : null, "offset" : null
	}
	"""
Scenario: Successfully create a new user
    When the client requests POST /users with name "E Bygumm" and email "eric@bygumm.com"
    Then the response should be JSON:
	"""
	{"name":"E Bygumm", "id":3, "email":"eric@bygumm.com"}
	"""
    And the client requests GET /user
    Then the response should be JSON:
	"""
	{ "data": 
		[
			{"name": "J Smith", "email": "smith@smith.com", "id": 1},
			{"name": "B Bloggs", "email": "b@bloggs.com",    "id": 2},
			{"name": "E Bygumm", "email": "eric@bygumm.com", "id": 3}
		], "count" : 3, "limit" : null, "offset" : null
	}
	"""

Scenario: Successfully delete a single user
    When the client requests DELETE /users/1
    Then the response should be JSON:
	"""
	{"success": "true"}
	"""
    And the client requests GET /user
    Then the response should be JSON:
	"""
	{ "data": 
		[
			{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
		], "count" : 1, "limit" : null, "offset" : null
	}
	"""

Scenario: Fails to delete a single user
    When the client requests DELETE /users/1000000
    Then the response should be JSON:
	"""
	{"error": "Record 1000000 not found"}
	"""
    And the client requests GET /user
    Then the response should be JSON:
	"""
	{ "data": 
		[
			{"name": "J Smith", "email": "smith@smith.com", "id": 1},
			{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
		], "count" : 2, "limit" : null, "offset" : null
	}
	"""
