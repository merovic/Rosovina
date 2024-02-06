//
//  FilterView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import WARangeSlider
import SnapKit

protocol FilterDelegate {
    func filterAssigned(categories: [Int], priceRange: [Int], brands: [Int], rating: [Int])
}

class FilterView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: FilterViewModel = FilterViewModel()
    
    var delegate: FilterDelegate!
    
    @IBOutlet weak var rangleSlider: RangeSlider! {
        didSet{
            rangleSlider.trackHighlightTintColor = UIColor.init(named: "AccentColor")!
            rangleSlider.thumbTintColor = UIColor.init(named: "DarkRed")!
            rangleSlider.maximumValue = 5000
            rangleSlider.minimumValue = 500
            
            rangleSlider.lowerValue = 600
            rangleSlider.upperValue = 3000
        }
    }
    
    @IBOutlet weak var rangeText: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var applyButton: UIButton! {
        didSet {
            applyButton.prettyHareefButton(radius: 16)
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: FilterSwiftUIView(viewModel: viewModel), parent: self)
    }
    
    @IBAction func applyFilterClicked(_ sender: Any) {
        self.delegate.filterAssigned(categories: self.viewModel.selectedCategories, priceRange: [self.viewModel.maximumPriceRange, self.viewModel.maximumPriceRange], brands: [], rating: [self.viewModel.currentRate])
        self.dismiss(animated: true)
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

    @IBAction func valueChanged(_ sender: RangeSlider) {
        self.viewModel.minimumPriceRange = Int(rangleSlider.lowerValue)
        self.viewModel.maximumPriceRange = Int(rangleSlider.upperValue)
        self.rangeText.text = "Between: " + String(Int(rangleSlider.lowerValue)) + " SAR - " + String(Int(rangleSlider.upperValue)) + " SAR"
    }
}

struct FilterSwiftUIView: View {
    
    @ObservedObject var viewModel: FilterViewModel
    
    @State
    var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            VStack(alignment: .leading){
                Text("Categories")
                    .font(.poppinsFont(size: 16, weight: .bold))
                    .foregroundColor(Color("AccentColor"))
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(self.viewModel.categories) { item in
                            FilterItem(item: item, selectedCategories: $viewModel.selectedCategories)
                        }
                        Spacer()
                    }
                }
            }
            
            VStack(alignment: .leading){
                Text("Brands")
                    .font(.poppinsFont(size: 16, weight: .bold))
                    .foregroundColor(Color("AccentColor"))
                
                TextField("Search", text: $searchText)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color("LightGray"), style: StrokeStyle(lineWidth: 1.0)))
                    .onChange(of: searchText) { newSearchText in
                        filterArray()
                    }
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(0..<viewModel.filteredBrands.count, id: \.self) { index in
                            BrandItem(item: viewModel.brands[index], selectedBrands: $viewModel.brands)
                        }
                        Spacer()
                    }
                }
            }
            
            VStack(alignment: .leading){
                Text("Rating")
                    .font(.poppinsFont(size: 16, weight: .bold))
                    .foregroundColor(Color("AccentColor"))
                
                HStack{
                    Image(viewModel.currentRate >= 1 ? "Star" : "Star-Gray")
                        .resizable()
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            viewModel.currentRate = 1
                        }
                    
                    Image(viewModel.currentRate >= 2 ? "Star" : "Star-Gray")
                        .resizable()
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            viewModel.currentRate = 2
                        }
                    
                    Image(viewModel.currentRate >= 3 ? "Star" : "Star-Gray")
                        .resizable()
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            viewModel.currentRate = 3
                        }
                    
                    Image(viewModel.currentRate >= 4 ? "Star" : "Star-Gray")
                        .resizable()
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            viewModel.currentRate = 4
                        }
                    
                    Image(viewModel.currentRate == 5 ? "Star" : "Star-Gray")
                        .resizable()
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            viewModel.currentRate = 5
                        }
                }
            }
            
        }
    }
    
    func filterArray() {
            if searchText.isEmpty {
                self.viewModel.filteredBrands = self.viewModel.brands
            } else {
                self.viewModel.filteredBrands = self.viewModel.brands.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        }
    
}

struct FilterItem: View {
    
    var item: Category
    @Binding
    var selectedCategories: [Int]
    
    var body: some View {
        Text(item.title)
            .font(.poppinsFont(size: 16, weight: .medium))
            .padding()
            .background(selectedCategories.contains(item.id) ? Color("RoseColor") : Color("LightGray"))
            .cornerRadius(12)
            .onTapGesture {
                if selectedCategories.contains(item.id){
                    if let index = selectedCategories.firstIndex(of: item.id) {
                        selectedCategories.remove(at: index)
                    }
                }else{
                    selectedCategories.append(item.id)
                }
            }
    }
}

struct BrandItem: View {
    
    var item: String
    @Binding
    var selectedBrands: [String]
    
    var body: some View {
        Text(item)
            .font(.poppinsFont(size: 16, weight: .medium))
            .padding()
            .background(selectedBrands.contains(item) ? Color("RoseColor") : Color("LightGray"))
            .cornerRadius(12)
    }
}
