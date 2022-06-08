//
//  API.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 23/05/22.
//

import Foundation
import UIKit

class API {
    let urlString:String
    let session = URLSession.shared
    
    init(URL url:String){
        self.urlString = url
    }
    
    func getTopDoctors(onTopDoctorsRecevied block:@escaping([Doctor]?,Error?)->Void){
        guard let url = URL(string: urlString+"/topdoctors") else {
            return
        }
        let semaphore = DispatchSemaphore(value: 0)
        let onComplete = {
            (data:Data?,urlresponse:URLResponse?,error:Error?)->Void in
            if let error = error {
                block(nil, error)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do{
                    let doctors = try decoder.decode([Doctor].self, from: data)
                    block(doctors,nil)
                }
                catch{
                    print("Json error")
                    block(nil,error)
                }
                
            }
            semaphore.signal()
        }
        let task = session.dataTask(with: url, completionHandler: onComplete)
        task.resume()
        semaphore.wait()
    }
    
    func syncDoctorInfoWithServer(doctorinfo : Doctor,database db:DoctorDB){
        guard let url = URL(string: urlString+"/sync") else {
            return
        }
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = "POST"
        do {
            let jsonData = try JSONEncoder().encode(doctorinfo)
            urlRequest.httpBody =  jsonData
        }
        catch {
            print("Json encoding error,unable to sync")
            return
        }
        let semaphore = DispatchSemaphore(value: 0)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: urlRequest){
            (data,urlresponse,error) in
            guard let urlres = urlresponse as? HTTPURLResponse else {
                return
            }
            let statusCode = urlres.statusCode
            if statusCode == 400 {
                print("Already synced")
                return
            }
            do {
                try db.setSyncStatus(medicalid: doctorinfo.medicalid, syncStatus: true)
            }catch{
                print("Could not set sync status , medicalid not found in local db")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    func downloadAllDoctorInfo(db:DoctorDB){
        guard let url = URL(string: urlString+"/download") else {
            return
        }
        let semaphore = DispatchSemaphore(value: 0)
        var doctors : [Doctor]?
        let onComplete = {
            (data:Data?,urlresponse:URLResponse?,error:Error?)->Void in
            if let _ = error {
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do{
                    doctors = try decoder.decode([Doctor].self, from: data)
                }
                catch{
                    print("Json error")
                }
                
            }
            semaphore.signal()
        }
        let task = session.dataTask(with: url, completionHandler: onComplete)
        task.resume()
        semaphore.wait() //waits till dataTask returns
        if let doctors = doctors {
            for doctor in doctors {
                let data = PersistableDoctorInfo(doctor: doctor, isSynced: true)
                try! db.createData(data)
            }
        }
    }
    func downloadImage(_ medicalid:String)->UIImage? {
        guard let url = URL(string: urlString+"/downloadimage?medicalid="+medicalid) else {
            return nil
        }
        var image:UIImage?
        let semaphore = DispatchSemaphore(value: 0)
        let onComplete = {
            (data:Data?,urlresponse:URLResponse?,error:Error?)->Void in
            if let _ = error {
                return
            }
            if let data = data {
                image = UIImage(data: data)
            }
            semaphore.signal()
        }
        let task = session.dataTask(with: url, completionHandler: onComplete)
        task.resume()
        semaphore.wait()
        return image
    }
}
