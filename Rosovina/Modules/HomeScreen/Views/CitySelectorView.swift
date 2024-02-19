//
//  CitySelectorView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 19/02/2024.
//

import UIKit
import SnapKit
import Combine

protocol CitySelectorBottomSheetDelegate {
    func clickAssigned(selectedCity: GeoLocationAPIResponseElement)
}

class CitySelectorView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: InitCountryViewModel = InitCountryViewModel()
    
    var delegate: CitySelectorBottomSheetDelegate!
        
    private var currentHeight: CGFloat {
        didSet {
            updatePreferredContentSize()
        }
    }

    private let _scrollView = UIScrollView()
    
    // MARK: - Init

    init(initialHeight: CGFloat) {
        self.currentHeight = initialHeight
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize()
        AttachViews()
        
        viewModel.$continueClicked.sink { response in
            if response {
                self.delegate.clickAssigned(selectedCity: self.viewModel.selectedCity!)
                self.dismiss(animated: true)
            }
        }.store(in: &bindings)
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: InitCountryViewSwiftUIView(viewModel: self.viewModel), parent: self)
    }
    
    // MARK: - Private methods
    private func updatePreferredContentSize() {
        _scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        preferredContentSize = _scrollView.contentSize
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

}
