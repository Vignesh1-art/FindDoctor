//
//  DoctorCoreDataDB.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 10/05/22.
//

import Foundation
import UIKit
import CoreData

class DoctorCoreDataDB {
    private var appDelegate : AppDelegate
    private var managedObject : NSManagedObjectContext
    private var enitityDescription : NSEntityDescription
    
    init(){
        appDelegate = (UIApplication.shared.delegate)! as! AppDelegate
        managedObject = appDelegate.persistentContainer.viewContext
        enitityDescription = NSEntityDescription.entity(forEntityName: "DoctorInfo", in: managedObject)!
    }
    
    func createData(_ docInfo : Doctor) {
        let doc = NSManagedObject(entity: enitityDescription, insertInto: managedObject)
        doc.setValue(docInfo.name, forKey: "name")
        doc.setValue(docInfo.specialization, forKey: "specialization")
        doc.setValue(docInfo.yoe, forKey: "yoe")
        doc.setValue(docInfo.address, forKey: "address")
        doc.setValue(docInfo.medicalid, forKey: "medicalid")
        do {
            try managedObject.save()
            print("saved")
        }
        catch {
            print("Error ",error)
        }
        
    }
    
    func getDataCount()->Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DoctorInfo")
        do{
            let datas = try managedObject.fetch(fetchRequest) as! [NSManagedObject]
            return datas.count
        }
        catch{
            return 0
        }
    }
    
    func retriveAllData()->[Doctor]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DoctorInfo")
        do {
            let datas = try managedObject.fetch(fetchRequest) as! [NSManagedObject]
            var doctors = [Doctor]()
            for data in datas{
                var doctor : Doctor = Doctor(name: "", medicalid: "" ,specialization: "", address: "", yoe: 0)
                doctor.name = data.value(forKey: "name") as! String
                doctor.address = data.value(forKey: "address") as! String
                doctor.yoe = data.value(forKey: "yoe") as! Int32
                doctor.specialization = data.value(forKey: "specialization") as! String
                doctors.append(doctor)
            }
            return doctors
        }
        catch {
            print("Error in reading data ",error)
        }
        return nil
    }
    
    func retriveDataWithId(medicalid id:String)->Doctor? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DoctorInfo")
        fetchRequest.predicate = NSPredicate(format: "medicalid == %@",id)
        do{
            let datas = try managedObject.fetch(fetchRequest) as! [NSManagedObject]
            var doctor : Doctor = Doctor(name: "", medicalid :"", specialization: "", address: "", yoe: 0)
            let data = datas[0]
            doctor.name = data.value(forKey: "name") as! String
            doctor.medicalid = data.value(forKey: "medicalid") as! String
            doctor.address = data.value(forKey: "address") as! String
            doctor.yoe = data.value(forKey: "yoe") as! Int32
            doctor.specialization = data.value(forKey: "specialization") as! String
        }
        catch {
            print("error in fetching with medicalid ",error)
        }
        return nil
    }
    
    func retriveDataWithFilter(specializationFilter filter : String)->[Doctor]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DoctorInfo")
        fetchRequest.predicate = NSPredicate(format: "specialization contains %@",filter)
        do {
            let datas = try managedObject.fetch(fetchRequest) as! [NSManagedObject]
            var doctors = [Doctor]()
            for data in datas{
                var doctor : Doctor = Doctor(name: "", medicalid :"", specialization: "", address: "", yoe: 0)
                doctor.name = data.value(forKey: "name") as! String
                doctor.address = data.value(forKey: "address") as! String
                doctor.yoe = data.value(forKey: "yoe") as! Int32
                doctor.specialization = data.value(forKey: "specialization") as! String
                doctor.medicalid = data.value(forKey: "medicalid") as! String
                doctors.append(doctor)
            }
            return doctors
        }
        catch {
            print("Error in reading data ",error)
        }
        return nil
    }
    
    func retriveDataWithFilter(medicalIdFilter filter : String)->[Doctor]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DoctorInfo")
        fetchRequest.predicate = NSPredicate(format: "medicalid contains %@",filter)
        do {
            let datas = try managedObject.fetch(fetchRequest) as! [NSManagedObject]
            var doctors = [Doctor]()
            for data in datas{
                var doctor : Doctor = Doctor(name: "", medicalid :"", specialization: "", address: "", yoe: 0)
                doctor.name = data.value(forKey: "name") as! String
                doctor.address = data.value(forKey: "address") as! String
                doctor.yoe = data.value(forKey: "yoe") as! Int32
                doctor.specialization = data.value(forKey: "specialization") as! String
                doctor.medicalid = data.value(forKey: "medicalid") as! String
                doctors.append(doctor)
            }
            return doctors
        }
        catch {
            print("Error in reading data ",error)
        }
        return nil
    }
}
