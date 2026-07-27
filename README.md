# MovieWatchlist
Movie browsing and watchlist app built with SwiftUI, UIKit navigation, and TMDB API.

The app allows users to browse movies, view detailed information about a selected movie, and manage a personal watchlist. Movie data is fetched from The Movie Database (TMDB) API, while the watchlist is stored locally using UserDefaults.

## Features

- Browse movies using the TMDB Discover Movies API
- View detailed information for a selected movie
- Add and remove movies from the watchlist
- Persist the watchlist using UserDefaults
- Load additional movies using pagination
- UIKit-based navigation with SwiftUI screens
- Unit tests for the main business logic

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture to separate UI, business logic, and data handling.

- **Models** – Movie and API response models
- **Views** – SwiftUI screens
- **ViewModels** – Manage screen state and business logic
- **Services** – Handle communication with the TMDB API
- **Storage** – Manage watchlist persistence using UserDefaults
- **Navigation** – UIKit coordinator responsible for app navigation
- **Tests** – Unit tests with mock services and stores

## Technologies Used

- Swift
- SwiftUI
- UIKit
- MVVM
- URLSession
- UserDefaults
- XCTest
- TMDB API

## Development Environment

- **Deployment Target:** iOS 26.5
- **Xcode Version:** 26.6
- **Language:** Swift

## Getting Started

1. Clone the repository.

```bash
git clone https://github.com/Nidhishree-Narasim-Nayak/MovieWatchlist.git
```

2. Open the project using Xcode 26.6.

3. Add your TMDB Bearer Token to the `TMDB_API_TOKEN` key in `Info.plist` (or `Config.xcconfig`, depending on your setup).

4. Build and run the project.

## API Configuration

Before running the project, add your TMDB Bearer Token to the `TMDB_API_TOKEN` key in `Config.xcconfig`.

## Running Unit Tests

Run all unit tests from Xcode:

- **Product → Test**
- or press **⌘ + U**

The project includes unit tests for:

- MoviesViewModel
- MovieDetailsViewModel
- WatchlistViewModel
- UserDefaultsWatchlistStore

Mock services and mock stores are used to test business logic independently of network and storage implementations.

## Project Structure

```
MovieWatchlist
│
├── App
├── Models
├── Navigation
├── Services
├── Storage
├── ViewModels
├── Views
└── MovieWatchlistTests
```

## Notes

- Navigation is implemented using UIKit.
- All screens are built using SwiftUI.
- The watchlist is stored locally using UserDefaults.
- Pagination is implemented to load additional movies as the user scrolls.
- The project focuses on clean architecture, separation of responsibilities, and testability rather than visual polish, as outlined in the assignment.
