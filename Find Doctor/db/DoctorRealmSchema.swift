//
//  DoctorRealmSchema.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 17/05/22.
//

import Foundation
import RealmSwift
class DoctorRealmSchema : Object {
    @Persisted var name : String
    @Persisted var yoe : Int32
    @Persisted var address : String
    @Persisted var specialization : String
    @Persisted(primaryKey: true) var medicalid : String
    @Persisted var isSynced : Bool
    convenience init(doctor doc : PersistableDoctorInfo){
        self.init()
        self.name = doc.name
        self.yoe = doc.yoe
        self.address = doc.address
        self.specialization = doc.specialization
        self.medicalid = doc.medicalid
        self.isSynced = true
    }
    var doctorObject : Doctor {
        get {
            return Doctor(name: self.name, medicalid: self.medicalid, specialization: self.specialization, address: self.address, yoe: self.yoe)
        }
    }
}
