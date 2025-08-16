//
//  HomeViewController.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 14/08/2025.
//

import UIKit


class HomeViewController: UIViewController {
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpTV()
        bindViewModel()
        Task {
            await viewModel.load()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
              image: UIImage(systemName: "heart.fill"),
              style: .plain,
              target: self,
              action: #selector(openFavourites)
          )
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }
    
    @objc private func openFavourites() {
        let favVC = DownloadsViewController(nibName: "DownloadsViewController", bundle: nil)
        favVC.favourites = viewModel.favouriteMovies
        navigationController?.pushViewController(favVC, animated: true)
    }
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.moviesTableView.reloadData()
        }
        viewModel.onLoading = { isLoading in
            if isLoading {
                self.loadingView.startAnimating()
            } else {
                self.loadingView.stopAnimating()
            }
        }
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        viewModel.onFavouritesUpdated = { [weak self] in
            guard let self else{return}
            self.moviesTableView.reloadData()
        }
    }
    
}
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = viewModel.movie(at: indexPath)
        let isFav = viewModel.isFavourite(movie)
        cell.delegate = self
        cell.setMovie(movie: movie,isFavourite: isFav)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsVC = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
        let movie = viewModel.movie(at: indexPath)
        movieDetailsVC.movie = movie
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}

extension HomeViewController: MovieCellDelegate{
    func didTapFavourite(on cell: MovieCell) {
        print("tapped")
        guard let indexPath = moviesTableView.indexPath(for: cell) else { return }
        let movie = viewModel.movie(at: indexPath)
        viewModel.toggleFavourite(for: movie)
        moviesTableView.reloadRows(at: [indexPath], with: .none)
        print("fav movies \(viewModel.favouriteMovies)")
    }
    
}
