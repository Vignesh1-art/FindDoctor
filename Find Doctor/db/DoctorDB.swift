//
//  DoctorDataDB.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 17/05/22.
//

import Foundation
protocol DoctorDB{
    func createData(_ docInfo : PersistableDoctorInfo)
    func getDataCount()->Int
    func retriveAllData()->[Doctor]?
    func retriveDataWithId(medicalid id:String)->Doctor?
    func retriveDataWithFilter(specializationFilter filter : String)->[Doctor]?
    func retriveDataWithFilter(medicalIdFilter filter : String)->[Doctor]?
    func updateSyncStatus(medicalid id:String,syncStatus status : Bool)throws
    func getSyncStatus(medicalid id:String)throws->Bool
}
