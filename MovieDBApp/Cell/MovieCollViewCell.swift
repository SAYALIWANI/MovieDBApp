//
//  MovieCollViewCell.swift
//  MovieDBApp
//
//  Created by SayaliWani on 11/03/21.
//

import UIKit
import SDWebImage

class MovieCollViewCell: UICollectionViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        // Initialization code
    }
    
    func setupView(){
        viewBackground.layer.borderWidth = 2
        viewBackground.layer.borderColor = UIColor.lightGray.cgColor
        viewBackground.layer.cornerRadius = 8
    }

    func setupData(data : Movie, imageURL: String){
        lblTitle.text = data.originalTitle
        let imageURLPath = imageURL + (data.posterPath ?? "")
        imgView.sd_setImage(with: URL(string: imageURLPath), placeholderImage: UIImage(named: "placeholder"))

    }
    
}
