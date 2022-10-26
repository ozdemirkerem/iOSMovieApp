//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Kerem Özdemir on 22.10.2022.
//

import UIKit
import SwiftUI
import IHProgressHUD
import Firebase

class HomeViewController: UIViewController,
                          UISearchBarDelegate,
                          UISearchControllerDelegate,
                          MovieSearchParseOperationProtocol,
                          MovieDetailParseOperationProtocol
{
    @IBOutlet weak var movieTableView: UITableView!
    
    private let searchController = UISearchController()
    private var searchBar = UISearchBar()
    
    fileprivate var movieModel:MovieSearchParseOperation!
    fileprivate var movieDetailModel = MovieDetailParseOperation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.backgroundColor = UIColor(red: 255/255.0, green: 247/255.0, blue: 233/255.0, alpha: 1.0)

        movieModel = MovieSearchParseOperation()
        movieModel.movieSearchDelegate = self
        movieDetailModel.movieDetailDelegate = self
                
        searchController.delegate = self
        searchBar = searchController.searchBar
        searchBar.delegate = self
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        setupSearchBar()
    }
    
    func setupSearchBar(){
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movieTableView.dataSource = nil
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText:String = (searchBar.text)!
        self.movieModel.fetchMovies(search: searchText)
        IHProgressHUD.show()
    }
    
    func didMovieSearchParseOperationCompleted() {
        movieTableView.dataSource = self
        movieTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            IHProgressHUD.dismiss()
        }
    }
    
    func failResponse() {
        searchBar.text = ""
        movieTableView.dataSource = nil

        let alert = UIAlertController(title: "Error",
                                      message: movieModel.movies.error,
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            IHProgressHUD.dismiss()
        }
    }
    
    func didMovieDetailParseOperationCompleted(){
        
        if let movieDetail = movieDetailModel.movieDetail {
            Analytics.logEvent("movie_detail_screen", parameters: [
                "movieName" : movieDetail.title ?? "",
                "movieType" : movieDetail.type ?? "",
                "movieYear" : movieDetail.year ?? ""
            ])
        }
        
        let swiftUIController = UIHostingController(rootView: MovieDetailView(movieDetailModel: self.movieDetailModel.movieDetail))
        self.navigationController?.pushViewController(swiftUIController, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            IHProgressHUD.dismiss()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (movieModel.movies != nil) {
            if (movieModel.movies.response == "True") {
                return movieModel.movies.search!.count
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        
        cell.backgroundColor = UIColor.clear
        if (movieModel.movies != nil) {
            cell.movieName.text  =  movieModel.movies.search?[indexPath.row].title
            cell.type.text = movieModel.movies.search?[indexPath.row].type
            cell.movieYear.text = movieModel.movies.search?[indexPath.row].year
            cell.imageFromUrl(url: (movieModel.movies.search?[indexPath.row].poster)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let imdbID = movieModel.movies.search?[indexPath.row].imdbID {
            movieDetailModel.fetchMovieDetail(imdbID: imdbID)
            IHProgressHUD.show()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
