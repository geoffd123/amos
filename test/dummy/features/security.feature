Feature: Security
    In order access to the data secure 
    I need to be able to specify some access control


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


Scenario: Allowing access to all data
	Given I have setup my ability class
	"""
	class Ability
	  include CanCan::Ability

	  def initialize(user)
	    can :manage, :all
	  end
	end
	"""
	And I am not logged in
    When the client requests GET /user
    Then the response should be JSON:
	"""
	{ "data" :
		[
			{"name": "J Smith", "email": "smith@smith.com", "id": 1},
			{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
			], "limit" : null, "count" : 2 , "offset" : null
	}
	"""

Scenario: Denying access to all data
	Given I have setup my ability class
	"""
	class Ability
	  include CanCan::Ability

	  def initialize(user)
	    cannot :manage, :all
	  end
	end
	"""
	And I am not logged in
    When the client requests GET /user
    Then the response should be status "401" with JSON:
	"""
	{"error" : "You are not authorized to access this data"}
	"""
 