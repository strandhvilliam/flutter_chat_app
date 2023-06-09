# flutter-supabase-chat-app
(work in progress)
This is a chat application side project built using Flutter and Supabase as a Backend-as-a-Service (BaaS) provider. Please note that this project is currently in progress and is not yet finished. It is being developed as a learning project to improve my skills in mobile app development and backend services.







## Project Setup
To run this project, you will need to have Flutter installed on your machine. You can follow the instructions on the official Flutter website to install it.

After you have installed Flutter, clone this repository to your machine and navigate to the project directory in your terminal. Then, run the following command to install the project dependencies:


```bash
$ flutter pub get
```
Next, create a Supabase account and database and an .env file with url and key and load as follows before running app:

```dart

await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
```

Chat page demo             |  Creating room demo       | Chat list
:-------------------------:|:-------------------------:|:-------------------------:
![](https://user-images.githubusercontent.com/87245022/232564368-56ed7428-f483-401f-a8f4-9381fe6d4c08.png)  |  ![](https://user-images.githubusercontent.com/87245022/232565494-80df00cd-6189-479d-81fd-eb51b954789b.png) | ![](https://user-images.githubusercontent.com/87245022/232567899-581379d6-a31a-4152-965e-d3002b8e0bb1.png)

## Current Features
Authentication (login and registration)
Real-time messaging between users

## Future Plans
- [ ] Now all rooms recieve all messages. Limit to correct room.
- [ ] Make state persist between pages
- [ ] UI improvements
- [ ] Image and file sharing
- [ ] Push notifications
