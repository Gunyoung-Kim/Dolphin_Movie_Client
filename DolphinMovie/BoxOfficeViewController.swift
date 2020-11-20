//
//  BoxOfficeViewController.swift
//  DolphinMovie
//
//  Created by 김건영 on 2020/10/02.
//

import UIKit

enum BoxOfficeType {
    case Daily
    case Weekly
}

class BoxOfficeViewController: UITableViewController {
    lazy var dailyRankList: [MovieVO] = [MovieVO]()
    lazy var weeklyRankList: [MovieVO] = [MovieVO]()
    var boxofficeType: String?
    var showRange: String?
    
    let apiKey = "342f60885e5e3583a7c9be41e3ff2cb7"
    let itemPerPage = 10
    var todayDate: String = {
        let date = Date(timeIntervalSinceNow: (-60*60*24))
        let calendar = Calendar.current
            
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
    
        let yyyy = String("\(year)")
        var mm: String?
        var dd: String?
            
        mm = (month < 10) ? String("0\(month)") : String("\(month)")
            
        dd = (day < 10) ? String("0\(day)") : String("\(day)")
        
        print("\(String("\(yyyy)\(mm!)\(dd!)"))")
        return String("\(yyyy)\(mm!)\(dd!)")
    }()  //YYYYMMDD
    
    var todayWeek: String = {
        let date = Date(timeIntervalSinceNow: (-7*60*60*24))
        let calendar = Calendar.current
            
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
    
        let yyyy = String("\(year)")
        var mm: String?
        var dd: String?
            
        mm = (month < 10) ? String("0\(month)") : String("\(month)")
            
        dd = (day < 10) ? String("0\(day)") : String("\(day)")
            
        print("\(String("\(yyyy)\(mm!)\(dd!)"))")
        return String("\(yyyy)\(mm!)\(dd!)")
    }()
    
    // MARK: Override Function
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return self.dailyRankList.count
        } else {
            return self.weeklyRankList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let row = self.dailyRankList[indexPath.row]
            NSLog("제목: \(row.movieNm!), 호출된 행번호: \(indexPath.row) - CellForRowAtDaily")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dailyRankCell") as! RankCell
            
            cell.movieTitle?.text = row.movieNm
            cell.rank?.text = row.rank
            
            if(row.rankOldAndNew == "NEW") {
                cell.rankInten?.text = "NEW"
                cell.rankInten?.textColor = .orange
            } else {
                let inten = Int(row.rankInten!)!
                if(inten < 0) {
                    cell.rankInten?.text = String("▾\(inten*(-1))")
                    cell.rankInten?.textColor = .blue
                } else if (inten == 0) {
                    cell.rankInten?.text = String("-")
                } else {
                    cell.rankInten?.text = String("▴\(inten)")
                    cell.rankInten?.textColor = .red
                }
            }
            
            self.callNaverMovieAPI(indexPath.row,rankType: .Daily)
          
            if let _ =  self.dailyRankList[indexPath.row].imageUrl {
                cell.thumbnail.image = self.setThumbnailImage(indexPath.row,rankType: .Daily)
            }
         
            return cell
            
        } else {
            let row = self.weeklyRankList[indexPath.row]
            NSLog("제목: \(row.movieNm!), 호출된 행번호: \(indexPath.row)-CellForRowAtWeekly")
            let cell = tableView.dequeueReusableCell(withIdentifier: "weeklyRankCell") as! RankCell
            
            cell.movieTitle?.text = row.movieNm
            cell.rank?.text = row.rank
            
            if(row.rankOldAndNew == "NEW") {
                cell.rankInten?.text = "NEW"
                cell.rankInten?.textColor = .orange
            } else {
                let inten = Int(row.rankInten!)!
                if(inten < 0) {
                    cell.rankInten?.text = String("▾\(inten*(-1))")
                    cell.rankInten?.textColor = .blue
                } else if (inten == 0) {
                    cell.rankInten?.text = String("-")
                } else {
                    cell.rankInten?.text = String("▴\(inten)")
                    cell.rankInten?.textColor = .red
                }
            }
           
            self.callNaverMovieAPI(indexPath.row,rankType: .Weekly)
            
            if let _ =  self.weeklyRankList[indexPath.row].imageUrl {
                cell.thumbnail.image = self.setThumbnailImage(indexPath.row,rankType: .Weekly)
            }
           
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textHeader = UILabel()
        let v = UIView()
        v.frame.origin = CGPoint(x: 0, y: 0)
        
        textHeader.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 2.0))
        textHeader.textColor = .systemBlue
        
        if section == 0 {
            textHeader.text = "Daily"
            textHeader.sizeToFit()
            textHeader.frame.origin = CGPoint(x: self.view.frame.width / 2 - textHeader.frame.width / 2 , y: 20)
            v.frame.size = CGSize(width: self.view.frame.width , height: 10)
        } else {
            textHeader.text = "Weekly "
            textHeader.sizeToFit()
            textHeader.center = CGPoint(x: self.view.frame.width / 2, y: 10)
            v.frame.size = CGSize(width: self.view.frame.width, height: 20)
        }
        
        v.addSubview(textHeader)
        
        return v
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Daily BoxOffice"
        } else {
            return "Weekly BoxOffice"
        }
    }
    
    override func viewDidLoad() {
        self.callTodayBoxofficeAPI(rankType: BoxOfficeType.Daily)
        self.callTodayBoxofficeAPI(rankType: BoxOfficeType.Weekly)
        
        if let revealVC = self.revealViewController() {
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(animated:))
            
            self.navigationItem.leftBarButtonItem = btn
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        let settingBtn = UIBarButtonItem()
        settingBtn.image = UIImage(named: "alarm")
        
        self.navigationItem.rightBarButtonItem = settingBtn
        
        self.tabBarItem.image = UIImage(named: "connectivity-bar")
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
     
    
    // MARK: Custom Function
    
    func callTodayBoxofficeAPI(rankType: BoxOfficeType) {
        let dailyUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(self.apiKey)&targetDt=\(self.todayDate)&itemPerPage=\(self.itemPerPage)&multiMovieYn=&repNationCd=&wideAreaCd="
        
        let weeklyUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key=\(self.apiKey)&targetDt=\(self.todayWeek)"
        
        let apiURI: URL!
        
        if(rankType == .Daily) {
            apiURI = URL(string: dailyUrl)
        } else {
            apiURI = URL(string: weeklyUrl)
        }
        
        let apiData = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apiData, encoding: String.Encoding.utf8.rawValue) ?? "데이터가 없습니다"
        
        NSLog("API RESULT = \(log)")
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apiData, options: []) as! NSDictionary
                
            let boxOfficeResult = apiDictionary["boxOfficeResult"] as! NSDictionary
                
            self.boxofficeType = boxOfficeResult["boxofficeType"] as? String
            self.showRange = boxOfficeResult["showRange"] as? String
            let BoxOfficeList: NSArray
                
            if(rankType == .Daily) {
                BoxOfficeList = boxOfficeResult["dailyBoxOfficeList"] as! NSArray
            } else {
                BoxOfficeList = boxOfficeResult["weeklyBoxOfficeList"] as! NSArray
            }
                
            for row in BoxOfficeList {
                let r = row as! NSDictionary
                let mvo = MovieVO()
                    
                mvo.rank = r["rank"] as? String
                mvo.rankInten = r["rankInten"] as? String
                mvo.rankOldAndNew = r["rankOldAndNew"] as? String
                mvo.movieCd = r["movieCd"] as? String
                mvo.movieNm = r["movieNm"] as? String
                mvo.openDt = r["openDt"] as? String
                mvo.audiAcc = r["audiAcc"] as? String
                    
                if(rankType == .Daily) {
                    self.dailyRankList.append(mvo)
                } else {
                    self.weeklyRankList.append(mvo)
                }
            }
        } catch {
            NSLog("parse Error!")
        }
        
    }
    
    func setThumbnailImage(_ index: Int,rankType: BoxOfficeType) -> UIImage {
        if(rankType == .Daily) {
            if let tnail = self.dailyRankList[index].thumbnail {
                return tnail
            } else {
                self.getThumbnailImage(index,rankType: .Daily)
                return self.dailyRankList[index].thumbnail!
            }
        } else {
            if let tnail = self.weeklyRankList[index].thumbnail {
                return tnail
            } else {
                self.getThumbnailImage(index,rankType: .Weekly)
                return self.weeklyRankList[index].thumbnail!
            }
        }
    }
    
    func callNaverMovieAPI(_ index: Int,rankType: BoxOfficeType) {
        if(rankType == .Daily) {
            if let _ = self.dailyRankList[index].link, let _ = self.dailyRankList[index].thumbnail {
                return
            } else {
                let query = self.dailyRankList[index].movieNm
                let pquery: String = {
                    let escapingCharacterSet: CharacterSet = {
                        var cs = CharacterSet.alphanumerics
                        cs.insert(charactersIn: "-_.~")
                        return cs
                    }()

                    let d = query!.addingPercentEncoding(withAllowedCharacters: escapingCharacterSet)
                    return d!
                    
                }()
                let urlString = "https://openapi.naver.com/v1/search/movie.json?query=" + "\(pquery)"
                
                let url = URL(string: urlString)
                
                var req = URLRequest(url: url!)
                
                req.httpMethod = "GET"
                req.setValue("UJhEZtf1S4jGhPdd3G9M", forHTTPHeaderField: "X-Naver-Client-Id")
                req.setValue("etudDGsd0R", forHTTPHeaderField: "X-Naver-Client-Secret")
                
                let session = URLSession.shared.dataTask(with: req) {
                    (data: Data?, response: URLResponse?, error: Error?) -> () in
                    if let e = error {
                        NSLog("An error has occurred : \(e.localizedDescription)")
                        return
                    }
                    do {
                        let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        
                        guard let jsonObject = object else {
                            return
                        }
                        
                        let items = jsonObject["items"] as! NSArray
        
                        guard (items.count != 0) else {
                            self.dailyRankList[index].imageUrl = "default"
                            self.dailyRankList[index].link = "default"
                            self.getThumbnailImage(index, rankType: .Daily)
                            return
                        }
                        
                        let item = items[0] as! NSDictionary
                        let link_ = item["link"] as! String
                        let imageurl = item["image"] as! String
                        
                        self.dailyRankList[index].imageUrl = imageurl
                        self.dailyRankList[index].link = link_
                     
                     
                        self.getThumbnailImage(index,rankType: .Daily)
                    
                       
                    } catch {
                        NSLog("Parse Error!")
                    }
                }.resume()
                
                NSLog("일간 \(index)번째 영화 네이버 호출 완료!-CallNAverAPiDaily")
                Thread.sleep(forTimeInterval: 0.1)
            }
        } else {
            if let _ = self.weeklyRankList[index].link, let _ = self.weeklyRankList[index].thumbnail {
                return
            } else {
                let query = self.weeklyRankList[index].movieNm
                let pquery: String = {
                    let escapingCharacterSet: CharacterSet = {
                        var cs = CharacterSet.alphanumerics
                        cs.insert(charactersIn: "-_.~")
                        return cs
                    }()

                    let d = query!.addingPercentEncoding(withAllowedCharacters: escapingCharacterSet)
                    return d!
                    
                }()
                let urlString = "https://openapi.naver.com/v1/search/movie.json?query=" + "\(pquery)"
                
                let url = URL(string: urlString)
                
                var req = URLRequest(url: url!)
                
                req.httpMethod = "GET"
                req.setValue("UJhEZtf1S4jGhPdd3G9M", forHTTPHeaderField: "X-Naver-Client-Id")
                req.setValue("etudDGsd0R", forHTTPHeaderField: "X-Naver-Client-Secret")
                
                let session = URLSession.shared.dataTask(with: req) {
                    (data: Data?, response: URLResponse?, error: Error?) -> () in
                    if let e = error {
                        NSLog("An error has occurred : \(e.localizedDescription)")
                        return
                    }
                    do {
                        let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        
                        guard let jsonObject = object else {
                            return
                        }
                        
                        guard jsonObject.count != 2 else {
                            NSLog("Rate limit exceed 에러")
                            return
                        }
                        
                        let items = jsonObject["items"] as! NSArray
                        
                        guard (items.count != 0) else {
                            self.weeklyRankList[index].imageUrl = "default"
                            self.weeklyRankList[index].link = "default"
                            self.getThumbnailImage(index, rankType: .Weekly)
                            return
                        }
                        
                        print("\(self.weeklyRankList[index].movieNm!)")
                        let item = items[0] as! NSDictionary
                        let link_ = item["link"] as! String
                        let imageurl = item["image"] as! String
                        
                        self.weeklyRankList[index].imageUrl = imageurl
                        self.weeklyRankList[index].link = link_
                        
                      
                        self.getThumbnailImage(index, rankType: .Weekly)
                       
                    } catch {
                        NSLog("Parse Error!")
                    }
                }.resume()
               
                NSLog("월간 \(index)번째 영화 네이버 호출 완료!-CallNaverAPIWeekly")
                Thread.sleep(forTimeInterval: 0.1)
                /*
                while(true) {
                    if(session.state == .suspended) {
                        session.resume()
                        break
                    }
                }
 */
            }
        }
    }
    
    func getThumbnailImage(_ index: Int,rankType: BoxOfficeType){
        if(rankType == .Daily) {
            let mvo = self.dailyRankList[index]
            
            if let _ = mvo.thumbnail {
                return
            } else {
                if(mvo.imageUrl == "default") {
                    mvo.thumbnail = UIImage(named: "default_thumbnail1")
                } else {
                    let url: URL! = URL(string: mvo.imageUrl!)
                    guard url != nil else {
                        NSLog("\(rankType) \(index)번째 영화 썸네일 이미지 url 유효하지 않음")
                        mvo.thumbnail = UIImage(named: "default_thumbnail1")
                        return
                    }
                    let imageData = try! Data(contentsOf: url)
                    mvo.thumbnail = UIImage(data: imageData)
                }
            }
        } else {
            let mvo = self.weeklyRankList[index]
            
            if let _ = mvo.thumbnail {
                return
            } else {
                if(mvo.imageUrl == "default") {
                    mvo.thumbnail = UIImage(named: "default_thumbnail1")
                } else {
                    let url: URL! = URL(string: mvo.imageUrl!)
                    guard url != nil else {
                        NSLog("\(rankType) \(index)번째 영화 썸네일 이미지 url 유효하지 않음")
                        mvo.thumbnail = UIImage(named: "default_thumbnail1")
                        return
                    }
                    let imageData = try! Data(contentsOf: url)
                    mvo.thumbnail = UIImage(data: imageData)
                }
            }
        }
    }
}


// MARK: - 세그웨이 처리단계

extension BoxOfficeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dboffice_detail_segue" {
            let path = self.tableView.indexPath(for: sender as! RankCell)
            
            let detailVC = segue.destination as? MovieDetailViewController
            
            detailVC?.mvo = self.dailyRankList[path!.row]
        }
        
        if segue.identifier == "wboffice_detail_segue" {
            let path = self.tableView.indexPath(for: sender as! RankCell)
            
            let detailVC = segue.destination as? MovieDetailViewController
            
            detailVC?.mvo = self.weeklyRankList[path!.row]
        }
    }
}
