//
//  MovieDetailsViewController.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 15/08/2025.
//

import UIKit
import Kingfisher
import Cosmos
class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var dateMovie: UILabel!
    @IBOutlet weak var rattingView: CosmosView!
    @IBOutlet weak var movieLang: UILabel!
    @IBOutlet weak var votingText: UILabel!
    @IBOutlet weak var voteView: UIView!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    var movie: ShowModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        setUpData()
    }
    func setUpData(){
        if let movie = movie {
            movieName.text = movie.title ?? movie.name ?? "Unknown"
            movieDesc.text = movie.overview ?? ""
            votingText.text = "\(movie.popularity ?? 0.0)"
            dateMovie.text = "First Air Date: \(movie.firstAirDate ?? movie.releaseDate ?? "")"
            movieLang.text = movie.originalLanguage?.capitalized
            if let posterPath = movie.posterPath {
                let url = URL(string: "\(Constants.IMAGE_BASE_URL)\(posterPath)")
                movieImage.kf.setImage(with: url)
            }
        }
        rattingView.settings.updateOnTouch = false
        rattingView.settings.fillMode = .half
        rattingView.settings.starSize = 20
        let fiveStar = ((movie?.voteAverage ?? 0) / 10.0) * 5.0
        rattingView.rating = fiveStar
    }
    func setUpDesign(){
        self.navigationController?.navigationBar.isHidden = true
        setupImageShadow()
        voteView.layer.masksToBounds = true
        voteView.layer.cornerRadius = 15
    }
    private func setupImageShadow() {
        movieImage.layer.cornerRadius = 20
        movieImage.layer.masksToBounds = true
        
        movieImage.layer.shadowColor = UIColor.black.cgColor
        movieImage.layer.shadowOpacity = 0.25
        movieImage.layer.shadowOffset = CGSize(width: 0, height: 6)
        movieImage.layer.shadowRadius = 10
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyRedOrangeGradient(to: voteView)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func applyRedOrangeGradient(to view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        
        gradient.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemOrange.cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
}
