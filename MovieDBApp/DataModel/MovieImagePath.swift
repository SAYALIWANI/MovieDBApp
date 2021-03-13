//
//  MovieImagePath.swift
//  MovieDBApp
//
//  Created by SayaliWani on 12/03/21.
//

import Foundation


class MovieImagePath : NSObject{

    var backdropSizes   : [String]!
    var baseUrl         : String!
    var logoSizes       : [String]!
    var posterSizes     : [String]!
    var profileSizes    : [String]!
    var secureBaseUrl   : String!
    var stillSizes      : [String]!

    init(fromDictionary dictionary: [String:Any]){
        baseUrl = dictionary["base_url"] as? String
        secureBaseUrl = dictionary["secure_base_url"] as? String
        logoSizes             = [String]()
        if let logoSizesArray = dictionary["logo_sizes"] as? [String]{
            for dic in logoSizesArray{
                logoSizes.append(dic)
            }
        }
        posterSizes             = [String]()
        if let logoSizesArray = dictionary["poster_sizes"] as? [String]{
            for dic in logoSizesArray{
                posterSizes.append(dic)
            }
        }
        profileSizes             = [String]()
        if let logoSizesArray = dictionary["profile_sizes"] as? [String]{
            for dic in logoSizesArray{
                profileSizes.append(dic)
            }
        }
    }

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if baseUrl != nil{
            dictionary["base_url"] = baseUrl
        }
        if secureBaseUrl != nil{
            dictionary["secure_base_url"] = secureBaseUrl
        }
        
        if logoSizes != nil{
            var stringElements = [String]()
            for resultsElement in logoSizes {
                stringElements.append(resultsElement)
            }
            dictionary["logo_sizes"] = stringElements
        }
        
        if posterSizes != nil{
            var stringElements = [String]()
            for resultsElement in posterSizes {
                stringElements.append(resultsElement)
            }
            dictionary["poster_sizes"] = stringElements
        }
        
        if profileSizes != nil{
            var stringElements = [String]()
            for resultsElement in profileSizes {
                stringElements.append(resultsElement)
            }
            dictionary["profile_sizes"] = stringElements
        }
        
        return dictionary
    }

    
}
