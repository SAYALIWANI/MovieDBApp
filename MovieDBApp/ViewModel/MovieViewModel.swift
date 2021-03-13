//
//  MovieViewModel.swift
//  MovieDBApp
//
//  Created by SayaliWani on 13/03/21.
//

import Foundation

let baseURL = "https://api.themoviedb.org/3/"
let appKey = "c9185b3442e2c100e294383f63e7d2f4&query"

protocol MovieModelDelegate : class {
        var MoviesData:[Movie]? { get set }
        var imagePathURL:MovieImagePath? { get set }
}

class MovieViewModel {
    weak var delegate : MovieModelDelegate?
    var MoviesData : Array<Movie> = []
    var imagePathURL : MovieImagePath!
    
    func CallMovieData(){
    
        let urlString = baseURL + "search/movie?api_key=" + appKey + "&query=bollywood"
        let session = URLSession.shared
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: urlString) as URL?
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if(data == nil){
                print("ERROR")
            }
            if let jsonData = data{
                let str = String(decoding: jsonData, as: UTF8.self)
                if str.isEmpty{
                    return
                }
                
                let data1 = str.convertToDictionary()
                let mainData = ResponseData(fromDictionary: data1 ?? [String : Any]())
                print("mainData : \(mainData)")
                self.MoviesData.append(contentsOf: mainData.results)
                self.delegate?.MoviesData = self.MoviesData
                DispatchQueue.main.async {
                    self.callImagePath()
                }
            }
            else{
                print("Cannot read data")
            }
        }
        task.resume()
    }
    
    
    func callImagePath(){
        
        let imageURLString = baseURL + "configuration?api_key=" + appKey
        let session = URLSession.shared
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: imageURLString) as URL?
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if(data == nil){
                print("ERROR")
            }
            if let jsonData = data{
                let str = String(decoding: jsonData, as: UTF8.self)
                if str.isEmpty{
                    return
                }
                
                let data1 = str.convertToDictionary()
                let imageData = ImageResources(fromDictionary: data1 ?? [String : Any]())
                print("imageData : \(imageData)")
                self.imagePathURL = imageData.images
                self.delegate?.imagePathURL = self.imagePathURL
            }
            else{
                print("Cannot read data")
            }
        }
        task.resume()
    }
}
