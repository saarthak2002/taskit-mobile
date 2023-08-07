# task.it Mobile App

This is a Flutter mobile app for the [task.it](https://taskit-frontend-a7880b47804a.herokuapp.com/) platform. It allows users to modify their projects on the task.it platform easily on the go. Data is served to the task.it mobile app from the same [Flask backend](https://github.com/saarthak2002/taskit-backend) that is used by the [task.it web application](https://github.com/saarthak2002/taskit-app), ensuring that user data is always synced across different platforms.

![task it mobile app cover](/screenshots/taskit-mobile-cover.png)

# Projects Home View

The home page of the app shows an authenticated user all their projects as clickable cards with information about each project. Clicking the floating add button in the bottom right corner brings up a menu to add a project. Clicking a project card brings the user to the project details view.

![projects home](/screenshots/projects-home.png)
![projects add](/screenshots/create-project.png)

# Project Details View

The project details view shows all the tasks added to a project with their name, description, status, creator, and category. Clicking the complete or pending button in a task card changes the status of a task. Clicking the floating add button in the bottom right corner of the project details view brings up a view to add a task to a project.

![tasks view](/screenshots/tasks-view.png)
![tasks add view](/screenshots/add-task.png)

# Collaborations View

The collaborations view shows a user all the projects they have been added to as a collaborator. Clicking a project card brings up the project details view for the collaborative project, allowing users to perform actions like adding tasks or marking a task as completed.

![collabs view](/screenshots/collabs.png)
![collabs view tasks](/screenshots/collabs-task-view.png)

# Profile and Login

The profile view allows the user to log out and shows them their info, stats, and collaborators. From the login view, users can log into their existing accounts with an email and password or continue with Google.

![Profile view](/screenshots/profile-view.png)
![Login](/screenshots/login.png)

# Web and Backend
All features of the task.it platform can be accessed from the [React web application](https://github.com/saarthak2002/taskit-app). A [Flask backend REST API](https://github.com/saarthak2002/taskit-backend) serves both the mobile app and the web app.

![web and mobile screenshots](/screenshots/taskit-cover-new.png)

# Copyright
This application was created by Saarthak Gupta © 2023.