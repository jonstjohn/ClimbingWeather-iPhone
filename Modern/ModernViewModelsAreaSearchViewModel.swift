//
//  AreaSearchViewModel.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation
import Combine

/// ViewModel for area search
@MainActor
final class AreaSearchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var searchQuery = ""
    @Published var areas: [Area] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Private Properties
    
    private let repository: AreaRepositoryProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Properties
    
    /// Expose repository for passing to child views
    var repositoryForChildViews: AreaRepositoryProtocol {
        repository
    }
    
    // MARK: - Computed Properties
    
    var hasResults: Bool {
        !areas.isEmpty
    }
    
    var hasError: Bool {
        error != nil
    }
    
    var isEmpty: Bool {
        !isLoading && !hasResults && searchQuery.isEmpty
    }
    
    var noResults: Bool {
        !isLoading && !hasResults && !searchQuery.isEmpty
    }
    
    // MARK: - Initialization
    
    init(repository: AreaRepositoryProtocol) {
        self.repository = repository
        setupSearchDebouncing()
    }
    
    // MARK: - Private Methods
    
    /// Setup debounced search
    private func setupSearchDebouncing() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    /// Perform the actual search
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            areas = []
            return
        }
        
        // Cancel any existing search
        searchTask?.cancel()
        
        searchTask = Task {
            isLoading = true
            error = nil
            
            do {
                areas = try await repository.searchAreas(query: query)
            } catch {
                if !Task.isCancelled {
                    self.error = error
                    areas = []
                    print("❌ Search failed: \(error.localizedDescription)")
                }
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Public Methods
    
    /// Manually trigger a search (useful for pull-to-refresh)
    func search() {
        performSearch(query: searchQuery)
    }
    
    /// Clear search results
    func clear() {
        searchTask?.cancel()
        searchQuery = ""
        areas = []
        error = nil
        isLoading = false
    }
    
    /// Retry the last search
    func retry() {
        performSearch(query: searchQuery)
    }
    
    // MARK: - Deinitializer
    
    deinit {
        searchTask?.cancel()
    }
}
