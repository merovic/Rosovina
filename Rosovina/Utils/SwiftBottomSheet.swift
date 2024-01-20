//
//  SwiftBottomSheet.swift
//  Hareef-Captain
//
//  Created by Amir Ahmed on 21/07/2023.
//

import UIKit
import SnapKit

protocol SwiftBottomSheetDelegate {
    func clickAssigned(buttonNumber: Int)
}

class SwiftBottomSheet: UIViewController {

    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var mainIcon: UIImageView!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    var delegate: SwiftBottomSheetDelegate!
    
    private var currentHeight: CGFloat {
        didSet {
            updatePreferredContentSize()
        }
    }
    
    private var text1Name: String {
        didSet {
            self.text1.text = text1Name
        }
    }
    
    private var text2Name: String {
        didSet {
            self.text2.text = text2Name
        }
    }
    
    private var mainIconName: String {
        didSet {
            self.mainIcon.image = UIImage(named: mainIconName)
        }
    }
    
    private var button1Text: String {
        didSet {
            firstButton.prettyHareefButton2(radius: 24.0)
            self.firstButton.setTitle(button1Text, for: .normal)
        }
    }
    
    private var button2Text: String {
        didSet {
            secondButton.prettyHareefButton(radius: 24.0)
            self.secondButton.setTitle(button2Text, for: .normal)
        }
    }
    
    private let _scrollView = UIScrollView()
    
    // MARK: - Init

    init(initialHeight: CGFloat, text1Name: String, text2Name: String, mainIconName: String, button1Text: String, button2Text: String) {
        self.currentHeight = initialHeight
        self.text1Name = text1Name
        self.text2Name = text2Name
        self.mainIconName = mainIconName
        self.button1Text = button1Text
        self.button2Text = button2Text
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize()
        updateValues()
    }
    
    // MARK: - Private methods
    private func updatePreferredContentSize() {
        _scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        preferredContentSize = _scrollView.contentSize
    }
    
    // MARK: - Private methods
    private func updateValues() {
        self.text1.text = text1Name
        if self.text1Name == ""{
            self.text1.isHidden = true
        }
        self.text2.text = text2Name
        if self.text2Name == ""{
            self.text2.isHidden = true
        }
        self.mainIcon.image = UIImage(named: mainIconName)
        self.firstButton.prettyHareefButton2(radius: 24.0)
        self.firstButton.setTitle(button1Text, for: .normal)
        self.secondButton.prettyHareefButton(radius: 24.0)
        self.secondButton.setTitle(button2Text, for: .normal)
    }
    
    private func updateContentHeight(newValue: CGFloat) {
        guard newValue >= 200, newValue < 5000 else { return }

        let updates = { [self] in
            currentHeight = newValue
            updatePreferredContentSize()
        }

        if navigationController == nil {
            UIView.animate(withDuration: 0.25, animations: updates)
        } else {
            updates()
        }
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(_scrollView)
        _scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        _scrollView.alwaysBounceVertical = true
    }
    
    
    @IBAction func button1Clicked(_ sender: Any) {
        delegate?.clickAssigned(buttonNumber: 1)
        self.dismiss(animated: true)
    }
    
    
    @IBAction func button2Clicked(_ sender: Any) {
        delegate?.clickAssigned(buttonNumber: 2)
        self.dismiss(animated: true)
    }
    
}
