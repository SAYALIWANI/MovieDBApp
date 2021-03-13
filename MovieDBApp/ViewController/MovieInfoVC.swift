//
//  MovieInfoVC.swift
//  MovieDBApp
//
//  Created by SayaliWani on 11/03/21.
//

import UIKit

class MovieInfoVC: UIViewController {

    @IBOutlet weak var tblViewMovieInfo: UITableView!
    var movieData : Movie!
    var baseURLPathforLogo = ""
    var baseURLPathforPoster = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopBar()
        registerNib()
        // Do any additional setup after loading the view.
    }
    
    func addTopBar(){
        
        if let get = getNavigationController(){
            get.setNavigationBarHidden(true, animated: true)
        }else{
            //customizeNavigationBar()
        }
        let vw = self.addTopBar(title: "Back") as! NavigationBarView
        vw.btnBackClicked = { sender in
            self.back()
        }
        vw.btnMenu.isHidden = true
    }

    func setupData(data : Movie, imageLogoURL: String, imagePosterURL: String){
        movieData = data
        baseURLPathforLogo = imageLogoURL
        baseURLPathforPoster = imagePosterURL
    }

    func registerNib(){
        tblViewMovieInfo.delegate = self
        tblViewMovieInfo.dataSource = self
        tblViewMovieInfo.register(UINib(nibName: "MovieInfoTblViewCell", bundle: nil), forCellReuseIdentifier: "MovieInfoTblViewCell")
        tblViewMovieInfo.reloadData()
    }
}

extension MovieInfoVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lcCell = tblViewMovieInfo.dequeueReusableCell(withIdentifier: "MovieInfoTblViewCell", for: indexPath) as! MovieInfoTblViewCell
        lcCell.setupData(data: movieData, imageLogoURL: baseURLPathforLogo, imagePosterURL: baseURLPathforPoster)
        return lcCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
