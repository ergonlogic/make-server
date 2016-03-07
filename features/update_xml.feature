Feature: Update XML
  In order to keep track of package versions
  As a platform maintainer
  I need to be able to publish XML that Drush Make can use

  Scenario: Anonymous access to an XML page
    Given I am not logged in
      And I am on the homepage
     Then I should see the text "Enter your Site-Install username."
