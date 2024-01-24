//
//  MyProfileView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import MOLH
import Combine
import SwiftUI
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers
import BottomSheet

class MyProfileView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: MyProfileViewModel = MyProfileViewModel()
    
    private let loadingView = LoadingAnimation()
    
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var backbutton: UIButton!
    
    @IBOutlet weak var firstNameView: UIView! {
        didSet {
            firstNameView.roundedGrayHareefView()
        }
    }
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameView: UIView! {
        didSet {
            lastNameView.roundedGrayHareefView()
        }
    }
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailView: UIView! {
        didSet {
            emailView.roundedGrayHareefView()
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    
    var imageGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.makeRounded()
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(imageGest)
        }
    }
    
    @IBOutlet weak var addressView: UIStackView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var addNewAddressButton: UIButton!
    
    var changePassGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var deactivateGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var changePasswordView: UIView! {
        didSet {
            changePasswordView.isUserInteractionEnabled = true
            changePasswordView.addGestureRecognizer(changePassGest)
        }
    }
    
    @IBOutlet weak var deactivateAccountView: UIView! {
        didSet {
            deactivateAccountView.isUserInteractionEnabled = true
            deactivateAccountView.addGestureRecognizer(deactivateGest)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        BindView()
        AttachViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.intiatimagePicker()
        // Add observer for the custom notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleDidUpdateValue(_:)), name: .didUpdateValue, object: nil)
    }
    
    deinit {
        // Remove observer in deinit to avoid memory leaks
        NotificationCenter.default.removeObserver(self, name: .didUpdateValue, object: nil)
    }
    
    // Handler for the custom notification
    @objc func handleDidUpdateValue(_ notification: Notification) {
        if let updatedValue = notification.object as? UserAddress {
            // Handle the updated value as needed
            print("Updated value received in FirstViewController: \(updatedValue)")
            self.viewModel.getAddresses()
        }
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: ProfileSelectAddressSwiftUIView(viewModel: self.viewModel), parent: self)
    }
    
    func BindView(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backbutton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        changePassGest.tapPublisher
            .sink(receiveValue:{_ in
                
            })
            .store(in: &bindings)
        
        deactivateGest.tapPublisher
            .sink(receiveValue:{_ in
                let vc = SwiftBottomSheet(initialHeight: 300, text1Name: "Are you sure you want to deactivate your account ?", text2Name: "", mainIconName: "switch", button1Text: "Yes", button2Text: "Cancel")
                vc.delegate = self
                self.presentBottomSheetInsideNavigationController(
                    viewController: vc,
                    configuration: BottomSheetConfiguration(
                        cornerRadius: 20,
                        pullBarConfiguration: .visible(.init(height: 20)),
                        shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
                    )
                )
            })
            .store(in: &bindings)
        
        addNewAddressButton.tapPublisher
            .sink { _ in
                let newViewController = LocationPickerView()
                let navigationController = UINavigationController(rootViewController: newViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                
                navigationController.setNavigationBarHidden(true, animated: false)
            }
            .store(in: &bindings)
        
        firstNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.userFirstName, on: viewModel)
        .store(in: &bindings)
        
        lastNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.userLastName, on: viewModel)
        .store(in: &bindings)
        
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEmail, on: viewModel)
        .store(in: &bindings)
        
        imageGest.tapPublisher
            .sink(receiveValue:{_ in
                self.pickImage()
            })
            .store(in: &bindings)
        
        viewModel.$userEmail.sink { v in
            self.firstNameTextField.text = self.viewModel.userFirstName
            self.lastNameTextField.text = self.viewModel.userLastName
            self.emailTextField.text = self.viewModel.userEmail
        }.store(in: &bindings)
        
        viewModel.$isProfileUpdated.sink { v in
            if v {
                self.navigationController?.popViewController(animated: true)
            }
        }.store(in: &bindings)
        
        viewModel.$isAccountDeleted.sink { v in
            if v {
                let vc = LoginView()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel.$userAddresses.sink { v in
            if v.count != 0{
                self.addressView.isHidden = false
                self.height.constant = CGFloat(v.count * 135)
            }else{
                self.addressView.isHidden = true
            }
        }.store(in: &bindings)
    }

}

struct ProfileSelectAddressSwiftUIView: View {
    
    @ObservedObject var viewModel: MyProfileViewModel
        
    var body: some View {
        VStack(alignment: .center){
            if self.viewModel.userAddresses.count > 0{
                ForEach(self.viewModel.userAddresses) { item in
                    AddressitemSwiftUIView(address: item)
                        .padding(5)
                        .onTapGesture {
                            self.viewModel.selectedAddress = item
                        }
                }
                Spacer()
            }
        }
    }
}

extension MyProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func intiatimagePicker(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [UTType.image.identifier]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        dismiss(animated: true, completion: nil)
    }
    
    func pickImage(){
        
        let alert = UIAlertController(title: MOLHLanguage.isRTLLanguage() ? "اختر صورة" : "Select Image", message: MOLHLanguage.isRTLLanguage() ? "حدد صورة من المعرض" : "Select Image From Gallery", preferredStyle: .actionSheet)
        
        let album = UIAlertAction(title: MOLHLanguage.isRTLLanguage() ? "حدد صورة من المعرض" : "Select Image From Gallery", style: .default, handler: {
            (action) -> Void in
            self.imagePicker.allowsEditing = true
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let camera = UIAlertAction(title: MOLHLanguage.isRTLLanguage() ? "التقط صورة بالكاميرا" : "Shot a Picture with Camera", style: .default, handler: {
            (action) -> Void in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: MOLHLanguage.isRTLLanguage() ? "ألغاء" : "Cancel", style: .cancel, handler: {
            (action) -> Void in
        })
        
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image : UIImage!
        
        if let img = info[.editedImage] as? UIImage{
            image = img
            self.profileImageView.image = image
            self.viewModel.newImageData = (image?.jpeg(.lowest))!
        }
        else if let img = info[.originalImage] as? UIImage{
            image = img
            self.profileImageView.image = image
            self.viewModel.newImageData = (image?.jpeg(.lowest))!
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.updateProfile()
        }
    }
}

extension MyProfileView: SwiftBottomSheetDelegate {
    func clickAssigned(buttonNumber: Int) {
        switch buttonNumber{
        case 1:
            self.dismiss(animated: true)
            self.viewModel.deleteAccount()
        case 2:
            self.dismiss(animated: true)
        default:
            print("")
        }
    }
}
