# Modern UI Search Feature Guide

## Overview

The search feature has been added to your modern climbing weather app, allowing users to search for climbing areas and navigate between them seamlessly.

## What's Been Added

### 1. **AreaSearchViewModel.swift**
A view model that manages the search state and logic:
- Debounced search (500ms delay to avoid excessive API calls)
- Automatic search as the user types
- Error handling and retry functionality
- Clean state management

### 2. **AreaSearchView.swift**
A beautiful, modern search interface with:
- Native iOS `.searchable()` modifier
- Empty state with helpful tips
- Loading and error states
- Search results list with area details
- Direct navigation to forecast views

### 3. **ModernRootView.swift**
A tab-based root view providing:
- Search tab for finding areas
- Popular areas tab (bonus!)
- Clean navigation structure

### 4. **Updated ModernForecastView.swift**
Enhanced with:
- Search button in the toolbar
- Sheet presentation of search view
- Ability to search from any forecast screen

## How to Use

### Option 1: Use ModernRootView as Your App Entry Point

In your app's main entry point (typically your `@main` App struct):

```swift
import SwiftUI

@main
struct ClimbingWeatherApp: App {
    // Your repository instance
    let repository: AreaRepositoryProtocol = AreaRepository() // or your actual implementation
    
    var body: some Scene {
        WindowGroup {
            ModernRootView(repository: repository)
        }
    }
}
```

### Option 2: Present Search from Anywhere

If you want to present search from a specific view:

```swift
import SwiftUI

struct MyView: View {
    @State private var showingSearch = false
    let repository: AreaRepositoryProtocol
    
    var body: some View {
        Button("Search Areas") {
            showingSearch = true
        }
        .sheet(isPresented: $showingSearch) {
            AreaSearchView(repository: repository)
        }
    }
}
```

### Option 3: Use Search as a Single Tab

If you already have a tab view:

```swift
TabView {
    // Your existing tabs...
    
    AreaSearchView(repository: repository)
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }
}
```

## Features

### Intelligent Search
- **Debounced input**: Waits 500ms after the user stops typing before searching
- **Automatic cancellation**: Previous searches are cancelled when a new one starts
- **Empty query handling**: Clears results when the search box is empty

### Rich Search Results
Each result shows:
- Area name
- Location (admin area + country)
- Current temperature (if forecast data is available)
- Weather icon and summary

### Seamless Navigation
- Tap any search result to view the full forecast
- Use the search button in the forecast toolbar to find another area
- Navigation is handled automatically with SwiftUI's NavigationStack

### Error Handling
- Network errors are displayed with retry options
- Empty state shown when no results found
- Loading states with progress indicators

## Customization

### Change Search Debounce Time

In `AreaSearchViewModel.swift`, modify the debounce duration:

```swift
$searchQuery
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main) // Changed from 500ms
    .removeDuplicates()
    .sink { [weak self] query in
        self?.performSearch(query: query)
    }
    .store(in: &cancellables)
```

### Customize Search Placeholder

In `AreaSearchView.swift`, modify the `SearchPlaceholderView`:

```swift
struct SearchPlaceholderView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Customize this view with your own branding/messaging
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary.opacity(0.5))
            // ... rest of your custom content
        }
    }
}
```

### Add Forecast Data to Search Results

If you want to include weather forecast data in search results, modify your API call to include the `days` parameter. Update where the search happens or configure your repository to always return forecast data with area searches.

## Testing

Use the included preview to test the search view:

```swift
#Preview {
    AreaSearchView(repository: MockAreaRepository())
}
```

The `MockAreaRepository` is already defined in your `ModernForecastView.swift` file.

## Architecture

The search feature follows clean architecture principles:

```
View (AreaSearchView)
  ↓
ViewModel (AreaSearchViewModel)
  ↓
Repository (AreaRepositoryProtocol)
  ↓
API/Network Layer
```

This makes it easy to:
- Test each component independently
- Swap implementations (e.g., for testing)
- Maintain and extend functionality

## Next Steps

Consider adding:
1. **Search history**: Save recent searches locally
2. **Favorites**: Bookmark frequently accessed areas
3. **Filters**: Filter by country, temperature, conditions, etc.
4. **Map view**: Display search results on a map
5. **Sharing**: Share area forecasts with others

Enjoy your new search feature! 🏔️
