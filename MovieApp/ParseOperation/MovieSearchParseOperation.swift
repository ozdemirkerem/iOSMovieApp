//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Kerem Özdemir on 24.10.2022.
//

import Foundation
import Alamofire
import UIKit

protocol MovieSearchParseOperationProtocol {
    func didMovieSearchParseOperationCompleted()
    func failResponse()
}

class MovieSearchParseOperation:NSObject{
    
    var movieSearchDelegate: MovieSearchParseOperationProtocol?
    fileprivate(set) var movies : MovieModel!
    

    func fetchMovies(search : String){
        
        let urlEncoded : String = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = URL(string: "\(API_HOST + API_KEY)&s=\(urlEncoded)")!
        
        AF.request(url)
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    DispatchQueue.main.async {
                        do{
                            let jsonData = try JSONDecoder().decode(MovieModel.self, from: response.data!)
                            self.movies = jsonData
                            if (jsonData.response == "False"){
                                self.movieSearchDelegate?.failResponse()
                            }else{
                                self.movieSearchDelegate?.didMovieSearchParseOperationCompleted()
                            }
                        }catch{
                            print(error)
                        }
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
