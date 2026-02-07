//
//  AreaSearchView.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import SwiftUI

/// Area search view
struct AreaSearchView: View {
    
    @StateObject private var viewModel: AreaSearchViewModel
    
    init(repository: AreaRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: AreaSearchViewModel(repository: repository))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search results or empty state
            if viewModel.isLoading {
                ProgressView("Searching...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                ModernForecastErrorView(error: error) {
                    viewModel.retry()
                }
            } else if viewModel.isEmpty {
                EmptySearchView()
            } else if viewModel.noResults {
                NoResultsView(query: viewModel.searchQuery)
            } else {
                AreaListView(areas: viewModel.areas, repository: viewModel.repositoryForChildViews)
            }
        }
        .navigationTitle("Search Areas")
        .searchable(
            text: $viewModel.searchQuery,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Enter area name or ZIP code"
        )
    }
}

/// Empty search state
struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Search for Climbing Areas")
                .font(.headline)
            
            Text("Enter an area name, ZIP code, or coordinates")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// No results view
struct NoResultsView: View {
    let query: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Results")
                .font(.headline)
            
            Text("No areas found for \"\(query)\"")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Try searching by:\n• Area name\n• State\n• ZIP code\n• Coordinates")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// List of areas
struct AreaListView: View {
    let areas: [Area]
    let repository: AreaRepositoryProtocol
    
    var body: some View {
        List(areas) { area in
            NavigationLink {
                ModernForecastView(
                    areaId: area.areaId,
                    areaName: area.name,
                    repository: repository
                )
            } label: {
                AreaRowView(area: area)
            }
        }
        .listStyle(.plain)
    }
}

/// Single area row
struct AreaRowView: View {
    let area: Area
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(area.name)
                .font(.headline)
            
            HStack(spacing: 8) {
                Text(area.adminAreaName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let forecast = area.forecast,
                   let daily = forecast.daily?.data.first,
                   let high = daily.temperatureHigh,
                   let low = daily.temperatureLow {
                    Text("•")
                        .foregroundColor(.secondary)
                    Text("\(Int(high))° / \(Int(low))°")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AreaSearchView(repository: DependencyContainer.shared.areaRepository)
    }
}
