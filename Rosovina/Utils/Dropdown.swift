//
//  Dropdown.swift
//  JDAWidgets SwiftUI
//
//  Created by Jeevan Rao on 18/12/21.
//  Copyright © 2021 JDA. All rights reserved.
//

import SwiftUI

struct Dropdown: View {
    
    var selection: DropDownSelection
    var placeholder: String
    @ObservedObject var viewModel: AddAddressViewModel
    
    var body: some View {
        Menu {
            switch selection{
            case .countries:
                ForEach(viewModel.countries) { item in
                    Button(item.name) {
                        viewModel.selectedCountry = item
                    }
                }
            case .cities:
                ForEach(viewModel.cities) { item in
                    Button(item.name) {
                        viewModel.selectedCity = item
                    }
                }
            case .areas:
                ForEach(viewModel.areas) { item in
                    Button(item.name) {
                        viewModel.selectedArea = item
                    }
                }
            }
        } label: {
            VStack(spacing: 5){
                HStack{
                    switch selection{
                    case .countries:
                        Text(viewModel.selectedCountry == nil ? placeholder : viewModel.selectedCountry!.name)
                            .foregroundColor(viewModel.selectedCountry == nil ? .gray : .black)
                    case .cities:
                        Text(viewModel.selectedCity == nil ? placeholder : viewModel.selectedCity!.name)
                            .foregroundColor(viewModel.selectedCity == nil ? .gray : .black)
                    case .areas:
                        Text(viewModel.selectedArea == nil ? placeholder : viewModel.selectedArea!.name)
                            .foregroundColor(viewModel.selectedArea == nil ? .gray : .black)
                    }
                    Spacer()
                    Image("Polygon 2")
                        .resizable()
                        .frame(width: 13, height: 10)
//                    Image(systemName: "chevron.down")
//                        .foregroundColor(Color.gray.opacity(0.33))
//                        .font(Font.system(size: 20, weight: .semibold))
                }
                .padding(.horizontal)
                
//                Rectangle()
//                    .fill(Color.gray.opacity(0.33))
//                    .frame(height: 1)
            }
        }
        //.frame(width: 300)
    }
}


struct LanguageDropdown: View {
    
    var placeholder: String
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Menu {
            ForEach(viewModel.languages) { item in
                Button(item.name) {
                    viewModel.selectedLanguage = item
                }
            }
        } label: {
            VStack(spacing: 5){
                HStack{
                    Text(viewModel.selectedLanguage.name)
                        .foregroundColor(.black)
                    Spacer()
                    Image("Polygon 2")
                        .resizable()
                        .frame(width: 13, height: 10)
//                    Image(systemName: "chevron.down")
//                        .foregroundColor(Color.gray.opacity(0.33))
//                        .font(Font.system(size: 20, weight: .semibold))
                }
                .padding(.horizontal)
                
//                Rectangle()
//                    .fill(Color.gray.opacity(0.33))
//                    .frame(height: 1)
            }
        }
        //.frame(width: 300)
    }
}
