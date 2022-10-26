//
//  SplashViewController.swift
//  MovieApp
//
//  Created by Kerem Özdemir on 23.10.2022.
//

import UIKit
import FirebaseRemoteConfig
import SystemConfiguration

class SplashViewController: UIViewController {
    
    let welcomeTitleLabel : UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: (UIScreen.main.bounds.size.height / 6)*3, width: 200, height: 60))
        lb.textAlignment = .left
        lb.backgroundColor = UIColor.white
        lb.textColor = UIColor.black
        lb.font = UIFont(name: "Roboto-Light", size: 35)
        lb.roundCorners(corners: UIRectCorner([.topRight,.bottomRight]), radius: 15.0)
        
        return lb
    }()
    
    let appNameLabel : UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: (UIScreen.main.bounds.size.height / 6)*3 + 70,
                                       width: 250,
                                       height: 60))
        lb.textAlignment = .left
        lb.backgroundColor = UIColor.white
        lb.textColor = UIColor.black
        lb.font = UIFont(name: "Roboto-Light", size: 55)
        lb.roundCorners(corners: UIRectCorner([.topRight,.bottomRight]), radius: 15.0)
        
        return lb
    }()
    
    let appProviderLabel : UILabel = {
        let lb = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width / 3, y: (UIScreen.main.bounds.size.height / 6)*5,
                                       width: (UIScreen.main.bounds.size.width / 3)*2,
                                       height: 60))
        lb.textAlignment = .right
        lb.backgroundColor = UIColor.white
        lb.textColor = UIColor.black
        lb.font = UIFont(name: "Roboto-Bold", size: 55)
        lb.roundCorners(corners: UIRectCorner([.topLeft,.bottomLeft]), radius: 15.0)
        
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()

        if isConnectedToNetwork() {
            let remoteConfig = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig.configSettings = settings
            
            remoteConfig.fetch { (status, error) -> Void in
              if status == .success {
                print("Config fetched!")
                remoteConfig.activate { changed, error in
                    DispatchQueue.main.async {
                        let welcomeTitle = remoteConfig.configValue(forKey: "welcomeTitle").stringValue ?? "undefined"
                        let appName = remoteConfig.configValue(forKey: "appName").stringValue ?? "undefined"
                        let appProvider = remoteConfig.configValue(forKey: "appProvider").stringValue ?? "undefined"

                        self.welcomeTitleLabel.text = welcomeTitle
                        self.appNameLabel.text = appName
                        self.appProviderLabel.text = appProvider.uppercased()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            let storyboard = UIStoryboard(name: "HomeViewController", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
              } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
              }
            }
        }else{
            let alert = UIAlertController(title: "No Internet Connection",
                                          message: "Make sure your device is connected to the internet.",
                                          preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
        
        self.view.addSubview(welcomeTitleLabel)
        self.view.addSubview(appNameLabel)
        self.view.addSubview(appProviderLabel)
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
    
    func setBackgroundImage(){
        let backgroundImage = UIImageView(frame: CGRect(x:0, y:0,
                                                            width: UIScreen.main.bounds.size.width,
                                                            height: UIScreen.main.bounds.size.height))
        backgroundImage.image = UIImage(named: "SplashScreenBackground")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        tintView.frame = CGRect(x: 0, y: 0,
                                width: backgroundImage.frame.width,
                                height: backgroundImage.frame.height)
        backgroundImage.addSubview(tintView)

        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
