//
//  MovieInfoTblViewCell.swift
//  MovieDBApp
//
//  Created by SayaliWani on 13/03/21.
//

import UIKit

class MovieInfoTblViewCell: UITableViewCell {

    @IBOutlet weak var headerLbl        : UILabel!
    @IBOutlet weak var imgviewPoster    : UIImageView!
    @IBOutlet weak var lblReleaseDate   : UILabel!
    @IBOutlet weak var lblRating        : UILabel!
    @IBOutlet weak var UserRatingView   : FloatRatingView!
    @IBOutlet weak var lblOverView      : UILabel!
    @IBOutlet weak var imgViewThumbnail : UIImageView!
    var movieData : Movie!
    var baseURLPathforLogo = ""
    var baseURLPathforPoster = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        
    }
    
    func setupData(data : Movie, imageLogoURL: String, imagePosterURL: String){
        movieData = data
        baseURLPathforLogo = imageLogoURL
        baseURLPathforPoster = imagePosterURL
        setupView()
    }
    
    func setupView(){
        
        headerLbl.text = movieData.originalTitle
        
        let imagePosterPath = baseURLPathforPoster + (movieData.posterPath ?? "")
        imgviewPoster.sd_setImage(with: URL(string: imagePosterPath), placeholderImage: UIImage(named: "placeholder"))
        
        let imageLogoPath = baseURLPathforLogo + (movieData.posterPath ?? "")
        imgViewThumbnail.sd_setImage(with: URL(string: imageLogoPath), placeholderImage: UIImage(named: "placeholder"))
        
        let date = movieData.releaseDate ?? ""
        lblReleaseDate.text = "Release Date : " + "\(date)"
        
        if let voteAvg = movieData.voteAverage{
            UserRatingView.rating = voteAvg
        }
        
        let headerText = "Overview \n"
        var overViewText = ""
        if let movieOverview = movieData.overview{
            overViewText = movieOverview
        }
        
        let attributedText = NSMutableAttributedString()
        let firstString = NSMutableAttributedString( string: headerText, attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 24.0)!, NSAttributedString.Key.foregroundColor : UIColor.black])
        
        let secondString = NSMutableAttributedString(string: overViewText ,attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 18.0)!,  NSAttributedString.Key.foregroundColor : UIColor(red: 00/255, green: 29/255, blue: 54/255, alpha: 1.0)])
        
        attributedText.append(firstString)
        attributedText.append(secondString)
        
        lblOverView.attributedText = attributedText

    }
    
}
