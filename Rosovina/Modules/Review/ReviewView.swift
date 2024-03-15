//
//  ReviewView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit
import SDWebImage
import Combine
import CombineCocoa

class ReviewView: UIViewController {

    private var bindings = Set<AnyCancellable>()
    
    var viewModel: AddReviewViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backPressed: UIButton!
    
    @IBOutlet weak var productView: UIView! {
        didSet {
            productView.rounded()
        }
    }
    
    @IBOutlet weak var productImage: UIImageView! {
        didSet {
            productImage.makeRounded()
        }
    }
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productCategory: UILabel!
    
    var startOneGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var starTwoGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var starThreeGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var starFourGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var starfiveGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var startOne: UIImageView! {
        didSet {
            startOne.isUserInteractionEnabled = true
            startOne.addGestureRecognizer(startOneGest)
        }
    }
    @IBOutlet weak var starTwo: UIImageView! {
        didSet {
            starTwo.isUserInteractionEnabled = true
            starTwo.addGestureRecognizer(starTwoGest)
        }
    }
    @IBOutlet weak var starThree: UIImageView! {
        didSet {
            starThree.isUserInteractionEnabled = true
            starThree.addGestureRecognizer(starThreeGest)
        }
    }
    @IBOutlet weak var starFour: UIImageView! {
        didSet {
            starFour.isUserInteractionEnabled = true
            starFour.addGestureRecognizer(starFourGest)
        }
    }
    @IBOutlet weak var starfive: UIImageView! {
        didSet {
            starfive.isUserInteractionEnabled = true
            starfive.addGestureRecognizer(starfiveGest)
        }
    }
    
    @IBOutlet weak var rateNumber: UILabel!
    
    @IBOutlet weak var commentView: UIView! {
        didSet {
            commentView.roundedLightGrayHareefView()
        }
    }
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var sendReviewButton: UIButton! {
        didSet {
            sendReviewButton.prettyHareefButton(radius: 16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }
    
    func BindViews(){
        
        viewModel!.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        sendReviewButton.tapPublisher
            .sink { _ in
                self.viewModel?.AddReview()
            }
            .store(in: &bindings)
        
        backPressed.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        commentTextView.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.commentValue, on: viewModel!)
            .store(in: &bindings)
        
        self.productImage.sd_setImage(with: URL(string: self.viewModel?.productImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholderImage: UIImage(named: "flower5.png"))
        self.productName.text = self.viewModel?.productName
        
        startOneGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.rateValue = 1
            })
            .store(in: &bindings)
        
        starTwoGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.rateValue = 2
            })
            .store(in: &bindings)
        
        starThreeGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.rateValue = 3
            })
            .store(in: &bindings)
        
        starFourGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.rateValue = 4
            })
            .store(in: &bindings)
        
        starfiveGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.rateValue = 5
            })
            .store(in: &bindings)
        
        viewModel!.$productReviewed.sink { v in
            if v {
                self.navigationController?.popViewController(animated: true)
            }
        }.store(in: &bindings)
        
        viewModel!.$rateValue.sink { v in
            if v != 0{
                switch v {
                case 1:
                    self.startOne.image = UIImage(named: "StarBig")
                    self.starTwo.image = UIImage(named: "Star-Gray")
                    self.starThree.image = UIImage(named: "Star-Gray")
                    self.starFour.image = UIImage(named: "Star-Gray")
                    self.starfive.image = UIImage(named: "Star-Gray")
                    
                    self.rateNumber.text = "1/5"
                case 2:
                    self.startOne.image = UIImage(named: "StarBig")
                    self.starTwo.image = UIImage(named: "StarBig")
                    self.starThree.image = UIImage(named: "Star-Gray")
                    self.starFour.image = UIImage(named: "Star-Gray")
                    self.starfive.image = UIImage(named: "Star-Gray")
                    
                    self.rateNumber.text = "2/5"
                case 3:
                    self.startOne.image = UIImage(named: "StarBig")
                    self.starTwo.image = UIImage(named: "StarBig")
                    self.starThree.image = UIImage(named: "StarBig")
                    self.starFour.image = UIImage(named: "Star-Gray")
                    self.starfive.image = UIImage(named: "Star-Gray")
                    
                    self.rateNumber.text = "3/5"
                case 4:
                    self.startOne.image = UIImage(named: "StarBig")
                    self.starTwo.image = UIImage(named: "StarBig")
                    self.starThree.image = UIImage(named: "StarBig")
                    self.starFour.image = UIImage(named: "StarBig")
                    self.starfive.image = UIImage(named: "Star-Gray")
                    
                    self.rateNumber.text = "4/5"
                case 5:
                    self.startOne.image = UIImage(named: "StarBig")
                    self.starTwo.image = UIImage(named: "StarBig")
                    self.starThree.image = UIImage(named: "StarBig")
                    self.starFour.image = UIImage(named: "StarBig")
                    self.starfive.image = UIImage(named: "StarBig")
                    
                    self.rateNumber.text = "5/5"
                default:
                    print(v)
                }
            }
        }.store(in: &bindings)
    }

}
