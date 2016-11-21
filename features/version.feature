Feature: version check
  As a developer
  I want to check the installed version of Contur
  Scenario:
    When I call "contur -V"
    Then Contur tells it's version
