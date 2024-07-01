//
//  CutomTableViewCell.swift
//  PhotoAlbum_With_API_CoreData
//
//  Created by Mandar Choudhary on 14/06/24.
//

import UIKit

class CutomTableViewCell: UITableViewCell {

    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var photoId: UILabel!
    @IBOutlet weak var albumId: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        albumView.layer.shadowColor = UIColor.systemGray.cgColor
        albumView.layer.shadowOffset = .zero
        albumView.layer.shadowOpacity = 10
        albumView.layer.shadowRadius = 10
        albumView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
