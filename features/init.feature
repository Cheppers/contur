Feature: init command
  As a developer
  The 'contur init' command should initialize a new .contur.yml
  So I don't have to write it manually at first

  Scenario: No previous .contur.yml in the directory
    Given I have an empty directory
    When I run "contur init" in the directory
    Then I have a new .contur.yml
    And it contains:
      """
      ---
      version: 1.0
      php: '5.6'
      mysql: latest
      env:
        CONTUR: true
      before:
      - composer install
      """

  Scenario: Existing .contur.yml in the directory
    Given I have a directory with .contur.yml
    When I run "contur init" in the directory
    Then the CLI returns exit code 11
    And it prints to the console:
      """
      .contur.yml already exists
      """

  Scenario: Execute a "contur init --dry-run"
    Given I have an empty directory
    When I run "contur init --dry-run" in the directory
    Then I have an empty directory
    And it prints to the console:
      """
      ---
      version: 1.0
      php: '5.6'
      mysql: latest
      env:
        CONTUR: true
      before:
      - composer install
      """
