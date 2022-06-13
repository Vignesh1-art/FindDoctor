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
    
    func getTopDoctors()->[Doctor]?{
        guard let url = URL(string: urlString+"/topdoctors") else {
            return nil
        }
        var doctors : [Doctor]?
        let semaphore = DispatchSemaphore(value: 0)
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
        semaphore.wait()
        return doctors
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
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        do {
            try db.setSyncStatus(medicalid: doctorinfo.medicalid, syncStatus: true)
        }catch{
            print("Could not set sync status , medicalid not found in local db")
        }
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
                image = nil
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
    func uploadImage(_ image : UIImage,_ medicalid:String){
        guard let url = URL(string: urlString+"/upload") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=12345", forHTTPHeaderField: "Content-Type")
        request.setValue("text/plain", forHTTPHeaderField: "Accept")
        var httpBody:Data=Data()
        httpBody.append("\r\n--12345".data(using: .utf8)!)
        httpBody.append("\r\nContent-Disposition: form-data; name=\"f1\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        httpBody.append("value".data(using: .utf8)!)
        httpBody.append("\r\n--12345".data(using: .utf8)!)
        httpBody.append("\r\nContent-Disposition: form-data; name=\"image\"; filename=\"\(medicalid).png\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        httpBody.append(image.pngData()!)
        httpBody.append("\r\n--12345--".data(using: .utf8)!)
        request.httpBody = httpBody
        let onComplete = {
            (data:Data?,urlresponse:URLResponse?,error:Error?)->Void in
            //do nothing
            if let _ = error {
                print("Error occured")
            }
        }
        let task = session.dataTask(with: request, completionHandler: onComplete)
        task.resume()
    }
}
