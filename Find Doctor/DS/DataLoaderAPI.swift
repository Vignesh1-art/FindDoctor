//
//  DataLoaderAPI.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 16/05/22.
//

import Foundation

class DataLoaderAPI {
    static let urlString = "http://127.0.0.1:3000/"
    static func fetchTopDoctors(_ onDoctorsDataFetched : @escaping([Doctor]?,Error?)->Void) {
        let requestString = "topdoctors"
        guard let url = URL(string: urlString+requestString) else {
            return
        }
        var doctors : [Doctor] = []
        let task = URLSession.shared.dataTask(with: url) {
            data,response,error in
            if error != nil{
                onDoctorsDataFetched(nil,error)
                return
            }
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let jsonData = try decoder.decode(TopDoctors.self, from: data)
                    doctors = jsonData.topDoctors
                    onDoctorsDataFetched(doctors,nil)
                }
                catch{
                    print("Error in parsing data from api")
                }
            }
        }
        task.resume()
    }
}
