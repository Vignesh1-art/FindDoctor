//
//  JsonReader.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 09/05/22.
//

import Foundation

struct PersistableDoctorInfo {
    var name : String
    var medicalid : String
    var specialization : String
    var address : String
    var yoe : Int32
    var isSynced : Bool
    
    init(doctor:Doctor,isSynced:Bool){
        self.name = doctor.name
        self.medicalid = doctor.medicalid
        self.specialization = doctor.specialization
        self.address = doctor.address
        self.yoe = doctor.yoe
        self.isSynced = isSynced
    }
}


struct Doctor : Decodable,Encodable {
    var name : String
    var medicalid : String
    var specialization : String
    var address : String
    var yoe : Int32
}


