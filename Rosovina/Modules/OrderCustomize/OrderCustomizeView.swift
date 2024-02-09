//
//  OrderCustomizeView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 18/01/2024.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class OrderCustomizeView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: OrderCustomizeViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var cardsContainer: UIView!
    
    @IBOutlet weak var charsCounter: UILabel!
    
    @IBOutlet weak var toTextField: UITextField!
    
    @IBOutlet weak var messageView: UIView! {
        didSet {
            messageView.rounded()
        }
    }
    
    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            messageTextView.delegate = self
        }
    }
    
    @IBOutlet weak var linkView: UIView! {
        didSet {
            linkView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var linkTextView: UITextField!
    
    @IBOutlet weak var applyButton: UIButton! {
        didSet {
            applyButton.roundCornersForSpecificCorners(corners: [.topRight, .bottomRight], radius: 10)
        }
    }
    
    @IBOutlet weak var previewButton: UIButton! {
        didSet {
            previewButton.prettyHareefButton(radius: 16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.cardsContainer.EmbedSwiftUIView(view: GiftCardsSwiftUIView(viewModel: self.viewModel!), parent: self)
    }
    
    func BindViews(){
        
        viewModel!.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        toTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.toText, on: viewModel!)
        .store(in: &bindings)
        
        linkTextView.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.shareLink, on: viewModel!)
        .store(in: &bindings)
        
        viewModel!.$cartUpdated.sink { response in
            if response {
                let newViewController = CheckoutView()
                newViewController.viewModel = CheckoutViewModel(cartResponse: self.viewModel!.cartResponse)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel!.$errorMessage.sink { response in
            if response != "" {
                Alert.show("Customization Error", message: response, context: self)
            }
        }.store(in: &bindings)
                
        skipButton.tapPublisher
            .sink { _ in
                let newViewController = CheckoutView()
                newViewController.viewModel = CheckoutViewModel(cartResponse: self.viewModel!.cartResponse)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
            .store(in: &bindings)
        
        applyButton.tapPublisher
            .sink { _ in
                self.linkTextView.isEnabled = false
            }
            .store(in: &bindings)
        
        previewButton.tapPublisher
            .sink { _ in
                self.viewModel!.updateCartForCustomize()
            }
            .store(in: &bindings)
    }
}

extension OrderCustomizeView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "card message" {
            textView.text = ""
            textView.textColor = .black
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "card message"
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Calculate the current text in the UITextView
        let text = textView.text.trimmingWhitespace()
        
//        if text.count > 0 && text != "card message"{
//            previewButton.isEnabled = true
//        }else{
//            previewButton.isEnabled = false
//        }

        // Define a maximum character count
        let maxCharacterCount = 191 // Change this to your desired maximum character count

        // Update the character count label
        charsCounter.text = "\(text.count) / \(maxCharacterCount + 1)" + " Characters"
        viewModel!.messageText = text

        // Optionally, limit the character count
        if text.count > maxCharacterCount {
            // Truncate the text to the maximum character count
            let endIndex = text.index(text.startIndex, offsetBy: maxCharacterCount)
            textView.text = String(text[text.startIndex ..< endIndex])
        }
    }
}

struct GiftCardsSwiftUIView: View {
    
    @ObservedObject var viewModel: OrderCustomizeViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(self.viewModel.giftCards) { card in
                    GiftCardItemSwiftUIView(viewModel: viewModel, giftCard: card)
                        .onTapGesture {
                            HapticFeedBackEngine.shared.successFeedback()
                            self.viewModel.selectedGiftCardID = card.id
                        }
                }
                Spacer()
            }
        }
    }
}

struct GiftCardItemSwiftUIView: View {
    
    @ObservedObject var viewModel: OrderCustomizeViewModel
        
    var giftCard: GiftCard
    
    var body: some View {
        WebImage(url: URL(string: giftCard.imagePath))
            //.placeholder(Image("flower5").resizable())
            .resizable()
            .indicator(.activity)
            .scaledToFit()
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("AccentColor"), lineWidth: viewModel.selectedGiftCardID == giftCard.id ? 2 : 0)
            )
            .frame(width: 95, height: 90)
            .padding()
    }
}
