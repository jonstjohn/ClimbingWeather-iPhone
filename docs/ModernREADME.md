# Modern Architecture Guide

This document explains how to use the new modern API architecture alongside the existing legacy code.

## Overview

The modern architecture is built on these principles:

- ✅ **Swift Concurrency** (async/await) instead of callbacks
- ✅ **Codable** for type-safe JSON parsing
- ✅ **Protocol-based** for testability
- ✅ **Clean separation** of concerns (Networking → Repository → ViewModel → View)
- ✅ **SwiftUI-first** but UIKit compatible
- ✅ **Proper error handling** throughout

## Architecture Layers

```
┌─────────────────────────────────────────┐
│           SwiftUI Views                 │  ← User Interface
├─────────────────────────────────────────┤
│          ViewModels                     │  ← Business Logic & State
├─────────────────────────────────────────┤
│         Repositories                    │  ← Domain Logic
├─────────────────────────────────────────┤
│          API Client                     │  ← HTTP Networking
├─────────────────────────────────────────┤
│       APIEndpoint / Models              │  ← Configuration & Data
└─────────────────────────────────────────┘
```

## Folder Structure

```
Modern/
├── Networking/
│   ├── APIClient.swift          # HTTP client with async/await
│   ├── APIEndpoint.swift        # Typed endpoints
│   ├── APIError.swift           # Error types
│   └── APIConfiguration.swift   # Environment configuration
│
├── Models/                      # Codable models from OpenAPI spec
│   ├── Area.swift
│   ├── Forecast.swift
│   ├── Country.swift
│   ├── AdminArea.swift
│   ├── AreaAverages.swift
│   └── Clim81Station.swift
│
├── Repositories/                # Business logic layer
│   ├── AreaRepository.swift
│   ├── CountryRepository.swift
│   └── ClimateRepository.swift
│
├── ViewModels/                  # State management
│   ├── AreaForecastViewModel.swift
│   ├── AreaSearchViewModel.swift
│   └── AreaListViewModel.swift
│
├── Views/                       # SwiftUI views
│   ├── ForecastView.swift
│   └── AreaSearchView.swift
│
└── DependencyContainer.swift    # Dependency injection
```

## Quick Start

### 1. Using in SwiftUI

```swift
import SwiftUI

struct MyView: View {
    let areaId: Int
    let areaName: String
    
    var body: some View {
        ForecastView(
            areaId: areaId,
            areaName: areaName,
            repository: DependencyContainer.shared.areaRepository
        )
    }
}
```

### 2. Using in UIKit (Existing View Controllers)

```swift
import UIKit
import SwiftUI

class ExistingViewController: UIViewController {
    
    func showModernForecast(areaId: Int, areaName: String) {
        // Create SwiftUI view
        let forecastView = ForecastView(
            areaId: areaId,
            areaName: areaName,
            repository: DependencyContainer.shared.areaRepository
        )
        
        // Wrap in UIHostingController
        let hostingController = UIHostingController(rootView: forecastView)
        
        // Push or present
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
```

### 3. Using Repositories Directly (for custom UIs)

```swift
import Foundation

class MyCustomViewController: UIViewController {
    
    let repository = DependencyContainer.shared.areaRepository
    
    func loadForecast(areaId: Int) {
        Task {
            do {
                let forecast = try await repository.getForecast(areaId: areaId, days: 7)
                
                // Update UI on main thread
                await MainActor.run {
                    self.updateUI(with: forecast)
                }
            } catch {
                // Handle error
                await MainActor.run {
                    self.showError(error)
                }
            }
        }
    }
}
```

## Migration Strategy

### Phase 1: Side-by-Side (Current)

Use feature flags to toggle between old and new implementations:

```swift
// In your navigation/routing code
if FeatureFlags.useModernForecast {
    // Show new SwiftUI view
    let view = ForecastView(areaId: area.id, areaName: area.name, 
                           repository: DependencyContainer.shared.areaRepository)
    let hosting = UIHostingController(rootView: view)
    navigationController?.pushViewController(hosting, animated: true)
} else {
    // Show old UIKit view
    let vc = AreaDailyViewController()
    vc.areaId = area.id
    navigationController?.pushViewController(vc, animated: true)
}
```

### Phase 2: Gradual Replacement

Replace one feature at a time:

1. ✅ **Week 1-2:** Forecast view (Daily + Hourly)
2. ⏳ **Week 3-4:** Area search
3. ⏳ **Week 5-6:** Area lists (Popular, Nearby, Favorites)
4. ⏳ **Week 7-8:** State/Admin area browsing
5. ⏳ **Week 9-10:** Map view and details

### Phase 3: Remove Legacy

Once all features are migrated, delete the old code entirely.

## API Examples

### Search for Areas

```swift
let repository = DependencyContainer.shared.areaRepository

// Search by name
let areas = try await repository.searchAreas(query: "yosemite")

// Search by ZIP code
let areas = try await repository.searchAreas(query: "94010")

// Search by coordinates
let areas = try await repository.searchAreas(query: "37.7456,-119.5937")

// Search by IDs
let areas = try await repository.searchAreas(query: "ids-123,456,789")
```

### Get Forecast

```swift
let repository = DependencyContainer.shared.areaRepository

// Get 7-day forecast
let forecast = try await repository.getForecast(
    areaId: 123,
    days: 7,
    tempUnit: "f"  // or "c" for celsius
)

// Access daily forecast
if let dailyData = forecast.daily?.data {
    for day in dailyData {
        print("Date: \(day.date)")
        print("High: \(day.temperatureHigh ?? 0)°")
        print("Low: \(day.temperatureLow ?? 0)°")
        print("Precip: \(day.precipProbabilityPercentage ?? 0)%")
    }
}

// Access hourly forecast
if let hourlyData = forecast.hourly?.data {
    for hour in hourlyData {
        print("Time: \(hour.date)")
        print("Temp: \(hour.temperature ?? 0)°")
    }
}
```

### Get Area Details

```swift
let repository = DependencyContainer.shared.areaRepository

// Basic details
let details = try await repository.getAreaDetail(areaId: 123)
print("Name: \(details.name)")
print("Elevation: \(details.elevation ?? 0) ft")
print("City: \(details.city ?? "N/A")")

// With climate station data
let detailsWithClimate = try await repository.getAreaDetail(
    areaId: 123,
    includeClimateStation: true
)

if let station = detailsWithClimate.clim81Station {
    print("Station: \(station.stationName ?? "Unknown")")
    print("Annual precip: \(station.precip?[12] ?? 0) inches")
}
```

### Get Climate Averages

```swift
let repository = DependencyContainer.shared.areaRepository

let averages = try await repository.getAreaAverages(areaId: 123)

// Monthly data (1-12)
for month in 1...12 {
    let high = averages.highTemperature(for: month) ?? 0
    let low = averages.lowTemperature(for: month) ?? 0
    let precip = averages.precipitation(for: month) ?? 0
    print("Month \(month): \(low)° - \(high)°, \(precip)\" rain")
}

// Annual averages
print("Annual high: \(averages.annualHighTemperature)°")
print("Annual low: \(averages.annualLowTemperature)°")
print("Annual precip: \(averages.annualPrecipitation)\"")
```

### List Popular Areas

```swift
let repository = DependencyContainer.shared.areaRepository

let popular = try await repository.getPopularAreas(limit: 50, days: 3)

for area in popular {
    print("\(area.name) - \(area.requestCount) requests")
}
```

### List Areas by State

```swift
let repository = DependencyContainer.shared.areaRepository

let areas = try await repository.listAreasByAdminArea(
    countryISO: "USA",
    adminArea: "CA",
    days: 7
)

for area in areas {
    print(area.name)
    if let forecast = area.forecast {
        print("  Forecast included!")
    }
}
```

### List Countries and States

```swift
let countryRepo = DependencyContainer.shared.countryRepository

// Get all countries
let countries = try await countryRepo.listCountries()

// Get states/provinces
let adminAreas = try await countryRepo.listAdminAreas(
    countryISO: "USA",
    includeAreas: true,  // Include climbing areas
    days: 7              // Include forecasts
)

for adminArea in adminAreas {
    print("\(adminArea.name) - \(adminArea.areaCount) areas")
    if let areas = adminArea.areas {
        for area in areas {
            print("  - \(area.name)")
        }
    }
}
```

## Error Handling

All async methods can throw `APIError`:

```swift
do {
    let forecast = try await repository.getForecast(areaId: 123)
    // Success!
} catch APIError.networkError(let error) {
    print("Network error: \(error.localizedDescription)")
    // Show "Check your connection" message
} catch APIError.serverError(let statusCode, let message) {
    print("Server error \(statusCode): \(message ?? "Unknown")")
    // Show "Server is down" message
} catch APIError.decodingError(let error) {
    print("Parsing error: \(error.localizedDescription)")
    // Show "Invalid data" message
} catch APIError.cancelled {
    print("Request was cancelled")
    // Don't show error - user navigated away
} catch {
    print("Unknown error: \(error.localizedDescription)")
    // Show generic error message
}
```

## Testing

The protocol-based architecture makes testing easy:

```swift
import XCTest

final class ForecastViewModelTests: XCTestCase {
    
    @MainActor
    func testLoadForecast() async throws {
        // Create mock repository
        let mockRepo = MockAreaRepository()
        mockRepo.mockForecast = Forecast(/* ... test data ... */)
        
        // Create view model with mock
        let viewModel = AreaForecastViewModel(repository: mockRepo)
        
        // Load forecast
        viewModel.loadForecast(areaId: 123)
        
        // Wait for async operation
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert
        XCTAssertNotNil(viewModel.forecast)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
    }
}

// Mock repository for testing
final class MockAreaRepository: AreaRepositoryProtocol {
    var mockForecast: Forecast?
    var mockError: Error?
    
    func getForecast(areaId: Int, days: Int, tempUnit: String?) async throws -> Forecast {
        if let error = mockError {
            throw error
        }
        return mockForecast!
    }
    
    // ... implement other methods ...
}
```

## SwiftUI Previews

All views include preview support:

```swift
#Preview {
    NavigationStack {
        ForecastView(
            areaId: 123,
            areaName: "Yosemite Valley",
            repository: MockAreaRepository()
        )
    }
}
```

## Configuration

Switch between environments:

```swift
// In DependencyContainer or app initialization

// Production
let config = APIConfiguration.production(apiKey: "your-key")

// Staging
let config = APIConfiguration.staging(apiKey: "your-key")

// Local development
let config = APIConfiguration.local(apiKey: "your-key")

let container = DependencyContainer.custom(configuration: config)
```

## Performance Tips

1. **Request Cancellation**: ViewModels automatically cancel requests when deallocated
2. **Task Management**: Use `Task` for manual cancellation control
3. **Main Actor**: ViewModels are `@MainActor` so UI updates are automatic
4. **Debouncing**: Search view debounces input for 500ms to reduce API calls

## Troubleshooting

### "No data received from server"
- Check API key configuration
- Verify network connection
- Check base URL matches environment

### "Failed to parse server response"
- API may have changed format
- Check API version compatibility
- Look at debug console for raw response

### "Server error (401)"
- API key is invalid or expired
- Update API key in preferences

### Views not updating
- Ensure ViewModel is `@StateObject` not `@ObservedObject` at root
- Check that mutations happen on `@MainActor`

## Next Steps

1. **Add more views**: Create SwiftUI views for remaining features
2. **Add caching**: Implement local caching layer in repositories
3. **Add offline support**: Store data in CoreData or similar
4. **Add unit tests**: Test repositories and view models
5. **Add UI tests**: Test SwiftUI views

## Questions?

This architecture follows Apple's recommended patterns:
- WWDC 2021: "Swift Concurrency: Update a sample app"
- WWDC 2022: "Eliminate data races using Swift Concurrency"
- WWDC 2023: "SwiftUI data essentials"
