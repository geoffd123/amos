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
	]
	"""

Scenario: List users with pagination
    Given pagination is set for "User" model
	And there are 10 items per page
    When the client requests GET /user
    Then the response should be JSON:
	"""
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
	]
    """
    When the client requests GET /user?page=2
    Then the response should be JSON:
	"""
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
	]
	"""

