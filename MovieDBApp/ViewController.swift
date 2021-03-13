//
//  ViewController.swift
//  MovieDBApp
//
//  Created by SayaliWani on 09/03/21.
//

import UIKit
import DropDown

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let baseURL = "https://api.themoviedb.org/3/"
let appKey = "c9185b3442e2c100e294383f63e7d2f4&query"

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroudView    : UIView!
    @IBOutlet weak var lblHeader        : UILabel!
    @IBOutlet weak var txtField         : UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dropDown        : DropDown?
    var arrDropDown     = ["Most Popular Movies", "Least Popular Movies"]
    var movies          : [Movie]!
    var tempArray       : [Movie]!
    var allMovies       : [Movie]!
    var baseURLPathforLogo = ""
    var baseURLPathforPoster = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroudView.backgroundColor = UIColor(red: 00/255, green: 29/255, blue: 54/255, alpha: 1.0)
        addTopBar()
        txtField.delegate = self
        lblHeader.text = "Bollywood Movies"
        DispatchQueue.main.async {
            self.getResponse()
        }
        // Do any additional setup after loading the view.
    }
    
    func addTopBar(){
        
        if let get = getNavigationController(){
            get.setNavigationBarHidden(true, animated: true)
        }else{
            //customizeNavigationBar()
        }
        let vw = self.addTopBar(title: "MovieDBApp") as! NavigationBarView
        vw.btnBack.isHidden = true
        
        vw.btnMenuClicked = { sender in
            self.showDropDown(dataSource: self.arrDropDown)
        }
        
        dropDown = DropDown()
        dropDown?.anchorView = vw.btnMenu
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            dropDown?.hide()
            switch index{
            case 0 :
                self.MostPopularity()
                print("Most Popular")
            case 1 :
                self.LeastPopularity()
                print("Least Popular")
            default:
                return
            }
        }
        dropDown?.direction = .bottom
        dropDown?.backgroundColor = UIColor.white
        dropDown?.textColor = UIColor.orange
        dropDown?.bottomOffset = CGPoint(x: 0, y:(dropDown?.anchorView?.plainView.bounds.height)!)
        dropDown?.topOffset = CGPoint(x: 0, y:-(dropDown?.anchorView?.plainView.bounds.height)!)
        dropDown?.cornerRadius = 10
    }
    
    func registerNib(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MovieCollViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollViewCell")
        collectionView.reloadData()
    }
    
    
    func setupTablevView(){
        DispatchQueue.main.async {
            self.registerNib()
            self.collectionView.reloadData()
        }
    }
    
    func getResponse(){
        
        let imageURLString = baseURL + "configuration?api_key=" + appKey
        
        let urlString = baseURL + "search/movie?api_key=" + appKey + "&query=bollywood"
        let session = URLSession.shared
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: urlString) as URL?
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData// .reloadIgnoringLocalCacheData
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
                
                let data1 = self.convertToDictionary(text : str)
                print("dict1 : \(String(describing: data1))")
                let mainData = ResponseData(fromDictionary: data1 ?? [String : Any]())
                print("mainData : \(mainData)")
                self.movies = mainData.results
                self.allMovies = mainData.results
                DispatchQueue.main.async {
                    self.getImagePath()
                }
            }
            else{
                print("Cannot read data")
            }
        }
        task.resume()
    }
    
    func getImagePath(){
        
        let imageURLString = baseURL + "configuration?api_key=" + appKey
        let session = URLSession.shared
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: imageURLString) as URL?
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData// .reloadIgnoringLocalCacheData
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
                
                let data1 = self.convertToDictionary(text : str)
                print("dict1 : \(String(describing: data1))")
                let imageData = ImageResources(fromDictionary: data1 ?? [String : Any]())
                print("imageData : \(imageData)")
                self.baseURLPathforLogo = imageData.images.secureBaseUrl + imageData.images.profileSizes[2] // ?? "w185")
                self.baseURLPathforPoster = imageData.images.secureBaseUrl + imageData.images.posterSizes[2] //?? "w342")
                self.setupTablevView()
            }
            else{
                print("Cannot read data")
            }
        }
        task.resume()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func openMovieInfoVC(data : Movie){
        let infoVC = mainStoryboard.instantiateViewController(withIdentifier: "MovieInfoVC") as! MovieInfoVC
        infoVC.setupData(data : data, imageLogoURL: baseURLPathforLogo, imagePosterURL: baseURLPathforPoster)
        self.next(vc: infoVC)
    }
    
    func showDropDown(dataSource: [String]){
        dropDown?.dataSource = arrDropDown
        dropDown?.show()
    }
    
    //MARK : Sorting functions
    func MostPopularity(){

        if self.movies != nil{
            tempArray = self.movies.sorted(by: { $0.popularity ?? 0 >  $1.popularity ?? 0})
        }
        for popularity in tempArray{
            print(popularity.popularity)
        }
        DispatchQueue.main.async {
            self.movies = self.tempArray
            self.collectionView.reloadData()
        }
    }
    
    func LeastPopularity(){
        
        if self.movies != nil{
            tempArray = self.movies.sorted(by: { $0.popularity ?? 0 <  $1.popularity ?? 0})
        }
        for popularity in tempArray{
            print(popularity.popularity)
        }
        DispatchQueue.main.async {
            self.movies = self.tempArray
            self.collectionView.reloadData()
        }
    }
}


extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lcCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollViewCell", for: indexPath) as! MovieCollViewCell
        lcCell.setupData(data: movies[indexPath.row], imageURL: self.baseURLPathforLogo)
        return lcCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openMovieInfoVC(data : movies[indexPath.row])
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.frame.size.width / 2) - 20 , height: 160)
    }
}

extension ViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        let filteredMovies = self.movies.filter { (movie) -> Bool in
            return movie.originalTitle.localizedCaseInsensitiveContains(txtAfterUpdate)
        }
        
        DispatchQueue.main.async {
            self.movies = txtAfterUpdate == "" ? self.allMovies : filteredMovies
            self.collectionView.reloadData()
        }
        return true
    }
}


//url2 = "https://api.themoviedb.org/3/search/movie?api_key=c9185b3442e2c100e294383f63e7d2f4&query=bollywood"
