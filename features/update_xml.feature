Feature: Update XML
  In order to keep track of package versions
  As a platform maintainer
  I need to be able to publish XML that Drush Make can use

  Scenario: Anonymous access to the homepage
    Given I am not logged in
      And I am on the homepage
     Then I should see the text "Enter your Site-Install username."
  Scenario: New account creation
    Given I am not logged in
      And I visit "/user/register"
     Then I should see the text "A valid email address."


  Scenario: Anonymous access to an XML page
    Given I am not logged in
      And I visit "/release-history/hosting_civicrm/7.x"
