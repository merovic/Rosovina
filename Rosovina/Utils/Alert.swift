//
//  Alert.swift
//  Eschoola
//
//  Created by Admin on 6/4/19.
//  Copyright © 2019 amirahmed. All rights reserved.
//

import Foundation
import UIKit

class Alert {

    static func show(_ title:String, message:String ,context:UIViewController) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      // alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      context.present(alert, animated: true)
   }
    
//    static func sawaShow(imageName:String, title:String, subtitle:String, buttonTitle:String, context:UIViewController){
//        
//        let storyboard: UIStoryboard = UIStoryboard(name: "PopUps", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SawaPopUpViewController") as! SawaPopUpViewController
//        vc.imageName = imageName
//        vc.titlee = title
//        vc.subTitle = subtitle
//        vc.buttonTitle = buttonTitle
//        vc.modalPresentationStyle = .fullScreen
//        
//        vc.completion = { result in
//           
//        }
//        
//        context.present(vc, animated: true, completion: nil)
//    }

}
