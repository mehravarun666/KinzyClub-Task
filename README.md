# planit

Plan IT - Create, Update and Manage Tasks

##List of Implemented Features

User Authentication: Sign up, log in, and log out using Firebase Authentication.
Task Management: Create, update, delete, and view tasks.
Boards:
1.Manage multiple boards for task organization.
2. Assign colors and visibility settings to boards.
Real-time Updates: Integrated with Firestore for real-time task and board updates.
Responsive Design: Works seamlessly on various screen sizes.
Drawer Navigation: Access user profile, settings, and sign-out functionality.

##Assumptions or Design Decisions

Firebase as Backend: The app uses Firebase for authentication and Firestore for real-time database management.
Task-Centric Design: The primary focus is on task creation and management.
Mobile-First: Designed with a responsive layout for mobile devices.
Default Features: 
1.Authentication is mandatory to use the app.
2.Each user has private boards and tasks, isolated from others.

Known Limitations or Bugs

##Offline Mode:
Limited offline functionality; requires an active internet connection for most features.
Board Color Picker: Does not validate certain color formats, causing potential rendering issues.
Performance on Large Data: Performance may degrade with a very large number of tasks or boards due to Firestore query limitations.
Error Handling: Certain error messages (e.g., Firebase errors) may not be user-friendly.


