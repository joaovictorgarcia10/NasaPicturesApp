# Nasa Pictures App

This application consumes the [NASA's "Astronomy Picture of the Day"](https://api.nasa.gov) API and display it's content to users in a fashion manner.


## Features

- [x] 2 screens: a list of images and a detail screen.
- [x] The images list displays the title, date and provide a search field in the top (find by title or date)
- [x] The detail screen has the image and the texts: date, title and explanation
- [x] Work offline
- [x] Support multiple resolutions and sizes
- [x] Pull-to-refresh 
- [x] Pagination

## Dependencies

- [x] get_it: ^7.6.4
- [x] dio: ^5.3.2
- [x] shared_preferences: ^2.2.1
- [x] cached_network_image: ^3.2.3
- [x] mocktail: ^1.0.0

## Organization

### /app

Here you'll find the application initialization features: AppDependencies (Dependency Injection) and the AppWidget (App Root Widget).

### /core

At this layer you'll find the application's core features, such as: constants, environment config, exception handling and the infrastruture layer wich abstracts and implements third part libraries using the Adapter Design Pattern.

### /pictures

Here you'll find the application main functionality, wich is deal with the pictures. It was built following the Clean Architecture standard:

- UI
- Presentation
- Domain
- Data

## App Enviroment

The application environment variables are setted by _--dart-define_ strategy wich allow us to catch environment variables in our Flutter app run or build.

At this development environment you can find _--dart-define_ values inside ```flutter_run.sh``` script and VsCode __launch.json__ file:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "nasa_pictures_app",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=API_BASE_URL=https://api.nasa.gov",
                "--dart-define=API_KEY=ceTiTEfkHDvXK7tSu7hxrrA7hs6fwDYRPajfZ7cz"
            ]
        },
    ]
}
```

But for production environments, put sensitive data such as our __API_KEY__ inside the application code is a serious security problem that can be resolved by:
- Set _--dart-define_  production values only in the __CI environment__.
- Run __code obfuscation__ algorithms at build time. [(Obfuscate Dart code)](https://docs.flutter.dev/deployment/obfuscate)



## Tests

You can run the application Unit and Widget Tests by running the ```flutter_test_coverage.sh``` script wich will run all the tests, generate the __coverage/lcov.info__ and the __HTML report__.

- Note: on macOS you need to have lcov installed on your system (`brew install lcov`).










