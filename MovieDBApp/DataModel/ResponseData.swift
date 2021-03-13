//
//  ResponseData.swift
//  MovieDBApp
//
//  Created by SayaliWani on 11/03/21.
//

import Foundation

class ResponseData : NSObject{
    
    var page         : Int!
    var results      : [Movie]!
    var totalPages   : Int!
    var totalResults : Int!
    

    init(fromDictionary dictionary: [String:Any]){
        page                = dictionary["page"] as? Int
        totalPages          = dictionary["total_pages"] as? Int
        totalResults        = dictionary["total_results"] as? Int
        results             = [Movie]()
        
        if let resultsArray = dictionary["results"] as? [[String:Any]]{
            for dic in resultsArray{
                let value = Movie(fromDictionary: dic)
                results.append(value)
            }
        }
    }
    
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if page != nil{
            dictionary["page"] = page
        }
        if totalPages != nil{
            dictionary["total_pages"] = totalPages
        }
        if totalResults != nil{
            dictionary["total_results"] = totalResults
        }
        if results != nil{
            var dictionaryElements = [[String:Any]]()
            for resultsElement in results {
                dictionaryElements.append(resultsElement.toDictionary())
            }
            dictionary["results"] = dictionaryElements
        }
        return dictionary
    }
}

