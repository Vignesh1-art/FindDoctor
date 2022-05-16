//
//  DataLoaderAPI.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 16/05/22.
//

import Foundation

enum APIErrors : Error {
    case unknown
    case serverUnreachble
    case jsonError
    case invalidURL
}

class DataLoaderAPI {
    static let urlString = "http://127.0.0.1:3000/"
    static func fetchTopDoctors(_ onDoctorsDataFetched : @escaping([Doctor])->Void) throws -> Void {
        let requestString = "topdoctors"
        guard let url = URL(string: urlString+requestString) else {
            throw APIErrors.invalidURL
        }
        
        var apiError : APIErrors?
        var doctors : [Doctor] = []
        let task = URLSession.shared.dataTask(with: url) {
            data,response,error in
            let decoder = JSONDecoder()
            if let _ = error {
                apiError = APIErrors.serverUnreachble
                return
            }
            if let data = data {
                do {
                    let jsonData = try decoder.decode(TopDoctors.self, from: data)
                    doctors = jsonData.topDoctors
                    onDoctorsDataFetched(doctors)
                }
                catch{
                    print("Error in parsing data from api")
                    apiError = APIErrors.jsonError
                }
            }
        }
        task.resume()
        
        if let error = apiError {
            switch error {
            case .serverUnreachble:
                throw APIErrors.serverUnreachble
            case .jsonError:
                throw APIErrors.jsonError
            default:
                throw APIErrors.unknown
            }
        }
    }
}
