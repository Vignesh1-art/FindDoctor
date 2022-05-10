//
//  JsonReader.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 09/05/22.
//

import Foundation

struct TopDoctors:Decodable{
    var topDoctors : [Doctor]
}
struct Doctors : Decodable {
    var doctors : [Doctor]
}

struct Doctor : Decodable {
    var name : String
    var specialization : String
    var address : String
    var yoe : Int32
}


class LoadDataFromJSON {
    static func loadTopDoctors(_ filename : String)->[Doctor]? {
        if let url = Bundle.main.url(forResource: filename, withExtension: "json"){
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(TopDoctors.self, from: data)
                return jsonData.topDoctors
            }
            catch{
                print("error ",error)
            }
        }
        else{
            print("filename not found")
        }
        return nil
    }
    
    static func loadDoctors(_ filename : String)-> [Doctor]?{
        if let url = Bundle.main.url(forResource: filename, withExtension: "json"){
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Doctors.self, from: data)
                return jsonData.doctors
            }
            catch{
                print("error ",error)
            }
        }
        else{
            print("filename not found")
        }
        return nil
    }
}
