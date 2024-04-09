//
//  SettingsView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import Combine
import MOLH

class SettingsView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel = SettingsViewModel()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var container: UIView!
    
    var termsGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var privacyGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var returnGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var termsView: UIView! {
        didSet {
            termsView.isUserInteractionEnabled = true
            termsView.addGestureRecognizer(termsGest)
        }
    }
    
    @IBOutlet weak var privacyView: UIView! {
        didSet {
            privacyView.isUserInteractionEnabled = true
            privacyView.addGestureRecognizer(privacyGest)
        }
    }
    
    @IBOutlet weak var returnView: UIView! {
        didSet {
            returnView.isUserInteractionEnabled = true
            returnView.addGestureRecognizer(returnGest)
        }
    }
    
    @IBOutlet weak var languageView: UIView! {
        didSet {
            languageView.roundedGrayHareefView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews(){
        self.container.EmbedSwiftUIView(view: LanguageDropdown(placeholder: "", viewModel: viewModel), parent: self)
    }

    func BindViews(){
        
        viewModel.$selectedLanguage.sink { language in
            if language.code != LoginDataService.shared.getAppLanguage().code {
                MOLH.setLanguageTo(language.code)
                LoginDataService.shared.setAppLanguage(language: language)
                let nav1 = UINavigationController()
                let vc = DashboardTabBarController()
                nav1.isNavigationBarHidden = true
                nav1.viewControllers = [vc]
                nav1.modalPresentationStyle = .fullScreen
                self.present(nav1, animated: true)
            }
        }.store(in: &bindings)
        
        termsGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = LongTextView()
                newViewController.titleText = "terms_and_conditions".localized
                newViewController.textContent = "terms_txt".localized
//                newViewController.textContent = """
//1.1. These Terms of Service (referred to as “Terms”) constitute a legally binding agreement between you and the Emirates Square Trading Establishment registered in the Kingdom of Saudi Arabia, which owns the (RosoVina) platform and published on the domain: http://RosoVina.com (referred to as the “Enterprise” or “the Platform”), and these Terms govern the relationship between the Organization and the User, and set out the terms and conditions on which you may access and use the Platform, related websites, applications, products, content, and contact center (collectively referred to as the “Services or Products”). . If you access or utilize the Services, register on the Platform, avail content offered, submit content through the Platform, or purchase through the Platform (collectively, “User or Customer”), and by using the Service, you agree and acknowledge without limitation or qualification that To comply legally with these Terms and be bound by them. If you do not agree to the Terms, you must stop accessing, using or benefiting from the Services.
//1.2. The Foundation reserves the right to amend and change these terms unilaterally at any time. The Platform may also amend this agreement from time to time, and these changes will be effective and legally binding for the user upon publishing the updated changes on this site or publishing the amended policies or any other terms related to the services provided or Upon notification by any other means, your continued use or use of the Platform after such posting constitutes your agreement to be bound by this Agreement as amended and that you accept to be legally bound by such changes. The platform also has the right to terminate the agreement that concerns you with immediate effect, or in general to stop offering the platform services or prevent access to them or any part of them, at any time and for any reason without prior notice.
//1.3. If you are using or availing the Services on behalf of a company or other entity, you acknowledge that:
//1.3.1. You are authorized to bind that company or entity to these Terms and you agree to them on behalf of that company or entity. All references to, without limitation, "you" and "your" in these Terms mean you and that company or entity. , the business or entity and person using the platform services through your account.
//1.3.2. That the company or entity is legally and financially responsible for your access to or use of the Services, as well as for access to or use of your account by others associated with the company or entity, including any employees or agents.
//2. Platform and Ownership Services
//2.1. The Services constitute a technical marketing platform that enables users of the organization’s electronic device applications or websites available as part of the Services (collectively referred to as the “Application”) to enable customers to place purchase orders through the Application in relation to the products indicated on the Application that will be delivered in the Kingdom of Saudi Arabia. Saudi Arabia, and you acknowledge that you are using the application in your capacity as a consumer and that you are the customer who registered to obtain the services for permitted purposes only, and you are not a competitor or agent of the application. You acknowledge that when you choose to order the purchase of our products, you can submit your order by clicking on the “Complete Order” button, and reviewing the information that you provided. By entering it and correcting any errors before executing the “purchase order”, as you will not be able to correct any errors when executing the order, and when we receive your order, you will receive a notification via your contact information stating that your order has been received successfully and that it will be processed by “RosoVina” and sent to the delivery address provided, and you acknowledge your responsibility About paying for the product(s) ordered using your account, as well as the related delivery fees, whether the order is for you or for someone else.
//2.2. You must be at least eighteen (18) years old or have reached the legal age of majority in your jurisdiction - if the legal age of majority in your country is different from 18 years - so that you can create an account on the platform and be able to benefit from the services provided. You may not allow those under eighteen (18) years of age to use your account or obtain the services provided through the platform unless they are accompanied by a legal adult.
//2.3. When registering an account, you must provide certain personal information to the “RosoVina” platform, such as your name, address, mobile phone number, and age, in addition to at least one valid bank payment method (either a credit card or an accepted payment partner). You agree to record and maintain accurate, complete and current information in your account. Your failure to maintain accurate, complete, and up-to-date information in your account, including an invalid or expired payment method, may result in your inability to access or use the Services or RosoVina's termination of these Terms with you. You are responsible for all activities that occur under your account, and you agree to maintain the security and confidentiality of your account username and password at all times.
//"""
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        privacyGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = LongTextView()
                newViewController.titleText = "privacy_policy".localized
                newViewController.textContent = "privacy_txt".localized
//                newViewController.textContent = """
//This privacy policy explains the basis on which we deal with any personal data, which is based on our policy of respecting your privacy regarding any information that we may collect during the operation of our website and affiliated electronic applications, until your access and use of the RosoVina platform on the domain (www) and /or affiliated applications, collectively referred to as the “Services”; Therefore, we have developed this privacy policy for you so that you can understand how we collect, use, pass and disclose personal information. By agreeing to the terms and conditions, you agree to the collection of personal information to the extent necessary for use by Emirates Square Trading Establishment, and therefore you have agreed that the data will be collected in accordance with This Privacy Policy, in accordance with the Privacy Policy Summary -below-:
//1. We will collect personal data by lawful and proper means, with the knowledge or consent of the data subject where necessary.
//2. Before or during the collection of personal data, we will identify the purposes for which the data is collected.
//3. We will collect and use personal data only to fulfill those purposes specified by us and for other assistance purposes, whether with the consent of the person concerned or as required by regulations and legislation.
//4. Personal data should be appropriate for the purposes for which it is to be used, and to the extent necessary for those purposes, and such data should be accurate, complete and up-to-date.
//5. We will work to protect personal data using reasonable security safeguards in order to secure it against loss or theft, to prevent unauthorized access to it, or to prevent its disclosure, copying, use or modification, but this does not mean our absolute commitment to this protection.
//6. We will provide customers with sufficient information about policies and practices related to the management of personal data.
//7. We will retain personal data only for as long as necessary to fulfill those purposes.
//8. We will use your contact information to send you newsletters, emails, text messages, notices, services, sales and special offers if you have signed up to receive them and do not choose to cancel them, and we may also use your email address to display advertisements for our products, services, sales and exclusive offers.
//9. Our privacy policy may be affected and need to be constantly changed, so we will publish the current version of this privacy policy on the site and it will remain in effect from the time it is published on the site or based on the date specified by us as its effective date.
//10. We may send periodic email reminders of our notices and terms, but you should check back by frequently visiting our site to see the latest changes.
//11. You should check the privacy policy regularly. Your continued use of the Site after any changes constitutes your acceptance of this Privacy Policy as amended.
//"""
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        returnGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = LongTextView()
                newViewController.titleText = "return_policy".localized
                newViewController.textContent = "return_txt".localized
//                newViewController.textContent = """
//Our valued customers can exchange and return their purchases within 24 hours from the date of receiving the order under the following terms and conditions:
//
//We are pleased to serve you in the event that you are not satisfied with the quality of our products and would like to return the items that were delivered, please contact our customer service team through the Rozofina platforms via the website, the application, and the unified call number (920015772) to schedule the receipt of the returned items within 24 hours from the date of delivery. The product, and Rosovina's return policy will comply with the laws applied in the Kingdom of Saudi Arabia.
//
//Please ensure that returned items are unopened, unused and in the original packaging with tags and packaging still intact. We will return the full amount of the paid order to the customer’s wallet account for eligible returns in which the product is damaged upon delivery, with pictures proving this.
//Rosovina Company offers a one-day return policy for jewelry, items that come in contact with the skin, and perfumes, which must be in their original condition, sealed, and without any packaging damaged, with the customer bearing the return cost.
//
//After Rosovina receives the product to be returned and checks its quality, Rosovina will send you via the customer service team information if your return request has been approved and how long the refund process will take through the customer’s wallet.
//
//*Please note that the following items are excluded from this return policy: flowers, lingerie, children's clothing, cosmetics, personal care products, oud, incense and their derivatives, earrings, candles, software, video games, children's toys, natural items, and special orders. All items are edible.
//"""
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
