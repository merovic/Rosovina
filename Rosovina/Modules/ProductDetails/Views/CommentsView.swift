//
//  CommentsView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

class CommentsView: UIViewController {

    @IBOutlet weak var container: UIView!
    
    var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: CommentsSwiftUIView(reviews: reviews), parent: self)
    }

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

struct CommentsSwiftUIView: View {
    
    var reviews: [Review]
    
    var body: some View {
        ZStack(alignment: .center){
            if reviews.count > 0{
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        ForEach(reviews) { review in
                            CommentItemSwiftUIView(review: review)
                        }
                    }
                }
            }else{
                VStack{
                    Text("comments_list_is_empty".localized)
                        .font(.poppinsFont(size: 25, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    Spacer().frame(height: 300)
                }
            }
        }
    }
}


struct CommentItemSwiftUIView: View {
    
    var review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2){
            HStack{
                HStack{
                    WebImage(url: URL(string: review.userImage))
                        //.placeholder(Image("Rectangle 32").resizable())
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 27, height: 27)
                        .clipShape(Circle())
                    
                    Text(review.userName)
                        .font(.poppinsFont(size: 16, weight: .medium))
                        .foregroundColor(Color.gray)
                }
                
                Spacer()
                
                HStack{
                    Text(String(review.rate))
                        .font(.poppinsFont(size: 14, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Image("Star")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
            }
            
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    Spacer().frame(width: 10)
                    Image("Triangle")
                        .resizable()
                        .frame(width: 19, height: 17)
                }
                
                HStack{
                    Text(review.comment)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .font(.poppinsFont(size: 16, weight: .regular))
                        .padding()
                        .background(Color("LightGray"))
                        .cornerRadius(20)
                    
                    Spacer()
                }

            }
        }.frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
}
