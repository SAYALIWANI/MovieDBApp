//
//  ViewController.swift
//  MovieDBApp
//
//  Created by SayaliWani on 09/03/21.
//

import UIKit
import DropDown

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

class ViewController: UIViewController, MovieModelDelegate {
    
    @IBOutlet weak var backgroudView    : UIView!
    @IBOutlet weak var lblHeader        : UILabel!
    @IBOutlet weak var txtField         : UITextField!
    @IBOutlet weak var collectionView   : UICollectionView!
    
    var MovieVM         = MovieViewModel()
    var dropDown        : DropDown?
    var arrDropDown     = ["Most Popular Movies", "Least Popular Movies"]
    var movies          : [Movie]!
    var tempArray       : [Movie]!
    var allMovies       : [Movie]!
    var baseURLPathforLogo = ""
    var baseURLPathforPoster = ""
    
    var MoviesData : [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.setMoviesData()
            }
        }
    }
    
    var imagePathURL: MovieImagePath? {
        didSet {
            DispatchQueue.main.async {
                self.setImagePathData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroudView.backgroundColor = UIColor(red: 00/255, green: 29/255, blue: 54/255, alpha: 1.0)
        addTopBar()
        txtField.delegate = self
        lblHeader.text = "Bollywood Movies"
        self.MovieVM.delegate = self
        DispatchQueue.main.async {
            self.MovieVM.CallMovieData()
        }
        // Do any additional setup after loading the view.
    }
    
    func addTopBar(){
        
        if let get = getNavigationController(){
            get.setNavigationBarHidden(true, animated: true)
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
                self.sortMostPopularMovies()
            case 1 :
                self.sortLeastPopularMovies()
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
    
    
    func setupTableView(){
        DispatchQueue.main.async {
            self.registerNib()
        }
    }
    
    func setMoviesData(){
        
        self.movies = [Movie]()
        self.allMovies = [Movie]()
        
        for movie in self.MoviesData!{
            self.movies.append(movie)
            self.allMovies.append(movie)
        }
    }
    
    func setImagePathData(){
        if let resultData = self.imagePathURL {
            self.baseURLPathforLogo = (resultData.secureBaseUrl) + (resultData.profileSizes[2])
            self.baseURLPathforPoster = (resultData.secureBaseUrl) + (resultData.posterSizes[2])
        }
        setupTableView()
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
    func sortMostPopularMovies(){
        
        if self.movies != nil{
            tempArray = self.movies.sorted(by: { $0.popularity ?? 0 >  $1.popularity ?? 0})
        }
        DispatchQueue.main.async {
            self.movies = self.tempArray
            self.collectionView.reloadData()
        }
    }
    
    func sortLeastPopularMovies(){
        
        if self.movies != nil{
            tempArray = self.movies.sorted(by: { $0.popularity ?? 0 <  $1.popularity ?? 0})
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
