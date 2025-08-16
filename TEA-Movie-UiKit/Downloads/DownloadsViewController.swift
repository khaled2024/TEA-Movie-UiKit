//
//  DownloadsViewController.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 14/08/2025.
//

import UIKit

class DownloadsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emptyView: UIImageView!
    @IBOutlet weak var favTableView: UITableView!
    var favourites: [ShowModel] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTV()
        if favourites.isEmpty{
            emptyView.isHidden = false
            favTableView.isHidden = true
        }else{
            emptyView.isHidden = true
            favTableView.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Funcs
    func setUpTV(){
        navigationItem.title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        favTableView.delegate = self
        favTableView.dataSource = self
        favTableView.register(UINib(nibName: "MovieCell", bundle: nil),
                              forCellReuseIdentifier: "MovieCell")
        favTableView.separatorStyle = .none
    }
}
// MARK: - UITableViewDelegate
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = favourites[indexPath.row]
        cell.setMovie(movie: movie, isFavourite: true)
        cell.favBtn.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = favourites[indexPath.row]
        let details = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
        details.movie = movie
        navigationController?.pushViewController(details, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
