//
//  API.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 23/05/22.
//

import Foundation

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
    
    func syncDoctorInfoWithServer(doctorinfo : Doctor,block:@escaping(String?,Int)->Void){
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
            
            if let _ = error {
                block(nil,-1)
                print("Error while trying to sync with server")
                return
            }
            
            guard let data = data else {
                block(nil,-2)
                return
            }
            let response = String(data: data, encoding: String.Encoding.utf8)
            if let urlres = urlresponse as? HTTPURLResponse {
                block(response,urlres.statusCode)
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
                db.createData(data)
            }
        }
    }
}
