//
//  HomeViewModel.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 16/08/2025.
//

import Foundation

@MainActor
final class HomeViewModel {
    
    // MARK: - Outputs
    private(set) var movies: [ShowModel] = []
    private(set) var favouriteMovies: [ShowModel] = []
    var onDataUpdated: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    var onFavouritesUpdated: (() -> Void)?
    
    private let networkingService: NetworkingService
    private let cacheFileName: String
    private let fileManager: FileManager
    
    init(networkingService: NetworkingService = .shared,
         cacheFileName: String = Constants.HomeCashedFileName,
         fileManager: FileManager = .default) {
        self.networkingService = networkingService
        self.cacheFileName = cacheFileName
        self.fileManager = fileManager
    }
    
    // MARK: - Fetch API
    func load() async {
        onLoading?(true)
        if !NetworkingService.isConnectedToInternet {
            onLoading?(false)
            if loadFromCache() {
                onDataUpdated?()
                return
                
            } else {
                onError?(NetworkingError.OfflineNoCache)
                return
            }
        }
        do {
            let fetchedMovies = try await networkingService.fetchShows(media: "movie", type: "trending")
            self.movies = fetchedMovies
            saveToCache()
            onDataUpdated?()
        } catch {
            if movies.isEmpty { onError?(error) }
        }
        onLoading?(false)
    }
    
    func numberOfRows() -> Int {
        movies.count
    }
    
    func movie(at indexPath: IndexPath) -> ShowModel {
        movies[indexPath.row]
    }
    func toggleFavourite(for movie: ShowModel) {
        if let index = favouriteMovies.firstIndex(where: { $0.id == movie.id }) {
            favouriteMovies.remove(at: index)
        } else {
            favouriteMovies.append(movie)
        }
        onFavouritesUpdated?()
    }
    
    func isFavourite(_ movie: ShowModel) -> Bool {
        favouriteMovies.contains { $0.id == movie.id }
    }
    
    // MARK: - Cache
    private func cacheFileURL() -> URL {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return caches.appendingPathComponent(cacheFileName)
    }
    
    private func loadFromCache() -> Bool {
        let url = cacheFileURL()
        guard fileManager.fileExists(atPath: url.path) else { return false }
        do {
            let data = try Data(contentsOf: url)
            let cacheData = try JSONDecoder().decode(HomeCacheModel.self, from: data)
            self.movies = cacheData.movies ?? []
            return true
        } catch {
            return false
        }
    }
    
    private func saveToCache() {
        let cacheData = HomeCacheModel(movies: self.movies)
        do {
            let data = try JSONEncoder().encode(cacheData)
            try data.write(to: cacheFileURL(), options: .atomic)
        } catch {
        }
    }
}
