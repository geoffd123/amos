Feature: Paginate results 
    In order access large datasets the server
    should return paginated data 

Background:
    Given 20 users exist
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

Scenario: List users with no pagination
    When the client requests GET /user
    Then the response should be JSON:
	"""
	{ "data" :
		[
			{"name": "J Smith", "email": "smith@smith.com", "id": 1},
			{"name": "J Smith", "email": "smith@smith.com", "id": 2},
			{"name": "J Smith", "email": "smith@smith.com", "id": 3},
			{"name": "J Smith", "email": "smith@smith.com", "id": 4},
			{"name": "J Smith", "email": "smith@smith.com", "id": 5},
			{"name": "J Smith", "email": "smith@smith.com", "id": 6},
			{"name": "J Smith", "email": "smith@smith.com", "id": 7},
			{"name": "J Smith", "email": "smith@smith.com", "id": 8},
			{"name": "J Smith", "email": "smith@smith.com", "id": 9},
			{"name": "J Smith", "email": "smith@smith.com", "id": 10},
			{"name": "J Smith", "email": "smith@smith.com", "id": 11},
			{"name": "J Smith", "email": "smith@smith.com", "id": 12},
			{"name": "J Smith", "email": "smith@smith.com", "id": 13},
			{"name": "J Smith", "email": "smith@smith.com", "id": 14},
			{"name": "J Smith", "email": "smith@smith.com", "id": 15},
			{"name": "J Smith", "email": "smith@smith.com", "id": 16},
			{"name": "J Smith", "email": "smith@smith.com", "id": 17},
			{"name": "J Smith", "email": "smith@smith.com", "id": 18},
			{"name": "J Smith", "email": "smith@smith.com", "id": 19},
			{"name": "J Smith", "email": "smith@smith.com", "id": 20}
		], "limit" : null, "count" : 20 , "offset" : null
	}
	"""

Scenario: List users with pagination
    When the client requests GET /user?limit=10
    Then the response should be JSON:
	"""
	{ "data" :
		[
			{"name": "J Smith", "email": "smith@smith.com", "id": 1},
			{"name": "J Smith", "email": "smith@smith.com", "id": 2},
			{"name": "J Smith", "email": "smith@smith.com", "id": 3},
			{"name": "J Smith", "email": "smith@smith.com", "id": 4},
			{"name": "J Smith", "email": "smith@smith.com", "id": 5},
			{"name": "J Smith", "email": "smith@smith.com", "id": 6},
			{"name": "J Smith", "email": "smith@smith.com", "id": 7},
			{"name": "J Smith", "email": "smith@smith.com", "id": 8},
			{"name": "J Smith", "email": "smith@smith.com", "id": 9},
			{"name": "J Smith", "email": "smith@smith.com", "id": 10}
		], "limit" : 10, "count" : 20 , "offset" : null
	}
    """
    When the client requests GET /user?limit=10&offset=10
    Then the response should be JSON:
	"""
	{ "data" :
		[
			{"name": "J Smith", "email": "smith@smith.com", "id": 11},
			{"name": "J Smith", "email": "smith@smith.com", "id": 12},
			{"name": "J Smith", "email": "smith@smith.com", "id": 13},
			{"name": "J Smith", "email": "smith@smith.com", "id": 14},
			{"name": "J Smith", "email": "smith@smith.com", "id": 15},
			{"name": "J Smith", "email": "smith@smith.com", "id": 16},
			{"name": "J Smith", "email": "smith@smith.com", "id": 17},
			{"name": "J Smith", "email": "smith@smith.com", "id": 18},
			{"name": "J Smith", "email": "smith@smith.com", "id": 19},
			{"name": "J Smith", "email": "smith@smith.com", "id": 20}
		], "limit" : 10, "count" : 20 , "offset" : 10
	}
	"""

Scenario: List users using dynamic finder and pagination
 	When the client requests GET /users?name=J%20Smith&limit=10
    Then the response should be JSON:
	"""
	{ "data" :
		[
			{"name": "J Smith", "email": "smith@smith.com", "id": 1},
			{"name": "J Smith", "email": "smith@smith.com", "id": 2},
			{"name": "J Smith", "email": "smith@smith.com", "id": 3},
			{"name": "J Smith", "email": "smith@smith.com", "id": 4},
			{"name": "J Smith", "email": "smith@smith.com", "id": 5},
			{"name": "J Smith", "email": "smith@smith.com", "id": 6},
			{"name": "J Smith", "email": "smith@smith.com", "id": 7},
			{"name": "J Smith", "email": "smith@smith.com", "id": 8},
			{"name": "J Smith", "email": "smith@smith.com", "id": 9},
			{"name": "J Smith", "email": "smith@smith.com", "id": 10}
		], "limit" : 10, "count" : 20 , "offset" : null
	}
    """

 	When the client requests GET /users?name=J%20Smith&limit=10&offset=10
    Then the response should be JSON:
	"""
	{ "data" :
		[
			{"name": "J Smith", "email": "smith@smith.com", "id": 11},
			{"name": "J Smith", "email": "smith@smith.com", "id": 12},
			{"name": "J Smith", "email": "smith@smith.com", "id": 13},
			{"name": "J Smith", "email": "smith@smith.com", "id": 14},
			{"name": "J Smith", "email": "smith@smith.com", "id": 15},
			{"name": "J Smith", "email": "smith@smith.com", "id": 16},
			{"name": "J Smith", "email": "smith@smith.com", "id": 17},
			{"name": "J Smith", "email": "smith@smith.com", "id": 18},
			{"name": "J Smith", "email": "smith@smith.com", "id": 19},
			{"name": "J Smith", "email": "smith@smith.com", "id": 20}
		], "limit" : 10, "count" : 20 , "offset" : 10
	}
	"""

