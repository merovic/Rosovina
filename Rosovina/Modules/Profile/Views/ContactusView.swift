//
//  ContactusView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 09/02/2024.
//

import UIKit
import MessageUI

class ContactusView: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail composer when the user is done with it
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func email(_ sender: Any) {
        // Check if the device can send email
        guard MFMailComposeViewController.canSendMail() else {
            // Show an alert if the device cannot send email
            let alert = UIAlertController(title: "Error", message: "Your device cannot send email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Create an instance of MFMailComposeViewController
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        // Set up the email
        mailComposer.setToRecipients(["info@rosovina.com"]) // Set recipient email address
        mailComposer.setSubject("Message to Rosovina") // Set email subject
        
        // Set up the email body (optional)
        //mailComposer.setMessageBody("", isHTML: false)
        
        // Present the mail composer
        present(mailComposer, animated: true, completion: nil)
    }
    
    @IBAction func facebook(_ sender: Any) {
        if let url = URL(string: "https://www.facebook.com/rosovinaksa") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func instagram(_ sender: Any) {
        if let url = URL(string: "https://www.instagram.com/rosovinaksa") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func snapchat(_ sender: Any) {
        if let url = URL(string: "https://www.snapchat.com/add/rosovinaksa") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func tiktok(_ sender: Any) {
        if let url = URL(string: "https://www.tiktok.com/@rosovinaksa") {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func backpressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
