Feature: User list
    In order to make a great smoothie
    I need some fruit.

Scenario: List users
    Given the following users exists
      | name     | email           |
      | J Smith  | smith@smith.com |
      | B Bloggs | b@bloggs.com    |
    When the client requests GET /user
    Then the response should be JSON:
	"""
	[
	{"name": "J Smith", "email": "smith@smith.com", "id": 1},
	{"name": "B Bloggs", "email": "b@bloggs.com", "id": 2}
	]
	"""
Scenario: List a single user
    Given the following users exists
      | name     | email           |
      | J Smith  | smith@smith.com |
      | B Bloggs | b@bloggs.com    |
    When the client requests GET /user/1
    Then the response should be JSON:
	"""
	{"name": "J Smith", "email": "smith@smith.com", "id": 1}
	"""
