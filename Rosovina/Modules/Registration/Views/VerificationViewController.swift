//
//  VerificationViewController.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/12/2023.
//

import UIKit
import Combine
import CombineCocoa
import SwiftyCodeView

class VerificationViewController: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: VerificationViewModel!
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var pleaseText: UILabel!
    
    @IBOutlet weak var phoneNumberText: UILabel!
    
    @IBOutlet weak var otpView: CustomCodeView!
    
    @IBOutlet weak var didntGetLabel: UILabel!
    
    @IBOutlet weak var resendButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            continueButton.prettyHareefButton(radius: 16)
        }
    }
    
    var countdownTimer: Timer?
    var secondsRemaining = 60
 
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.delegate = self
        BindViews()
        startCountdown()
    }
    
    func BindViews(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        if viewModel.isResetByEmail ?? false {
            pleaseText.text = "Please verify your email address"
            phoneNumberText.text = "We texted you on " + viewModel.emailText
        }else{
            pleaseText.text = "Please verify your mobile number"
            phoneNumberText.text = "We texted you on " + viewModel.phoneText
        }
        
        continueButton.tapPublisher
            .sink { _ in
                if self.viewModel.isResetPassword {
                    if self.viewModel.isResetByEmail ?? false{
                        self.viewModel.emailOTPCheck()
                    }else{
                        self.viewModel.otpCheck()
                    }
                }else{
                    self.viewModel.otpCheck()
                }
            }
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        resendButton.tapPublisher
            .sink { _ in
                if self.viewModel.isResetByEmail ?? false {
                    self.viewModel.retriveToken()
                }else{
                    self.viewModel.sendOTP()
                }
                self.startCountdown()
            }
            .store(in: &bindings)
                
        viewModel.$forgetPasswordStatus.sink { v in
            if v == .success{
                let newViewController = ForgetPasswordView()
                newViewController.viewModel = CreatePasswordViewModel(phoneText: self.viewModel.checkForPhone(phone: self.viewModel.phoneText, code: self.viewModel.phoneCode), emailText: self.viewModel.emailText, token: self.viewModel.tokenResponse?.token)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if v == .failed{
                Alert.show("Forget Password Error", message: self.viewModel.errorMessage, context: self)
            }
        }.store(in: &bindings)
        
        viewModel.$registrationStatus.sink { v in
            if v == .success{
                let nav1 = UINavigationController()
                let vc = DashboardTabBarController()
                nav1.isNavigationBarHidden = true
                nav1.viewControllers = [vc]
                nav1.modalPresentationStyle = .fullScreen
                self.present(nav1, animated: true)
            }else if v == .failed{
                Alert.show("OTP Error", message: self.viewModel.errorMessage, context: self)
            }
        }.store(in: &bindings)
    }
    
    func startCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        self.didntGetLabel.isHidden = true
        self.resendButton.isHidden = true
        self.timerLabel.isHidden = false
        self.secondsRemaining = 60
        print("Countdown started!")
    }
        
    @objc func updateCountdown() {
        secondsRemaining -= 1
        
        // Calculate minutes and seconds
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        
        // Format the time as (minutes:seconds)
        let formattedTime = String(format: "%d:%02d", minutes, seconds)
        
        // Update label to display remaining time
        timerLabel.text = formattedTime
        
        if secondsRemaining == 0 {
            // Countdown has ended, invalidate the timer
            countdownTimer?.invalidate()
            // Notify that the countdown has ended
            self.didntGetLabel.isHidden = false
            self.resendButton.isHidden = false
            self.timerLabel.isHidden = true
            self.timerLabel.text = "1:00"
            print("Countdown ended!")
        }
    }

}

extension VerificationViewController: SwiftyCodeViewDelegate {
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) -> Bool {
        self.viewModel.codeText = code
        return true
    }
}
