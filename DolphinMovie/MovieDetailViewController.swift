//
//  MovieDetailViewController.swift
//  DolphinMovie
//
//  Created by 김건영 on 2020/10/04.
//

import UIKit
import WebKit
import AuthenticationServices

class MovieDetailViewController: UIViewController {
    var mvo: MovieVO!
    @IBOutlet var webView: WKWebView!
    var nameEncode = String("담보").utf8
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func getPercentingString(_ str: String) -> String {
        let escapingCharacterSet: CharacterSet = {
            var cs = CharacterSet.alphanumerics
            cs.insert(charactersIn: "-_.~")
            return cs
        }()

        let d = str.addingPercentEncoding(withAllowedCharacters: escapingCharacterSet)
        return d!
    }
    
    func callMovieDetailAPI() {
        let query = self.mvo.movieNm
        let pquery = self.getPercentingString(query!)
        let urlString = "https://openapi.naver.com/v1/search/movie.json?query=" + "\(pquery)"
        
        let url = URL(string: urlString)
        
        var req = URLRequest(url: url!)
        
        req.httpMethod = "GET"
        //req.httpBody = paramData
        req.setValue("UJhEZtf1S4jGhPdd3G9M", forHTTPHeaderField: "X-Naver-Client-Id")
        req.setValue("etudDGsd0R", forHTTPHeaderField: "X-Naver-Client-Secret")
        URLSession.shared.dataTask(with: req) {
            (data: Data?, response: URLResponse?, error: Error?) -> () in
            if let e = error {
                NSLog("An error has occurred : \(e.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    guard let jsonObject = object else {
                        return
                    }
                    let items = jsonObject["items"] as! NSArray
                    
                    guard items.count != 0 else {
                        
                        let alert = UIAlertController(title: "ERROR", message: "서버에 등록되지 않은 영화 정보입니다.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: false,completion: nil)
                        
                        return
                    }
                    
                    let item = items[0] as! NSDictionary
                    let link = item["link"] as! String
                    
                    NSLog("\(link)")
                    
                    let detailurl = URL(string: link)
                    
                    let detailReq = URLRequest(url: detailurl!)
                    
                    self.webView.load(detailReq)
                } catch {
                    
                }
            }
            
        }.resume()
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = mvo.movieNm!
        self.callMovieDetailAPI()
    }
}
