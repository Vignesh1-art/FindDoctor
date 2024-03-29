//
//  DoctorRealmData.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 17/05/22.
//

import Foundation
import RealmSwift

enum RealmDBError : Error{
    case primaryKeyAlreadyFound
    case primaryKeynotFound
    case notFound
}

class DoctorRealmDB : DoctorDB{
    var realmdb : Realm?
    init(){
        do{
            realmdb = try Realm()
        }
        catch{
            print("Realm unable to initialize")
        }
    }
    
    func createData(_ docInfo : PersistableDoctorInfo) throws {
        guard let db = realmdb else {
            return
        }
        if let _ = db.object(ofType: DoctorRealmSchema.self,forPrimaryKey: docInfo.medicalid){
            throw RealmDBError.primaryKeyAlreadyFound
        }
        
        try! db.write{
            let doctorInfo = DoctorRealmSchema(doctor: docInfo)
            db.add(doctorInfo)
        }
    }
    
    func deleteData(medicalID id : String) throws {
        guard let db = realmdb else {
            return
        }
        if let doctorData = db.object(ofType: DoctorRealmSchema.self,forPrimaryKey: id){
            try db.write{
                db.delete(doctorData)
            }
        }
        else{
            throw RealmDBError.primaryKeynotFound
        }
    }
    
    func getDataCount()->Int {
        guard let db = realmdb else {
            return 0
        }
        let data = db.objects(DoctorRealmSchema.self)
        return data.count
    }
    func retriveAllData() -> [Doctor]? {
        guard let db = realmdb else {
            return nil
        }
        let data = db.objects(DoctorRealmSchema.self)
        var doctor : [Doctor] = []
        for d in data {
            doctor.append(d.doctorObject)
        }
        return doctor
    }
    
    func retriveDataWithId(medicalid id: String) -> Doctor? {
        guard let db = realmdb else {
            return nil
        }
        let doctorData = db.object(ofType: DoctorRealmSchema.self,forPrimaryKey: id)
        return doctorData?.doctorObject
    }
    
    func retriveDataWithFilter(specializationFilter filter: String) -> [Doctor]? {
        guard let db = realmdb else {
            return nil
        }
        let allDoctors = db.objects(DoctorRealmSchema.self)
        let doctors = allDoctors.where{
            $0.specialization.contains(filter)
        }
        var docs : [Doctor] = []
        for doc in doctors {
            docs.append(doc.doctorObject)
        }
        return docs
    }
    
    func retriveDataWithFilter(medicalIdFilter filter: String) -> [Doctor]? {
        guard let db = realmdb else {
            return nil
        }
        let allDoctors = db.objects(DoctorRealmSchema.self)
        let doctors = allDoctors.where{
            $0.medicalid.contains(filter)
        }
        var docs : [Doctor] = []
        for doc in doctors {
            docs.append(doc.doctorObject)
        }
        return docs
    }
    
    func setSyncStatus(medicalid id:String,syncStatus status : Bool ) throws {
        let doctor = realmdb?.object(ofType: DoctorRealmSchema.self, forPrimaryKey: id)
        if let doctor = doctor {
            try! realmdb?.write{
                doctor.isSynced = status
            }
            return
        }
        throw RealmDBError.notFound
    }
    
    func getSyncStatus(medicalid id:String)throws ->Bool  {
        let doctor = realmdb?.object(ofType: DoctorRealmSchema.self, forPrimaryKey: id)
        if let doctor = doctor {
            return doctor.isSynced
        }
        throw RealmDBError.notFound
    }
}
