//
//  HomeViewController.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 14/08/2025.
//

import UIKit


class HomeViewController: UIViewController {
    @IBOutlet weak var moviesTableView: UITableView!
    let networkingService = NetworkingService.shared
    var movies: [ShowModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpTV()
        Task{
            await loadData()
        }
    }
    // MARK: - Functions
    func setUpTV(){
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        moviesTableView.separatorStyle = .none
        
    }
    func setUpNavBar(){
        navigationItem.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.boldSystemFont(ofSize: 34)
        ]
    }
    func loadData()async{
        do {
            let movies = try await networkingService.fetchShows(media: "movie", type: "trending")
            self.movies = movies
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
        } catch let error {
            print("error \(error)")
        }
    }
    
}
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.setMovie(movie: movie)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsVC = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
        let movie = self.movies[indexPath.row]
        movieDetailsVC.movie = movie
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
