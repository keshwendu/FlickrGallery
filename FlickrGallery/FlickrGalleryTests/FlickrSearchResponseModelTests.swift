//
//  FlickrSearchResponseModelTests.swift
//  FlickrGalleryTests
//
//  Created by Keshwendu on 22/10/18.
//  Copyright © 2018 Keshwendu. All rights reserved.
//

import XCTest
@testable import FlickrGallery

class FlickrSearchResponseModelTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    
    func testFlickrPhotoModelShouldParseCorrectJSONSuccessfully() {
        let tData1 = TestData.SearchResponse.data1.rawValue.data(using: .utf8)
        XCTAssertNoThrow(try jsonDecoder.decode(FlickrSearchResponseModel.self, from: tData1!))
        do {
            let responseModel = try jsonDecoder.decode(FlickrSearchResponseModel.self, from: tData1!)
            XCTAssertTrue(responseModel.stat == "ok", "Check stat is ok")
            XCTAssertTrue(responseModel.photos.pages == 11153, "Checks page count is correct")
            XCTAssertTrue(responseModel.photos.photo.first?.owner == "153732821@N05", "Check owner is correct")
        } catch {
            XCTFail("Failed to decode JSON")
        }
        
        let tData2 = TestData.SearchResponse.data2.rawValue.data(using: .utf8)
        XCTAssertNoThrow(try jsonDecoder.decode(FlickrSearchResponseModel.self, from: tData2!))
        do {
            let responseModel = try jsonDecoder.decode(FlickrSearchResponseModel.self, from: tData2!)
            XCTAssertTrue(responseModel.stat == "ok", "Check stat is ok for second data")
            XCTAssertTrue(responseModel.photos.pages == 3220, "Checks page count is correct for second data")
            XCTAssertTrue(responseModel.photos.photo.first?.owner == "142965537@N07", "Check owner is correct for second data")
        } catch {
            XCTFail("Failed to decode JSON")
        }
    }
    
    func testFlickrPhotoModelShouldNotParseCorruptedJSON() {
        let tData1 = TestData.SearchResponse.invalidData1.rawValue.data(using: .utf8)
        XCTAssertThrowsError(try jsonDecoder.decode(FlickrSearchResponseModel.self, from: tData1!), "Check should throw parsing error")
        
        let tData2 = TestData.SearchResponse.invalidData2.rawValue.data(using: .utf8)
        XCTAssertThrowsError(try jsonDecoder.decode(FlickrSearchResponseModel.self, from: tData2!), "Check should throw parsing error")
    }
}
