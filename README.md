
# README #

## Prerequisites ##

Xcode 10, iOS 12.1

## Instructions ##

* Open LastFm.xcodeproj. When open press run using a simulator or device.

* Run the test using CMD + U

* The project has two view controller called AlbumSearchtListViewController that shows a list of albums for a query. And the AlbumInfoViewController that shows the albums details including the tracks

* Unit tests are done with XCTest. The test covearage is 97.2%.

* The only third party libraries are RxSwift and RxCocoa and the code is written using the below coding standards. Also ImageCache that was developed by image some time ago.

## Coding standards ##

### Naming ###

* Use descriptive names with camelcase for classes, methods, variables, etc. Classes should be capitalized while method names should start with lowercase 

### Spacing ###

* Method braces always open in the same line
* Use one space separation between any operators for clarity

### Code Separation ###

* Use //MARK: - to make navigating the code easier

### Conditionals ###

* Conditionals bodies should always be in braces

### Ternary Operator ###

* Should only be used when increases clarity

### Methods ###

* There should be an space between method arguments

### Extensions naming ###

* ClassName+Functionality

### Protocols ###

* Declare all protocols in its own file
* File should have the same name as the protocol

### Use of self ###

* Avoid using self since Swift doesn’t require it to access objects or methods

### Completion blocks ###

* Don't include their definition unless is necessary e.g () -> () in remove () -> ()

### Types ###

* Try to use native types when available

### Type inference ###

* Let the compiler infer the type for a constant or variable unless you need to specify a type

### Semicolons ###

* No need to use them, you should not have two statements in the same line

### Code header comments ###

* Should be removed as the code belongs to the team not to the person the has created the class

### Other considerations ###

* Keep it simple
* Keep classes and methods short
* No comments (the code should be self explanatory)

## Project structure ##

* Classes
* * AppDelegate
* * Utils
* * ThirdParty 
* * Model
* * * Domain
* * * Network 
* * Controllers
* * * Views 
* * Resources
* * * Images, fonts, strings, plists, etc

### Folders ###

* Create class folders in finder and drag them to Xcode

## Unit Testing ##

* Unit testing is done using XCTest
