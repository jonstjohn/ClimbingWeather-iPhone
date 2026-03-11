//
//  ModernRootView.swift
//  climbingweather
//
//  Created on 3/10/26.
//

import SwiftUI

/// Root view for the modern climbing weather app
/// Provides navigation starting with area search
struct ModernRootView: View {
    
    let repository: AreaRepositoryProtocol
    
    var body: some View {
        TabView {
            // Search Tab
            AreaSearchView(repository: repository)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            // Popular Areas Tab (optional - you can implement this later)
            PopularAreasView(repository: repository)
                .tabItem {
                    Label("Popular", systemImage: "star.fill")
                }
        }
    }
}

/// Placeholder view for popular areas
/// You can enhance this later with actual popular areas from the API
struct PopularAreasView: View {
    let repository: AreaRepositoryProtocol
    @SwiftUI.State private var popularAreas: [PopularArea] = []
    @SwiftUI.State private var isLoading = false
    @SwiftUI.State private var error: Error?
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading popular areas...")
                } else if let error = error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Error")
                            .font(.headline)
                        
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Retry") {
                            loadPopularAreas()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if popularAreas.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("No Popular Areas")
                            .font(.headline)
                    }
                } else {
                    List(popularAreas) { area in
                        NavigationLink {
                            ModernForecastView(
                                areaId: area.areaId,
                                areaName: area.name,
                                repository: repository
                            )
                        } label: {
                            PopularAreaRow(area: area)
                        }
                    }
                }
            }
            .navigationTitle("Popular Areas")
            .navigationBarTitleDisplayMode(.large)
            .task {
                loadPopularAreas()
            }
            .refreshable {
                loadPopularAreas()
            }
        }
    }
    
    private func loadPopularAreas() {
        Task {
            isLoading = true
            error = nil
            
            do {
                popularAreas = try await repository.getPopularAreas(limit: 50, days: 1)
            } catch {
                self.error = error
            }
            
            isLoading = false
        }
    }
}

/// Row for displaying a popular area
struct PopularAreaRow: View {
    let area: PopularArea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(area.name)
                    .font(.headline)
                
                Spacer()
                
                if let requestCount = area.requestCount {
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                            .font(.caption)
                        Text("\(requestCount)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(locationText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Show current conditions if available
            if let forecast = area.forecast,
               let current = forecast.hourly?.data.first {
                HStack(spacing: 16) {
                    if let temp = current.temperature {
                        HStack(spacing: 4) {
                            Image(systemName: "thermometer.medium")
                                .font(.caption)
                            Text("\(Int(temp))°")
                                .font(.subheadline)
                        }
                    }
                    
                    if let icon = current.icon {
                        HStack(spacing: 4) {
                            WeatherIconView(icon: icon)
                                .frame(width: 20, height: 20)
                            if let summary = current.summary {
                                Text(summary)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .foregroundColor(.secondary)
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var locationText: String {
        var components: [String] = []
        
        if let adminAreaName = area.adminAreaName, !adminAreaName.isEmpty {
            components.append(adminAreaName)
        }
        
        if !area.country.isEmpty {
            components.append(area.country)
        }
        
        return components.joined(separator: ", ")
    }
}

// MARK: - Preview

#Preview {
    ModernRootView(repository: MockAreaRepository())
}
