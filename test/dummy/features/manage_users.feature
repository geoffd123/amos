Feature: Standard data access 
    In order access data on the server
    I need should return some json.

Background:
	Given the following users exists
	  | name     | email           |
	  | J Smith  | smith@smith.com |
	  | B Bloggs | b@bloggs.com    |

Scenario: List users
    When the client requests GET /user
    Then the response should be JSON:
	"""
	[
	{"name": "J Smith", "email": "smith@smith.com", "id": 1},
	{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
	]
	"""
Scenario: List a single user
    When the client requests GET /users/1
    Then the response should be JSON:
	"""
	{"name" : "J Smith", "email": "smith@smith.com", "id": 1}
	"""

Scenario: Successfully update a single user
    When the client requests PUT /users/1 with name "A Smith" and email "only@smith.com"
    Then the response should be JSON:
	"""
	{"success": "true"}
	"""
    And the client requests GET /user
    Then the response should be JSON:
	"""
	[
	{"name": "A Smith", "email": "only@smith.com", "id": 1},
	{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
	]
	"""
Scenario: Successfully create a new user
    When the client requests POST /users with name "E Bygumm" and email "eric@bygumm.com"
    Then the response should be JSON:
	"""
	{"success": "true"}
	"""
    And the client requests GET /user
    Then the response should be JSON:
	"""
	[
	{"name": "J Smith", "email": "smith@smith.com", "id": 1},
	{"name": "B Bloggs", "email": "b@bloggs.com",    "id": 2},
	{"name": "E Bygumm", "email": "eric@bygumm.com", "id": 3}
	]
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
	[
	{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
	]
	"""

Scenario: Fails to delete a single user
    When the client requests DELETE /users/1000000
    Then the response should be JSON:
	"""
	{"success": "false"}
	"""
    And the client requests GET /user
    Then the response should be JSON:
	"""
	[
	{"name": "J Smith", "email": "smith@smith.com", "id": 1},
	{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
	]
	"""
