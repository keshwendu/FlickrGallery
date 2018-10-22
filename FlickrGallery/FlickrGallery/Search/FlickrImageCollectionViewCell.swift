//
//  FlickrImageCollectionViewCell.swift
//  FlickrGallery
//
//  Created by Keshwendu on 21/10/18.
//  Copyright © 2018 Keshwendu. All rights reserved.
//

import UIKit

class FlickrImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        imageView.image = UIImage(imageLiteralResourceName: "imagePlaceholder")
        titleLabel.text = ""
        super.prepareForReuse()
    }
    
    func configureWith(photoModel: FlickrPhotoModel, delegate: ImageDownloadDelegate, atIndexPath indexPath: IndexPath) {
        if let imgUrl = photoModel.imageUrl, let imgData = ImageDownloadManager.shared.load(url: imgUrl, forIndexPath: indexPath, delegate: delegate), let img = UIImage(data: imgData) {
            self.imageView.image = img
        }
        self.titleLabel.text = photoModel.title
    }
}

