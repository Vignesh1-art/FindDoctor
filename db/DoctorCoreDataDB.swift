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
        do {
            try managedObject.save()
            print("saved")
        }
        catch {
            print("Error ",error)
        }
        
    }
    
    func retriveAllData()->[Doctor]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DoctorInfo")
        do {
            let datas = try managedObject.fetch(fetchRequest) as! [NSManagedObject]
            var doctors = [Doctor]()
            for data in datas{
                var doctor : Doctor = Doctor(name: "", specialization: "", address: "", yoe: 0)
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
    
    func retriveDataWithFilter(specializationFilter filter : String)->[Doctor]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DoctorInfo")
        fetchRequest.predicate = NSPredicate(format: "specialization contains %@",filter)
        do {
            let datas = try managedObject.fetch(fetchRequest) as! [NSManagedObject]
            var doctors = [Doctor]()
            for data in datas{
                var doctor : Doctor = Doctor(name: "", specialization: "", address: "", yoe: 0)
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
}
