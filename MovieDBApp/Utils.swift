//
//  Utils.swift
//  MovieDBApp
//
//  Created by SayaliWani on 11/03/21.
//

import Foundation
import UIKit


extension UIViewController{
    
    func addTopBar(title: String) -> UIView {
        let vw = NavigationBarView.fromNib()
        if #available(iOS 11.0, *) {
            if UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0 > 0.0 {
                vw.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 94)
            }else{
                vw.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 74)
            }
        } else {
            // Fallback on earlier versions
            vw.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 74)
        }

        vw.titleText = title
        self.view.addSubview(vw)
        return vw
    }
     
    func back(){
        if (self.navigationController != nil){
            self.navigationController?.popViewController(animated: true)
        }else{
            //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true) {}
        }
    }
    
    func next(vc:UIViewController, hideNavigationBar : Bool = false){
        if let get = getNavigationController(){
            get.setNavigationBarHidden(hideNavigationBar, animated: true)
            get.pushViewController(vc, animated: true)
        }
        else{
            presentViewController(vc)
        }
    }
}

extension UIView{
    
     class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil) else {
            fatalError("missing expected nib named: \(name)")
        }
        
        guard let view = nib.first as? Self else {
            fatalError("view of type \(Self.self) not found in \(nib)")
        }
        return view
    }
}


public func getNavigationController() -> UINavigationController?{
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
         return navigationController
     } else {
         return nil
     }
}

func presentViewController(_ viewController: UIViewController) {
    if let topViewController = UIApplication.topMostViewController() {
        viewController.modalPresentationStyle = .fullScreen
        topViewController.present(viewController, animated: true, completion: nil)
    }
}

extension UIApplication{
    
    // MARK: Choose keyWindow as per your choice
    var currentWindow: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    // MARK: Choose keyWindow as per your choice
    var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    class func topMostViewController(base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
//        if let nav = base as? UINavigationController {
//            return topMostViewController(base: nav.visibleViewController)
//        }
//        if let presented = base?.presentedViewController {
//            return topMostViewController(base: presented)
//        }
        return base
    }
    
}
