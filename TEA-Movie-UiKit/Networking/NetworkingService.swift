//
//  NetworkingService.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 15/08/2025.
//

import Foundation
import Network


class NetworkingService{
    static let shared = NetworkingService()
    private init() {}
    // MARK: - fetch Upcoming movies
    func fetchUpcomingMovies() async throws -> [ShowModel] {
        let urlString = "\(Constants.BASE_URL)3/movie/upcoming?api_key=\(Constants.API_KEY)"
        let fetchURL = URL(string: urlString)
        guard let fetchURL = fetchURL else {
            throw NetworkingError.invalidURL
        }
        print("Fetch URL: \(fetchURL)")
        let (data, respo) = try await URLSession.shared.data(from: fetchURL)
        // Check for HTTP response status code
        guard let httpResponse = respo as? HTTPURLResponse else {
            throw NetworkingError.responseError
        }
        if !(200...299).contains(httpResponse.statusCode) {
            if let errorMessage = try? JSONDecoder().decode(ResponseError.self, from: data) {
                let message = "status code : ( \(errorMessage.statusCode ?? 400) ) - \(errorMessage.statusMessage ?? "")"
                print(" \(message)")
                throw NetworkingError.unknownError(message)
            } else {
                throw NetworkingError.responseError
            }
        }
        do {
            let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            return decodedResponse.results ?? []
        } catch  {
            print("Decoding Error in upcoming movies: \(error)")
            throw NetworkingError.dataDecodingError(error)
        }
    }
}
// MARK: - NetworkingService
extension NetworkingService {
    static var isConnectedToInternet: Bool {
        let monitor = NWPathMonitor()
        var connected = false
        let semaphore = DispatchSemaphore(value: 0)
        
        monitor.pathUpdateHandler = { path in
            connected = path.status == .satisfied
            semaphore.signal()
            monitor.cancel()
        }
        monitor.start(queue: .global())
        _ = semaphore.wait(timeout: .now() + 2)
        return connected
    }
}
