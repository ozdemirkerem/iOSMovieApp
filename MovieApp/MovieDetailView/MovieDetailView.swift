//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Kerem Özdemir on 25.10.2022.
//

import SwiftUI
import URLImage

struct MovieDetailView: View {
    
    var movieDetailModel : MovieDetailModel
    
    let rows = [GridItem(.fixed(50))]
    @State var items = [String]()
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                ZStack{
                    VStack{
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.init(hex: "1746A2"))
                                .frame(maxHeight:110)
                                .padding()
                            Text(movieDetailModel.title?.uppercased() ?? "")
                                .lineLimit(3)
                                .font(Font.custom("Roboto-Medium", size: 20))
                                .multilineTextAlignment(.center)
                                .padding([.leading,.top,.trailing],20)
                                .foregroundColor(Color.white)
                        }
                    }
                    VStack{
                        HStack{
                            VStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.yellow)
                                        .padding([.leading,.trailing],10)
                                    Text("IMDb: \(movieDetailModel.imdbRating ??  "")")
                                        .padding()
                                        .font(Font.custom("Roboto-Light", size: 20))

                                }
                                .frame(width: 120, height: 60, alignment: .center)

                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.yellow)
                                        .padding([.leading,.trailing],10)
                                    Text(movieDetailModel.runtime ??  "")
                                        .padding()
                                        .font(Font.custom("Roboto-Light", size: 20))

                                }
                                .frame(width: 120, height: 60, alignment: .center)

                            }
                            
                            URLImage(movieDetailModel.poster!){ image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                    .padding([.trailing,.leading],15)
                                    .shadow(color: Color.black, radius: 20, x: 2, y: 2)
                            }
                            .frame(width: 200, height: 300, alignment: .center)
                        }
                        .padding()
                        Spacer()
                            .frame(height: 60)
                    }
                    
                }
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, alignment: .center) {
                        ForEach(items, id: \.self) { item in
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.init(hex: "5F9DF7"))
                                Text(item)
                                    .foregroundColor(Color.white)
                                    .padding(10)
                            }
                            
                        }
                    }
                    .padding([.leading,.trailing,.bottom],15)
                }
                
                Text("Plot")
                    .padding([.leading,.trailing],20)
                    .font(Font.custom("Roboto-Regular", size: 20))
                Text(movieDetailModel.plot ?? "")
                    .padding([.leading,.trailing],20)
                    .font(Font.custom("Roboto-Light", size: 20))


                VStack(alignment: .leading){
                    HStack{
                        Text("Year:")
                            .font(Font.custom("Roboto-Regular", size: 20))
                        Text(movieDetailModel.year ?? "")
                            .font(Font.custom("Roboto-Light", size: 20))
                    }
                    HStack{
                        Text("Released:")
                            .font(Font.custom("Roboto-Regular", size: 20))
                        Text(movieDetailModel.released ?? "")
                            .font(Font.custom("Roboto-Light", size: 20))
                    }
                    HStack{
                        Text("Language:")
                            .font(Font.custom("Roboto-Regular", size: 20))
                        Text(movieDetailModel.language ?? "")
                            .font(Font.custom("Roboto-Light", size: 20))
                    }
                    HStack{
                        Text("BoxOffice:")
                            .font(Font.custom("Roboto-Regular", size: 20))
                        Text(movieDetailModel.boxOffice ?? "")
                            .font(Font.custom("Roboto-Light", size: 20))
                    }
                    HStack(alignment: .top){
                        Text("Awards:")
                            .font(Font.custom("Roboto-Regular", size: 20))
                        Text(movieDetailModel.awards ?? "")
                            .font(Font.custom("Roboto-Light", size: 20))
                    }
                }
                .padding([.leading,.trailing],20)
                .padding([.top],10)
                
                VStack(alignment: .leading){
                    Text("Directed by:")
                        .font(Font.custom("Roboto-Regular", size: 20))
                    Text(movieDetailModel.director ?? "")
                        .font(Font.custom("Roboto-Light", size: 20))

                }
                .padding([.leading,.trailing],20)
                .padding([.top],10)

                VStack(alignment: .leading){
                    Text("Actors:")
                        .font(Font.custom("Roboto-Regular", size: 20))
                    Text(movieDetailModel.actors ?? "")
                        .font(Font.custom("Roboto-Light", size: 20))

                }
                .padding([.leading,.trailing],20)
                .padding([.top],10)
                
                VStack(alignment: .leading){
                    Text("Writer:")
                        .font(Font.custom("Roboto-Regular", size: 20))
                    Text(movieDetailModel.writer ?? "")
                        .font(Font.custom("Roboto-Light", size: 20))

                }
                .padding([.leading,.trailing],20)
                .padding([.top],10)
                .padding([.bottom],30)

            }
            .onAppear {
                if movieDetailModel.genre != nil {
                    items = movieDetailModel.genre!.components(separatedBy: ", ")
                }
            }
        }
        .padding([.top,.bottom],20)
        .background(Color.init(hex: "FFF7E9"))
        .ignoresSafeArea()
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieDetailModel:
                            MovieDetailModel(
            title: "The Lord of the Rings: The Fellowship of the Ring",
            year: "2001",
            rated: "PG-13",
            released: "19 Dec 2001",
            runtime: "178 min",
            genre: "Action, Adventure, Drama",
            director: "Peter Jackson",
            writer: "J.R.R. Tolkien, Fran Walsh, Philippa Boyens",
            actors: "Elijah Wood, Ian McKellen, Orlando Bloom",
            plot: "A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.",
            language: "English, Sindarin",
            country: "New Zealand, United States",
            awards: "Won 4 Oscars. 121 wins & 126 nominations total",
            poster: URL(string: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_SX300.jpg"),
            ratings: [Rating(source: "",
                             value: "")],
            metascore: "92",
            imdbRating: "8.8",
            imdbVotes: "1,846,001",
            imdbID: "tt0120737",
            type: "movie",
            dvd: "06 Aug 2002",
            boxOffice: "$316,115,420",
            production: "N/A",
            website: "N/A",
            response: "True"
                            
                            )
        )
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
