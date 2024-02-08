//
//  ProductDetailsView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit
import Combine
import CombineCocoa
import SDWebImage

protocol CartDelegate {
    func cartAssigned(quantity: Int)
}

class ProductDetailsView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: ProductDetailsViewModel?
    
    private let loadingView = LoadingAnimation()
    
    var delegate: CartDelegate!

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var imageOneGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var imageOne: UIImageView! {
        didSet{
            imageOne.makeRounded()
            imageOne.isUserInteractionEnabled = true
            imageOne.addGestureRecognizer(imageOneGest)
        }
    }
    
    @IBOutlet weak var imageOneDot: UIImageView!
    
    var imageTwoGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var imageTwo: UIImageView! {
        didSet{
            imageTwo.makeRounded()
            imageTwo.isUserInteractionEnabled = true
            imageTwo.addGestureRecognizer(imageTwoGest)
        }
    }
    
    @IBOutlet weak var imageTwoDot: UIImageView!
    
    var imageThreeGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var imageThree: UIImageView! {
        didSet{
            imageThree.makeRounded()
            imageThree.isUserInteractionEnabled = true
            imageThree.addGestureRecognizer(imageThreeGest)
        }
    }
    
    @IBOutlet weak var imageThreeDot: UIImageView!
    
    var descriptionStackGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var descriptionStack: UIStackView! {
        didSet{
            descriptionStack.isUserInteractionEnabled = true
            descriptionStack.addGestureRecognizer(descriptionStackGest)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionStrip: UIView!
    
    var reviewsStackGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var reviewsStack: UIStackView! {
        didSet{
            reviewsStack.isUserInteractionEnabled = true
            reviewsStack.addGestureRecognizer(reviewsStackGest)
        }
    }
    
    var informationsStackGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var informationsStack: UIStackView! {
        didSet{
            informationsStack.isUserInteractionEnabled = true
            informationsStack.addGestureRecognizer(informationsStackGest)
        }
    }
    
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var informationStrip: UIView!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var informationTextView: UITextView!
    
    var addToCartGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var addToWishListButton: UIButton!
    
    @IBOutlet weak var addToCartButton: UIView! {
        didSet {
            addToCartButton.rounded()
            addToCartButton.isUserInteractionEnabled = true
            addToCartButton.addGestureRecognizer(addToCartGest)
        }
    }
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }
    
    func BindViews(){
        
        viewModel?.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        plusButton.tapPublisher
            .sink { _ in
                self.viewModel?.increaseQuantity()
            }
            .store(in: &bindings)
        
        minusButton.tapPublisher
            .sink { _ in
                self.viewModel?.decressQuantity()
            }
            .store(in: &bindings)
        
        addToCartGest.tapPublisher
            .sink { _ in
//                if LoginDataService.shared.isLogedIn() {
//                    self.viewModel?.updateCart()
//                }else{
//                    let newViewController = NeedLoginView()
//                    newViewController.showBackButton = true
//                    self.navigationController?.pushViewController(newViewController, animated: true)
//                }
                self.viewModel?.updateCart()
            }
            .store(in: &bindings)
        
        addToWishListButton.tapPublisher
            .sink { _ in
                if self.viewModel?.productDetails?.addedToWishlist ?? false {
                    self.viewModel?.removeItemFromWishlist()
                    self.addToWishListButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }else{
                    self.viewModel?.addItemToWishlist()
                    self.addToWishListButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
            }
            .store(in: &bindings)
        
        imageOneGest.tapPublisher
            .sink(receiveValue:{_ in
                self.imageOneDot.isHidden = false
                self.imageTwoDot.isHidden = true
                self.imageThree.isHidden = true
                
                self.imageOne.makeRounded()
                
                self.mainImage.sd_setImage(with: URL(string: self.viewModel?.productDetails?.imageURL ?? ""))
            })
            .store(in: &bindings)
        
        imageTwoGest.tapPublisher
            .sink(receiveValue:{_ in
                self.imageOneDot.isHidden = true
                self.imageTwoDot.isHidden = false
                self.imageThree.isHidden = true
                
                self.imageTwo.makeRounded()
                
                self.mainImage.sd_setImage(with: URL(string: self.viewModel?.productDetails?.images[0] ?? ""))
            })
            .store(in: &bindings)
        
        imageThreeGest.tapPublisher
            .sink(receiveValue:{_ in
                self.imageOneDot.isHidden = true
                self.imageTwoDot.isHidden = true
                self.imageThree.isHidden = false
                
                self.imageThree.makeRounded()
                
                self.mainImage.sd_setImage(with: URL(string: self.viewModel?.productDetails?.images[1] ?? ""))
            })
            .store(in: &bindings)
        
        descriptionStackGest.tapPublisher
            .sink(receiveValue:{_ in
                self.descriptionStrip.isHidden = false
                self.descriptionLabel.textColor = UIColor.init(named: "AccentColor")
                self.informationLabel.textColor = UIColor.lightGray
                self.informationStrip.isHidden = true
                
                self.informationTextView.text = self.viewModel?.productDetails?.description
            })
            .store(in: &bindings)
        
        reviewsStackGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = CommentsView()
                newViewController.reviews = self.viewModel?.productDetails?.reviews ?? []
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        informationsStackGest.tapPublisher
            .sink(receiveValue:{_ in
                self.descriptionStrip.isHidden = true
                self.informationLabel.textColor = UIColor.init(named: "AccentColor")
                self.descriptionLabel.textColor = UIColor.lightGray
                self.informationStrip.isHidden = false
                
                self.informationTextView.text = self.viewModel?.productDetails?.additionalInfo.htmlToString
            })
            .store(in: &bindings)
        
        viewModel?.$productQuantityText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: quantityLabel)
            .store(in: &bindings)
        
        viewModel!.$itemAdded.sink { v in
            if v{
                self.delegate?.cartAssigned(quantity: self.viewModel?.cartResponse?.itemsQuantity ?? 0)
                self.navigationController?.popViewController(animated: true)
            }
        }.store(in: &bindings)
        
        viewModel?.$productDetails.sink { product in
            if product != nil{
                self.mainImage.sd_setImage(with: URL(string: product!.imageURL), placeholderImage: UIImage(named: "placeholder.png"))
                
                self.imageThree.isHidden = !(product!.images.count == 3)
                
                self.imageOne.sd_setImage(with: URL(string: product!.imageURL), placeholderImage: UIImage(named: "placeholder.png"))
                
                if !product!.images.isEmpty{
                    self.imageTwo.sd_setImage(with: URL(string: product!.images[0]), placeholderImage: UIImage(named: "placeholder.png"))
                    if product!.images.count > 1 {
                        self.imageThree.sd_setImage(with: URL(string: product!.images[1]), placeholderImage: UIImage(named: "placeholder.png"))
                    } else{
                        self.imageTwo.isHidden = true
                    }
                } else{
                    self.imageTwo.isHidden = true
                    self.imageThree.isHidden = true
                }
                
                self.titleLabel.text = product!.title
                self.priceLabel.text = (product!.currencyCode ?? "SAR") + " " + String(product!.price.rounded())
                
                self.informationTextView.text = product!.description
                //heart
                self.addToWishListButton.setImage(UIImage(systemName: product!.addedToWishlist ?? false ? "heart.fill" : "heart"), for: .normal)
            }
        }.store(in: &bindings)
    }

}
