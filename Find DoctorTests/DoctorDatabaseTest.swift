//
//  DoctorDatabaseTest.swift
//  Find DoctorTests
//
//  Created by Vignesh Shetty on 30/05/22.
//

import XCTest
@testable import Find_Doctor
class DoctorDatabaseTest: XCTestCase {
    var db : DoctorDB!
    var testData: [Doctor]=[]
    override func setUpWithError() throws {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "doctordummydata", ofType: "json") else {
            XCTFail("File not found")
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: pathString),options: .mappedIfSafe)
            testData = try JSONDecoder().decode([Doctor].self, from: data)
            XCTAssert(testData.count==4)
        }
        catch {
            XCTFail("Cannot get details from json , possible syntax error in json file")
            
        }
        db = DoctorRealmDB()
    }

    override func tearDownWithError() throws {
        
    }

    func testDBWrite() throws {
        let count = db.getDataCount()
        for doctor in testData {
            let persistableData = PersistableDoctorInfo(doctor: doctor, isSynced: true)
            do {
                try db.createData(persistableData)
            }
            catch {
                XCTFail("Failed to insert,medical id already found")
            }
        }
        let currentCount = db.getDataCount()
        XCTAssert(count+testData.count==currentCount)
    }
    
    func testRetriveData() throws {
        let doctor = db.retriveDataWithId(medicalid: "dummyid2")
        if let doctor = doctor {
            XCTAssert(doctor.name=="dummy2")
        }
        else{
            XCTFail("Failed to retrive data with id from db")
        }
        var doctors = db.retriveDataWithFilter(medicalIdFilter: "dummyid")
        if let doctors = doctors {
            XCTAssert(doctors.count==4)
        }
        else{
            XCTFail("Failed to retrive data with id filter from db")
        }
        doctors = db.retriveDataWithFilter(medicalIdFilter: "dummyid2")
        if let doctors = doctors {
            XCTAssert(doctors.count==1)
        }
        else{
            XCTFail("Failed to retrive data with id filter from db")
        }
        doctors = db.retriveDataWithFilter(medicalIdFilter: "")
        if let doctors = doctors {
            XCTAssert(doctors.count==0)
        }
        else{
            XCTFail("Failed to retrive data with id filter from db")
        }
        doctors = db.retriveDataWithFilter(specializationFilter: "dummyspltn2")
        if let doctors = doctors {
            XCTAssert(doctors.count==1)
        }
        else{
            XCTFail("Failed to retrive data with id filter from db")
        }

    }
    
    func testDBDelete() throws {
        let count = db.getDataCount()
        for doctor in testData {
            do {
                try db.deleteData(medicalID: doctor.medicalid)
            }
            catch{
                XCTFail("Failed to insert,medical not found")
            }
        }
        XCTAssert(db.getDataCount()==count-testData.count)
    }
    
    
    
}
