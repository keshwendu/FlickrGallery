//
//  FlickrSearchViewControllerTests.swift
//  FlickrGalleryTests
//
//  Created by Keshwendu on 22/10/18.
//  Copyright © 2018 Keshwendu. All rights reserved.
//

import XCTest
@testable import FlickrGallery

class FlickrSearchViewControllerTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    private var searchViewController: FlickrSearchViewController? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        searchViewController = storyboard.instantiateViewController(withIdentifier: "FlickrSearchViewController") as? FlickrSearchViewController
        _ = searchViewController?.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImageCllectionCellOutletBindingSuccessfully() {
        let tData1 = TestData.SearchResponse.data1.rawValue.data(using: .utf8)

        do {
            let responseModel = try jsonDecoder.decode(FlickrSearchResponseModel.self, from: tData1!)
            searchViewController?.updateImageDataSource(withPhotosResponse: responseModel)
            let cell = searchViewController?.imageCollectionView.dequeueReusableCell(withReuseIdentifier: "FlickrImageCellIdentifier", for: IndexPath(row: 1, section: 0)) as? FlickrImageCollectionViewCell
            cell?.configureWith(photoModel: responseModel.photos.photo.first!, delegate: searchViewController!, atIndexPath: IndexPath(row: 0, section: 0))
            XCTAssertTrue(cell?.titleLabel.text == "Luxury Lifestyle : 5 Awesome & Expensive Motorhomes that will quench your taste for extravagance th...")
            
            cell?.configureWith(photoModel: responseModel.photos.photo.last!, delegate: searchViewController!, atIndexPath: IndexPath(row: 0, section: 0))
            XCTAssertTrue(cell?.titleLabel.text == "Painted cars")
        } catch {
            XCTFail("Failed to decode JSON")
        }
    }
    
    func testPaginationOfSearchView() {
        guard let searchViewController = searchViewController else {
            XCTFail("Search view controller not found")
            return
        }
        let searchText = "Kittens"
        searchViewController.searchBar.text = searchText
        searchViewController.searchFlickr(keyword: searchText)
        sleep(5)
        let i = searchViewController.imageCollectionView.numberOfItems(inSection: 0)
        searchViewController.paginateMoreIfNeeded(forIndexPath: IndexPath(row: i - 5, section: 0), andKeyword: searchText)
        sleep(5)
        searchViewController.imageCollectionView.reloadData()
        let k = searchViewController.imageCollectionView.numberOfItems(inSection: 0)
        XCTAssertTrue(k > i, "After pagination count should increase")
    }
}
