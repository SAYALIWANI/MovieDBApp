//
//  ImageResources.swift
//  MovieDBApp
//
//  Created by SayaliWani on 12/03/21.
//

import Foundation

class ImageResources : NSObject {

    var changeKeys : [String]!
    var images     : MovieImagePath!

    init(fromDictionary dictionary: [String:Any]){
        if let imagesData = dictionary["images"] as? [String:Any]{
            images = MovieImagePath(fromDictionary: imagesData)
        }
    }

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if images != nil{
            dictionary["images"] = images.toDictionary()
        }
        return dictionary
    }

}
