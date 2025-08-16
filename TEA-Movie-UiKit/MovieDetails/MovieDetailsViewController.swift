//
//  MovieDetailsViewController.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 15/08/2025.
//

import UIKit
import Kingfisher
class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    var movie: ShowModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            movieName.text = movie.title ?? movie.name ?? "Unknown"
            if let posterPath = movie.posterPath {
                let url = URL(string: "\(Constants.IMAGE_BASE_URL)\(posterPath)")
                movieImage.kf.setImage(with: url)
            }
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
