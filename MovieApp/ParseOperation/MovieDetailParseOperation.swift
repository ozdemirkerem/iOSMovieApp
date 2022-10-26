//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Kerem Özdemir on 26.10.2022.
//

import Foundation
import Alamofire

protocol MovieDetailParseOperationProtocol {
    func didMovieDetailParseOperationCompleted()
    func failResponse()
}

class MovieDetailParseOperation:NSObject{
    
    var movieDetailDelegate: MovieDetailParseOperationProtocol?
    fileprivate(set) var movieDetail : MovieDetailModel!
    
    func fetchMovieDetail(imdbID : String){
        
        let url = URL(string: "\(API_HOST + API_KEY)&i=\(imdbID)&plot=full")!
        
        AF.request(url)
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    DispatchQueue.main.async{
                        do{
                            let jsonData = try JSONDecoder().decode(MovieDetailModel.self, from: response.data!)
                            self.movieDetail = jsonData
                            if (jsonData.response == "False"){
                                self.movieDetailDelegate?.failResponse()
                            }else{
                                self.movieDetailDelegate?.didMovieDetailParseOperationCompleted()
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

