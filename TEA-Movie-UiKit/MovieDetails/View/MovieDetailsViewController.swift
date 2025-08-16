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
    // MARK: - Outlets
    @IBOutlet weak var dateMovie: UILabel!
    @IBOutlet weak var rattingView: CosmosView!
    @IBOutlet weak var movieLang: UILabel!
    @IBOutlet weak var votingText: UILabel!
    @IBOutlet weak var voteView: UIView!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var movie: ShowModel? = nil
    private let viewModel = MovieDetailsViewModel()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        setUpData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyRedOrangeGradient(to: voteView)
    }
    // MARK: - Functions
    private func setUpData(){
        if let movie = movie {
            movieName.text = movie.title ?? movie.name ?? "Unknown"
            movieDesc.text = movie.overview ?? ""
            votingText.text = "\(movie.popularity ?? 0.0)"
            dateMovie.text = "First Air Date: \(movie.firstAirDate ?? movie.releaseDate ?? "")"
            movieLang.text = movie.originalLanguage?.capitalized
            if let posterPath = movie.posterPath {
                gettingMovieImage(posterPath: posterPath)
            }
        }
        rattingView.settings.updateOnTouch = false
        rattingView.settings.fillMode = .half
        rattingView.settings.starSize = 20
        let fiveStar = ((movie?.voteAverage ?? 0) / 10.0) * 5.0
        rattingView.rating = fiveStar
    }
    private func gettingMovieImage(posterPath: String){
        let fileName = viewModel.posterPathFileName(from: posterPath)
        if let offlineImage = viewModel.loadImageFromDisk(fileName: fileName) {
            movieImage.image = offlineImage
        } else {
            if let url = URL(string: "\(Constants.IMAGE_BASE_URL)\(posterPath)") {
                movieImage.kf.indicatorType = .activity
                movieImage.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [.cacheOriginalImage, .transition(.fade(0.2))]) { [weak self] result in
                        guard let self = self else { return }
                        if case .success(let value) = result {
                            DispatchQueue.global(qos: .utility).async {
                                Task{
                                    await self.viewModel.saveImageToDisk(value.image, fileName: fileName)
                                }
                            }
                        }
                    }
            }
        }
    }
    private func setUpDesign(){
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
    
    // MARK: - Actions
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
