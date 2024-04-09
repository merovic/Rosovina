//
//  InitCountryView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 18/02/2024.
//

import UIKit
import Combine
import SwiftUI
import SDWebImageSwiftUI

class InitCountryView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: InitCountryViewModel = InitCountryViewModel()

    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
        
        viewModel.$continueClicked.sink { response in
            if response {
                LoginDataService.shared.setUserCountry(country: self.viewModel.selectedCountry!)
                LoginDataService.shared.setUserCity(city: self.viewModel.selectedCity!)
                let newViewController = LoginView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: InitCountryViewSwiftUIView(viewModel: self.viewModel), parent: self)
    }

}


struct InitCountryViewSwiftUIView: View {
    
    @ObservedObject var viewModel: InitCountryViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("deliver_to_country".localized)
                .lineLimit(1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(SwiftUI.Color.black)
            
            HStack{
                ForEach(self.viewModel.countries) { country in
                    CountryListItem(country: country, viewModel: viewModel)
                }
                Spacer()
            }
            
            Text("deliver_to_city".localized)
                .lineLimit(1)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(SwiftUI.Color.black)
                .padding(.top, 35)
            
            ScrollView(showsIndicators: false){
                ForEach(self.viewModel.cities) { city in
                    CityListItem(city: city, viewModel: viewModel)
                }
            }
            
            Spacer()
            
            if viewModel.selectedCity != nil {
                MainAppButtonSwiftUI(buttonText: "continue1".localized) {
                    viewModel.continueClicked = true
                }.padding(.horizontal, 16)
                    .padding(.top, 10)
            }
            
        }.padding(10)
    }
    
}

struct CountryListItem: View {
    
    var country: GeoLocationAPIResponseElement
    
    @ObservedObject var viewModel: InitCountryViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                WebImage(url: URL(string: country.image_path ?? ""))
                    .resizable()
                    .frame(width: 48, height: 48)
                
                Text(country.name)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .semibold, design: .default))
                    .foregroundColor(SwiftUI.Color.black)
            }.padding()
        }
        .frame(minWidth: 120, maxWidth: 120, minHeight: 120, maxHeight: 120, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(viewModel.selectedCountry?.id == country.id ? SwiftUI.Color("AccentColor") : SwiftUI.Color.gray , lineWidth: viewModel.selectedCountry?.id == country.id ? 3 : 1)
        )
        .cornerRadius(8)
        .onTapGesture {
            viewModel.selectedCountry = country
        }
    }
}

struct CityListItem: View {
    
    var city: GeoLocationAPIResponseElement
    
    @ObservedObject var viewModel: InitCountryViewModel
    
    var body: some View {
        Button(action: {
            viewModel.selectedCity = city
        }) {
            ZStack {
                HStack(spacing: 10) {
                    WebImage(url: URL(string: viewModel.selectedCountry?.image_path ?? ""))
                        .resizable()
                        .frame(width: 48, height: 48)
                    
                    Text(city.name)
                        .lineLimit(1)
                        .font(.system(size: 12, weight: .semibold, design: .default))
                        .foregroundColor(SwiftUI.Color.black)
                    
                    Spacer()
                    
                }.padding()
                
            }
            .frame(minHeight: 75, maxHeight: 75, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.selectedCity?.id == city.id ? SwiftUI.Color("AccentColor") : SwiftUI.Color.gray , lineWidth: viewModel.selectedCity?.id == city.id ? 3 : 1)
            )
            .cornerRadius(8)
        }
    }
}


struct MainAppButtonSwiftUI: View {
    var buttonText: String
    var iconName: String? // Optional icon
    var isEnabled: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }, label: {
            HStack {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                        .padding(.trailing, 8)
                }
                Text(buttonText)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(PrimaryButtonStyle(isEnabled: isEnabled))
            .foregroundColor(SwiftUI.Color(isEnabled ? "BackgroundGray" : "BackgroundGray"))
            .padding()
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(SwiftUI.Color(isEnabled ? "AccentColor" : "BackgroundGray"))
            )
        })
    }
}


struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(isEnabled ? "RoseColor" : "RoseColor"))
            )
            .opacity(isEnabled ? 1 : 0.5)
    }
}
