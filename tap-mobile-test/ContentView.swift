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
    @State var nextPageToken = ""
    @State var prevPageToken = ""
    var body: some View {
        VStack {
            HStack {
                TextField("Search ...", text: $searchText)
                    .disableAutocorrection(true)
                    
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
                if pageNum == 0 {
                    Text("Prev Page").foregroundColor(.gray)
                } else {
                    Button(action: {
                        getNextPage()
                        pageNum -= 1
                    }) {
                        Text("Prev Page")
                    }
                }
                Text(String(pageNum))
                Button(action: {
                    getNextPage()
                    pageNum += 1
                }) {
                    Text("Next Page")
                }
            }
        }
    }
    func getResult() {
        pageNum = 0
        let url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBaT2l9GC7T4b7OAeQnSUlRQLy6K-K0kNI&type=video&maxResults=10&q="+searchText
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseData { response in
            let json = JSON(response.value ?? "")
            nextPageToken = json["nextPageToken"].stringValue
            prevPageToken = json["prevPageToken"].stringValue
            videoIds.removeAll()
            for i in 0...10 {
                print(json["items"][i]["id"]["videoId"])
                videoIds.append(json["items"][i]["id"]["videoId"].stringValue)
            }
        }
    }
    func getNextPage(){
        let url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBaT2l9GC7T4b7OAeQnSUlRQLy6K-K0kNI&type=video&maxResults=10&q="+searchText+"&pageToken="+nextPageToken
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseData { response in
            let json = JSON(response.value ?? "")
            nextPageToken = json["nextPageToken"].stringValue
            prevPageToken = json["prevPageToken"].stringValue
            videoIds.removeAll()
            for i in 0...10 {
                print(json["items"][i]["id"]["videoId"])
                videoIds.append(json["items"][i]["id"]["videoId"].stringValue)
            }
        }
    }
    
    func getPrevPage() {
        let url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBaT2l9GC7T4b7OAeQnSUlRQLy6K-K0kNI&type=video&maxResults=10&q="+searchText+"&pageToken="+prevPageToken
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseData { response in
            let json = JSON(response.value ?? "")
            nextPageToken = json["nextPageToken"].stringValue
            videoIds.removeAll()
            for i in 0...10 {
                print(json["items"][i]["id"]["videoId"])
                videoIds.append(json["items"][i]["id"]["videoId"].stringValue)
            }
        }
    }
}
