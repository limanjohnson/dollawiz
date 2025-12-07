# Overview

{Important! Do not say in this section that this is college assignment. Talk about what you are trying to accomplish as a software engineer to further your learning.}

This is a personal finance app written using the Flutter framework. It stores data using the Firebase Cloud Service by Google. A user can create an account and then log their transactions which will be stored so they can access them from different devices and keep their data saved between use sessions.

The pupose in writing this software was to practice using Flutter and using a cloud database to store data.

{Provide a link to your YouTube demonstration. It should be a 4-5 minute demo of the software running, a walkthrough of the code, and a view of the cloud database.}

[Software Demo Video](https://youtu.be/W2gfxQcvy24)

# Cloud Database

I am using Firebase services, specifically Firestone Database. Google Firebase is also used for user authentication

The structure of the database is essentially a collection which has additional collections nested. There is a user collection which then ccan have additional collections (in this case "transactions"). Transactions then have values that align with each of the transacions a user will insert for their account. The transactions table captures the account, amount, category, contact, date, description, any notes, status, tags, and type (income vs expense).

# Development Environment

I used JetBrains IntelliJ IDEA as my IDE. Typically I would use Visual Studio Code but I wanted to see what other tools could be beneficial for programming in Dart.

Flutter and Dart dependencies were used in this project. The main langauge in the Flutter framework is Dart. Firebase dependencies were added for things like storage and user authentication, and fl_chart to display a pie chart. flutter_login was used to create the login page.

# Useful Websites

{Make a list of websites that you found helpful in this project}

- [Flutter Official Documentation](https://docs.flutter.dev/ui)

# Future Work

{Make a list of things that you need to fix, improve, and add in the future.}

- Goals Page
- Budget page
- Reports page to print of monthly statements
