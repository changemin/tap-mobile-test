//
//  ContentView.swift
//  tap-mobile-test
//
//  Created by 변경민 on 2022/01/31.
//

import SwiftUI
import YouTubePlayerKit
import Alamofire
import SwiftyJSON

struct ContentView: View {
    @State var searchText: String = ""
    @State var videoIds:[String] = []
    @State var pageNum: Int = 0
    var body: some View {
        VStack {
            HStack {
                TextField("Search ...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                Button(action: {
                    getResult()
                }) {
                    Text("Search").padding(.trailing, 7)
                }
            }
            VStack {
                ForEach(videoIds, id: \.self) { vidId in
                    YouTubePlayerView(YouTubePlayer(stringLiteral: "https://www.youtube.com/watch?v="+vidId))
                }
            }
            Spacer()
            HStack {
                Button(action: {
                    
                }) {
                    Text("Previous Page")
                }
                Button(action: {
                    
                }) {
                    Text("Next Page")
                }
            }
        }
    }
    func getResult() {
        let url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBaT2l9GC7T4b7OAeQnSUlRQLy6K-K0kNI&type=video&maxResults=1000&q="+searchText
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseData { response in
            let json = JSON(response.value ?? "")
            videoIds.removeAll()
            for i in 0...10 {
                print(json["items"][i]["id"]["videoId"])
                videoIds.append(json["items"][i]["id"]["videoId"].stringValue)
            }
        }
    }
}
