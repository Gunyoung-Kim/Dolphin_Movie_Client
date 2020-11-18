//
//  NotificationViewController.swift
//  DolphinMovie
//
//  Created by 김건영 on 2020/11/02.
//

import UIKit

enum NotiStatus {
    static let read = "READ"
    static let nonread = "NONREAD"
}

struct Noti {
    var title: String?
    var detail: String?
}

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tv = UITableView()
    let headerView = UIView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
    
    override func viewDidLoad() {
        /* 뷰 설정*/
        self.view.backgroundColor = .white
        
        /* 네비게이션 설정 */
        let rBtn = UIBarButtonItem()
        
        rBtn.target = self
        rBtn.action = #selector(notiSetting(_:))
        rBtn.image = UIImage(named: "setting-gear")
        
        self.navigationItem.rightBarButtonItem = rBtn
        
        let lBtn = UIBarButtonItem()
        
        lBtn.target = self
        lBtn.action = #selector(close(_ :))
        lBtn.style = .plain
        lBtn.title = "X"
        
        self.navigationItem.leftBarButtonItem = lBtn
        
        /* 헤더 뷰 */ // 이거 나중에 바로 바꿀 수 있을까????
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        let allReadBtn = UIButton(frame: CGRect(x: self.view.frame.width-60, y: 0, width: 50, height: 40))
        allReadBtn.setTitle("전체 읽음", for: .normal)
        allReadBtn.addTarget(self, action: #selector(readAll(_:)), for: .touchUpInside)
        allReadBtn.titleLabel?.textColor = .black
        
        self.headerView.addSubview(allReadBtn)
        
        let allDelBtn = UIButton(frame: CGRect(x: self.view.frame.width - 120, y: 0, width: 50, height: 40))
        allDelBtn.setTitle("전체 삭제", for: .normal)
        allDelBtn.addTarget(self, action: #selector(deleteAll(_:)), for: .touchUpInside)
        allDelBtn.titleLabel?.textColor = .red
        
        self.headerView.addSubview(allDelBtn)
        
        self.view.addSubview(headerView)
        
        /*테이블 뷰*/
        
        self.tv.backgroundColor = .white
    }
    
    @objc func notiSetting(_ sender: Any) {
        
    }
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func readAll(_ sender: Any) {
    }
    
    @objc func deleteAll(_ sender: Any) {
        
    }
    
}
