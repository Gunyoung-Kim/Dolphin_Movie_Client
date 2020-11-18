//
//  AccountViewController.swift
//  DolphinMovie
//
//  Created by 김건영 on 2020/10/29.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let uinfo = UserInfoManager.shared
    
    let tv = UITableView()
    let imageView = UIImageView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "profilecell")
        cell.backgroundColor = .white
        
        /* 제목 텍스트 설정 */
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = .black
        
        /* 디테일 텍스트 설정 */
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.textColor = .darkGray
        
        if self.uinfo.isLogin == true {
            cell.isUserInteractionEnabled = false
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = self.uinfo.name ?? "로그인"
        default:
            cell.textLabel?.text = "계정"
            cell.detailTextLabel?.text = self.uinfo.account ?? "로그인"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if uinfo.isLogin == false {
            self.login(self.tv)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = img
            self.uinfo.profile = img
        }
        
        picker.presentingViewController?.dismiss(animated: true) {
            let alert = UIAlertController(title: nil, message: "프로필 사진 변경이 완료되었습니다.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(alert, animated: false)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.presentingViewController?.dismiss(animated: true) { 
            let alert = UIAlertController(title: nil, message: "프로필 사진 변경이 취소되었습니다.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(alert, animated: false)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        /* 네비게이션 아이템 설정 */
        self.navigationItem.title = "My Account"
        
        let closeBtn = UIBarButtonItem()
        closeBtn.style = .plain
        closeBtn.target = self
        closeBtn.action = #selector(close(_ :))
        closeBtn.title = "닫기"
        
        self.navigationItem.leftBarButtonItem = closeBtn
        
        /* 프로필 사진 */
        self.imageView.image = self.uinfo.profile
        self.imageView.frame.size = CGSize(width: 100, height: 100)
        self.imageView.center = CGPoint(x: self.view.frame.width / 2, y: 240)
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        self.imageView.layer.borderWidth = 0
        self.imageView.layer.masksToBounds = true
        
        if uinfo.isLogin == true {
            self.imageView.isUserInteractionEnabled = true
        } else {
            self.imageView.isUserInteractionEnabled = false
        }
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage(_:))))
        
        self.view.addSubview(imageView)
        
        /* 2개의 테이블 뷰 */
        self.tv.frame = CGRect(x: 0, y: self.imageView.frame.origin.y + self.imageView.frame.height, width: self.view.frame.width, height: 100)
        self.tv.backgroundColor = .white
        self.tv.isDirectionalLockEnabled = false
        self.tv.dataSource = self
        self.tv.delegate = self
        
        self.view.addSubview(tv)
        
        /* 버튼 그리기 */
        self.drawButton()
    }
    
    func drawButton() {
        let v = UIView()
        
        v.frame = CGRect(x: 0, y: self.tv.frame.origin.y + self.tv.frame.height, width: self.view.frame.width, height: 40)
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        
        self.view.addSubview(v)
        
        let btn = UIButton(type: .system)
        btn.frame.size.height = 30
        btn.frame.size.width = 100
        btn.center.x = v.frame.width / 2
        btn.center.y = v.frame.height / 2
        
        if uinfo.isLogin == false {
            btn.setTitle("로그인", for: .normal)
            btn.addTarget(self, action: #selector(login(_ :)), for: .touchUpInside)
        } else {
            btn.setTitle("로그아웃", for: .normal)
            btn.addTarget(self, action: #selector(logout(_ :)), for: .touchUpInside)
        }
        v.addSubview(btn)
    }
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func pickImage(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @objc func changeImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해주세요.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "카메라", style: .default) { (_) in
            self.pickImage(.camera)
        })
        
        alert.addAction(UIAlertAction(title: "사진 라이브러리", style: .default) { (_) in
            self.pickImage(.photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { (_) in
            self.pickImage(.savedPhotosAlbum)
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: false)
    }
    
    @objc func login(_ sender: Any) {
        let alert = UIAlertController(title: "로그인", message: nil, preferredStyle: .alert)
        
        alert.addTextField() { (tf) in
            tf.placeholder = "ID"
            tf.keyboardType = .emailAddress
        }
        
        alert.addTextField() { (tf) in
            tf.placeholder = "Password"
            tf.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "로그인", style: .default) { (_) in
            
            let account = alert.textFields?[0].text ?? ""
            let passwd = alert.textFields?[1].text ?? ""
            if self.uinfo.login(account: account, passwd: passwd) {
                self.tv.reloadData()
                self.imageView.image = self.uinfo.profile
                self.imageView.isUserInteractionEnabled = true
                self.drawButton()
            } else {
                let msg = "로그인에 실패하였습니다."
                
                let failalert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
                failalert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(failalert, animated: false)
            }
        })
        
        self.present(alert, animated: false)
    }
    
    @objc func logout(_ sender: Any) {
        let msg = "로그아웃하시겠습니까?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { (_) in
            if self.uinfo.logout() {
                self.tv.reloadData()
                self.imageView.image = self.uinfo.profile
                self.drawButton()
                self.imageView.isUserInteractionEnabled = false
            }
        })
        
        self.present(alert, animated: false)
    }
    
    
}
