//
//  CreateActivityView.swift
//  AuTime
//
//  Created by Victor Vieira on 04/08/21.
//

import SwiftUI

struct CreateActivityView: View {
    @State var activityName = ""
    @State var activityCategory = ""
    @State var activityTime = ""
    @State var generateStar = false
    @State var weeklyRepeat = false
    var colorTheme: Color = .blue
    var weekDays = ["S","T","Q","Q","S","S","D"]
    var subActivities: [String] = ["oi"]
    
    @State var activity = Activity(id: "", category: "", complete: Date(), generateStar: false, name: "", repeatDays: [], time: Date())
    
    var categories = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = "select"
    
    
    func getIconImage() -> Image{
        return Image(systemName: "heart.fill")
    }
    
    var body: some View {
        GeometryReader{ geometry in
            
            VStack(alignment: .leading){
//                ZStack{
//                    Rectangle()
//                        .fill(Color.blue)
//                        .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
//                        .cornerRadius(60, .bottomRight)
//
                    Text("Create Activity")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                //}
                HStack{
                    Spacer(minLength: geometry.size.width * 0.05)
                    VStack{
                HStack(alignment: .center){
                    VStack(alignment: .leading){
                        Text("Image:")
                            .fontWeight(.bold)
                            .padding([.leading, .top, .trailing])
                        Image("breakfast")
                            .frame(width: geometry.size.height * 0.16 * 1.75, height: geometry.size.height * 0.16)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(21)
                            .padding([.leading, .bottom, .trailing])
                        Text("Activity's name:")
                            .fontWeight(.bold)
                            .padding([.leading, .top, .trailing])
                        TextField("nome da atividade", text: $activityName).textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .bottom, .trailing])
                            .frame(width: geometry.size.width * 0.4, height: 30, alignment: .center)
                        Text("Activity's category:")
                            .fontWeight(.bold)
                            .padding([.leading, .top, .trailing])
                        Section{
                            HStack{
                                Picker(selectedColor, selection: $selectedColor) {
                                    ForEach(categories, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: geometry.size.width * 0.38, height: 30, alignment: .leading)
                                .padding(.leading)
                                
                                
                                
                            }
                            HStack{
                                Text("Generate star")
                                    .fontWeight(.bold)
                                    .padding()
                                Spacer()
                                Toggle("", isOn: $generateStar)
                                    .frame(width: 50)
                            }.frame(width: geometry.size.width * 0.4)
                            
                        }
                        
                        
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Tips:")
                            .fontWeight(.bold)
                            .padding()
                        Text("1. Use simple words, action verbs")
                            .padding(.leading)
                            .padding([.leading, .bottom])
                        Text("2. On steps, use one or two words")
                            .padding(.leading)
                            .padding([.leading, .bottom])
                        Text("3. On steps, use one or two words")
                            .padding(.leading)
                            .padding([.leading, .bottom])
                        Text("Activity's time")
                            .fontWeight(.bold)
                            .padding()
                        Text("10:00")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                            .frame(height: 20)
                            .background(Color.blue)
                            .cornerRadius(14)
                            .padding(.leading)
                        Text("Days of week")
                            .fontWeight(.bold)
                            .padding()
                        HStack{
                            ForEach(0..<7){ dia in
                                ZStack{
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                    Text(weekDays[dia])
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                //Spacer()
                            }
                        }.padding(.leading)
                        HStack{
                            Text("Repeat weekly")
                                .fontWeight(.bold)
                                .padding()
                            Spacer()
                            Toggle("", isOn: $weeklyRepeat)
                                .frame(width: 50)
                                .padding(.trailing)
                            
                        }.frame(width: geometry.size.width * 0.4)
                    }
                    .frame(width: geometry.size.width * 0.4, alignment: .trailing)
                }
                    VStack(alignment: .leading){
                Text("Steps:")
                    .fontWeight(.bold)
                    .padding(.leading)
                ScrollView(.horizontal){
                    HStack{
                        ForEach(0..<subActivities.count + 1){ index in
                            if index == subActivities.count {
                                ZStack(alignment: .center){
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: geometry.size.height * 0.12 * 1.75, height: geometry.size.height * 0.12)
                                        .cornerRadius(0.013 * geometry.size.height)
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                }
                            }
                            else{
                                ZStack(alignment: .bottom){
                                Image("breakfast")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.height * 0.12 * 1.75, height: geometry.size.height * 0.12)
                                    .cornerRadius(0.013 * geometry.size.height)
                                    Rectangle()
                                        .foregroundColor(.grayColor)
                                        .frame(width: geometry.size.height * 0.12 * 1.75, height: geometry.size.height * 0.02)
                                        .cornerRadius(0.013 * geometry.size.height, [.bottomLeft, .bottomRight])
                                Text("Comer")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .frame(alignment: .bottom)
                                }
                                }
                        }
                        
                    }
                }
                .padding(.leading)
                }
                        Button(action: {}, label: {
                            Text("Save Activity")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(15)
                        })
                        .padding(.top)
                }
                    Spacer(minLength: geometry.size.width * 0.05)
                }
            }
        
        }
    }
}


struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateActivityView()
                .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
                .environment(\.horizontalSizeClass, .compact)
                .environment(\.verticalSizeClass, .compact)
            
        }
    }
}
