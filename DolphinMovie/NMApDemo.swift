//
//  NMApDemo.swift
//  DolphinMovie
//
//  Created by 김건영 on 2020/10/10.
//

import UIKit
import NMapsMap

class NMApDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = NMFMapView(frame: view.frame)
        mapView.positionMode = .direction
        let locationOverlay = mapView.locationOverlay
        
        locationOverlay.touchHandler = { (overlay: NMFOverlay) ->Bool in
            print("오버레이 터치됨")
            return true
        }
        view.addSubview(mapView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
