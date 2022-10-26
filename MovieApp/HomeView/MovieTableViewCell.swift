//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Kerem Özdemir on 25.10.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    var imdbID:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.movieName.font = UIFont(name: "Roboto-Bold", size: 22)
        self.type.font = UIFont(name: "Roboto-Light", size: 20)
        self.movieYear.font = UIFont(name: "Roboto-Light", size: 20)
        self.movieName.numberOfLines = 0
    }
    
    func imageFromUrl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.movieImage.image = image
                    }
                }
            }
        }
    }
}

