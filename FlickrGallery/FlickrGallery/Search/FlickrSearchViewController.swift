//
//  ViewController.swift
//  FlickrGallery
//
//  Created by Keshwendu on 21/10/18.
//  Copyright © 2018 Keshwendu. All rights reserved.
//

import UIKit

class FlickrSearchViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var emptyMessageLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate let flickrImageCellIdentifier: String = "FlickrImageCellIdentifier"
    fileprivate let numberOfItemsPerRow: Int = 3
    fileprivate var currentPage: Int = 1
    fileprivate var totalPages: Int = 1
    
    fileprivate var photos: [FlickrPhotoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionColumnFlowLayout()
    }
    
    private func setupCollectionColumnFlowLayout() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let totalSpacings = layout.sectionInset.left
            + layout.sectionInset.right
            + (layout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let width = Int((imageCollectionView.bounds.width - totalSpacings) / CGFloat(numberOfItemsPerRow))
        layout.itemSize = CGSize(width: width, height: width + 35)
        imageCollectionView.collectionViewLayout = layout
    }
    
}

extension FlickrSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyMessageLabel.isHidden = (photos.count > 0)
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: FlickrImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: flickrImageCellIdentifier, for: indexPath) as! FlickrImageCollectionViewCell
        cell.configureWith(photoModel: photos[indexPath.row], delegate: self, atIndexPath: indexPath)
        
        paginateMoreIfNeeded(forIndexPath: indexPath, andKeyword: searchBar.text)
        
        return cell
    }
    
    func paginateMoreIfNeeded(forIndexPath indexPath: IndexPath, andKeyword keyword: String?) {
        if currentPage < totalPages, indexPath.row > self.photos.count - 50 {
            currentPage = currentPage + 1
            searchFlickr(keyword: keyword)
        }
    }
    
}

extension FlickrSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        ImageDownloadManager.shared.removeNotUsedPendingDataTask(forIndexPath: indexPath)
    }
}

extension FlickrSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchFlickr(keyword: searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        currentPage = 1
        totalPages = 1
        photos.removeAll()
        imageCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchFlickr(keyword: String?) {
        API.Flickr.Search(searchKeyword: keyword ?? "", page: currentPage).run { (result) in
            switch result {
            case .success(let photosResponse):
                self.updateImageDataSource(withPhotosResponse: photosResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateImageDataSource(withPhotosResponse photosResponse: FlickrSearchResponseModel) {
        self.totalPages = photosResponse.photos.pages
        self.photos.append(contentsOf: photosResponse.photos.photo)
        OperationQueue.main.addOperation {
            self.imageCollectionView.reloadData()
        }
    }
}

extension FlickrSearchViewController: ImageDownloadDelegate {
    func imageDownloadCompleted(forIndexPath indexPath: IndexPath, imageData: Data) {
        OperationQueue.main.addOperation {
            self.imageCollectionView.reloadItems(at: [indexPath])
        }
    }
}

