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
        cell.setMovie(movie: movie)
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
