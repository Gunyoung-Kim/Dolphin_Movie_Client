//
//  MovieVO.swift
//  DolphinMovie
//
//  Created by 김건영 on 2020/10/04.
//

import UIKit

class MovieVO {
    var rank: String?       // 순위
    var rankInten: String?      // 전일대비 순위 증감분
    var rankOldAndNew: String?      // 랭킹 신규 진입여부 OLD:기존, NEW:신규
    
    var movieCd: String?        // 영화의 대표코드
    var movieNm: String?        // 영화 이름(국문)
    var openDt: String?         // 개봉일
    var audiAcc: String?        // 누적 관객수
    
    var link: String?       //영화의 하이퍼텍스트 link
    var imageUrl: String? = "default"    //영화 썸네일 url
    
    var thumbnail: UIImage?
}
