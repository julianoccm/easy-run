
<p align="center"> <img src="https://github.com/user-attachments/assets/7d696231-160d-42ca-ba8c-665cbe34a1e8" /> 
<h1 align="center"> Easy Run </h1></p>

Easy Run is an app focused on helping you maintain a goal of running consistently! It uses a goal system to encourage you and keep track of your runs.

## Tech Stack
<img src="https://skillicons.dev/icons?i=nestjs,flutter,mysql" />

## Key Features of the App
- Monthly target system
- Race history
- Total distance covered in the month (in kilometers)
- Total running time in the month
- Interactive maps for your runs

## Backend
This application was developed using NestJs and the TypeORM library, with a MySQL database. To run the backend of the application, you need to follow these steps to configure the project:

### If You Don't Have a MySQL Database (Recommended)
If you don't have a MySQL database on your computer, you'll need to install it or create a Docker instance to run the application. I personally recommend this step to avoid environment conflicts. Even if you already have MySQL, I suggest following this step.

Inside the project, you'll find a `docker` folder, which contains a `docker-compose.yml` file already configured to create the database for you:

```sh
docker-compose -f docker/docker-compose.yml up -d
```

Now you are ready—just run the following command in your terminal to start the application:

```sh
npm run start:dev
```

### If You Already Have a MySQL Database
If you already have an instance, you must make a few configurations in order to run this project. You will need to export your environment variables to establish a connection to the database:

```sh
export DB_HOST='<HOST>'
export DB_PORT=3306
export DB_USERNAME='<USERNAME>'
export DB_PASSWORD='<PASSWORD>'
export DB_NAME='easy_run'
```

Alternatively, you can change the values in the file: `backend/src/infra/database/typeorm-config.module.ts`.

After this step, you can run the application:

```sh
npm run start:dev
```

## Frontend
This application was developed using Flutter. To run the frontend of the application, you need to follow these steps to configure the project:

### Google Maps API Key
To add Google Maps integration to the application, you need to create a Google Cloud account and retrieve an API Key to use the Maps service. If you want to run this project locally, you will need an API Key. You can follow [this step](https://developers.google.com/maps/documentation/embed/get-api-key?hl=pt-br#:~:text=Go%20to%20the%20Google%20Maps%20Platform%20%3E%20Credentials%20page.&text=On%20the%20Credentials%20page%2C%20click,Click%20Close.) in the Google Cloud documentation.

After retrieving your API Key, you can add it to the file `frontend/android/app/src/main/AndroidManifest.xml` at line 35:

```xml
<meta-data android:name="com.google.android.geo.API_KEY" android:value="<YOUR-API-KEY>"/>
```

## Backend Call
To allow the device or emulator running the app to connect to the backend, you must change the base URL of the endpoint call. Go to the file `frontend/lib/api.dart` and set the host where the backend is running:

```dart
const baseUrl = 'http://10.0.2.2:8080'; // ANDROID EMULATOR
```

Then you can run the app:
```sh
flutter run lib/main.dart
```

