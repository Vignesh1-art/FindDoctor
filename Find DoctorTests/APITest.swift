//
//  APITest.swift
//  Find DoctorTests
//
//  Created by Vignesh Shetty on 30/05/22.
//

import XCTest
@testable import Find_Doctor

class APITest: XCTestCase {
    var api:API!
    override func setUpWithError() throws {
       api = API(URL: "http://127.0.0.1:5000")
    }

    override func tearDownWithError() throws {
        
    }
    
    func testImageDownloader() {
        api.downloadImage("1111")
    }
    
    
}
