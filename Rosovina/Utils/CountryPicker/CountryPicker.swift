//
//  CountryPicker.swift
//  JDA Country Picker
//
//  Created by Jeevan on 04/07/20.
//  Copyright © 2020 JDA. All rights reserved.
//

import SwiftUI

struct CountryPicker: View {
    
    @ObservedObject var viewModel = CountryPickerViewModel()
    //@State var selectedCountry = ""
    @State var selectedFlag: Image? = Image("SAX")
    var placeholder = "+966"
    var dropDownList = Country.countryNamesByCode()
    
    var body: some View {
        Menu {
            ForEach(dropDownList, id: \.self) { client in
                Button(action: {
                    self.viewModel.phoneCode = client.phoneCode
                    self.selectedFlag = client.flag
                }) {
                    HStack{
                        Text(client.name)
                            .foregroundColor(client.name.isEmpty ? .gray : .black)
                        Spacer()
                        
                        client.flag
                    }
                    .padding(.horizontal)
                    
                }
            }
            
        } label: {
            
            VStack(spacing: 5){
                HStack{
                    if selectedFlag != nil{
                        selectedFlag!
                            .resizable()
                            .frame(width: 27, height: 18)
                    }
                    
                    Text(self.viewModel.phoneCode.isEmpty ? placeholder : self.viewModel.phoneCode)
                        .foregroundColor(self.viewModel.phoneCode.isEmpty ? .gray : .black)
                        .font(.poppinsFont(size: 14, weight: .regular))
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.gray.opacity(0.33))
                        .frame(width: 13, height: 10)
                }
            }
            .frame(width: 100)
        }
        
    }
    
}

struct CountryPicker_Previews: PreviewProvider {
    static var previews: some View {
        CountryPicker()
    }
}

class CountryPickerViewModel: ObservableObject {
    @Published var phoneCode = "+966"
}


