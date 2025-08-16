//
//  MovieCell.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 15/08/2025.
//

import UIKit
import SDWebImage
import Cosmos
class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieCellView: UIView!
    @IBOutlet weak var CosmosView: CosmosView!
    @IBOutlet weak var dateOfMovieLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCellApperance()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func setUpCellApperance(){
        self.selectionStyle = .none
        movieCellView.layer.cornerRadius = 12
        movieCellView.layer.masksToBounds = false
        movieCellView.layer.shadowColor = UIColor.black.cgColor
        movieCellView.layer.shadowOpacity = 0.15
        movieCellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        movieCellView.layer.shadowRadius = 6
        movieImage.layer.cornerRadius = 15
        movieImage.contentMode = .scaleAspectFill
    }
    func setMovie(movie: ShowModel){
        self.movieImage.sd_setImage(with: URL(string: movie.posterImageURL))
        self.titlelabel.text = movie.title
        self.dateOfMovieLabel.text = movie.releaseDate ?? ""
        
        CosmosView.settings.updateOnTouch = false
        CosmosView.settings.fillMode = .half
        CosmosView.settings.starSize = 16
        let fiveStar = ((movie.voteAverage ?? 0) / 10.0) * 5.0
        CosmosView.rating = fiveStar
    }
    
}
