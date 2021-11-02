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
    @State private var selectedColor = "select"
    @State var activity = Activity(id: "", category: "", complete: Date(), generateStar: false, name: "", repeatDays: [], time: Date(), stepsCount: 0)
    @State var isShowingPhotoPicker = false
    @State var activityImage = UIImage(named: "Breakfast") ?? UIImage()
    
    var colorTheme: Color = .blue
    var weekDays = ["S","M","T","W","T","F","S"]
    var subActivities: [String] = ["oi"]
    
    var categories = ["Domestic", "Education", "Family", "Friends" , "Fun", "Health", "Hygiene", "Premium", "Therapy"]
    
    func getIconImage() -> Image{
        return Image(systemName: "heart.fill")
    }
    
    var body: some View {
        GeometryReader{ geometry in
            
            VStack(alignment: .leading){
                
                Spacer()
                
                Text("Create Activity")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black100Color)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .padding(.top)
                
                HStack{
                    Spacer(minLength: geometry.size.width * 0.05)
                    VStack{
                        HStack(alignment: .top){
                            VStack(alignment: .leading){
                                Text("Image:")
                                    .fontWeight(.bold)
                                    .padding([.leading, .top, .trailing])
                                Image(uiImage: activityImage)
                                    .resizable()
                                    .frame(width: geometry.size.height * 0.16 * 1.75, height: geometry.size.height * 0.16)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(21)
                                    .padding([.leading, .bottom, .trailing])
                                    .onTapGesture {
                                        isShowingPhotoPicker = true
                                    }
                                Text("Activity's name:")
                                    .fontWeight(.bold)
                                    .padding()
                                TextField("Activity's name", text: $activityName).textFieldStyle(RoundedBorderTextFieldStyle())
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
                                        .padding(.leading)
                                        .pickerStyle(MenuPickerStyle())
                                        .frame(width: geometry.size.width * 0.38, height: 30, alignment: .leading)
                                        .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 2, x: 0, y: 2))
                                        .padding(.leading)
                                        .foregroundColor(colorTheme)
                                        
                                    }
                                    .padding(.bottom)
                                    
                                    HStack{
                                        Text("Generate star")
                                            .fontWeight(.bold)
                                            .padding()
                                        Spacer()
                                        Toggle("", isOn: $generateStar)
                                            .frame(width: 50)
                                    }
                                    .frame(width: geometry.size.width * 0.4)
                                    .padding(.vertical)
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
                                Text("3. Use the option to generate star for activities that João has less motivation to perform.")
                                    .padding(.leading)
                                    .padding([.leading, .bottom])
                                    .padding(.bottom)
                                
                                Text("Activity's time")
                                    .fontWeight(.bold)
                                    .padding()
                                //.padding(.top)
                                
                                Text(DateHelper.getHoursAndMinutes(from: Date()))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(height: 20)
                                    .background(Color.blue)
                                    .cornerRadius(14)
                                    .padding(.leading)
                                    .padding(.bottom)
                                
                                Text("Days of week")
                                    .fontWeight(.bold)
                                    .padding()
                                HStack{
                                    ForEach(0..<7){ day in
                                        ZStack{
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor( activity.repeatDays.contains(day + 1) ? colorTheme : .black100Color)
                                            Text(weekDays[day])
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                        .onTapGesture {
                                            if activity.repeatDays.contains(day + 1) {
                                                let index = activity.repeatDays.firstIndex(of: day + 1)
                                                activity.repeatDays.remove(at: index!)
                                            } else {
                                                activity.repeatDays.append(day + 1)
                                                activity.repeatDays.sort()
                                            }
                                            
                                        }
                                    }
                                }
                                .padding(.leading)
                                //.padding(.bottom)
                                
                                HStack{
                                    Text("Repeat weekly")
                                        .fontWeight(.bold)
                                        .padding()
                                    Spacer()
                                    Toggle("", isOn: $weeklyRepeat)
                                        .frame(width: 50)
                                        .padding(.trailing)
                                    
                                }
                                .frame(width: geometry.size.width * 0.4)
                                .padding(.vertical)
                                
                            }
                            .frame(width: geometry.size.width * 0.4, alignment: .trailing)
                                                       
                        }
                        
                        HStack(alignment: .center){
                            VStack(alignment: .leading){
                                Text("Steps:")
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                ScrollView(.horizontal){
                                    HStack(alignment: .center){
                                        ForEach(0..<subActivities.count + 1){ index in
                                            if index == subActivities.count {
                                                ZStack(alignment: .center){
                                                    Rectangle()
                                                        .fill(Color.gray)
                                                        .frame(width: geometry.size.height * 0.12 * 1.75, height: geometry.size.height * 0.15)
                                                        .cornerRadius(0.013 * geometry.size.height)
                                                    Image(systemName: "plus.circle")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .foregroundColor(.white)
                                                }
                                                .padding()
                                            }
                                            else{
                                                
                                                VStack {
                                                    Image("Wash hands")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: geometry.size.height * 0.12 * 1.75, height: geometry.size.height * 0.115)
                                                        .cornerRadius(0.013 * geometry.size.height, [.topLeft, .topRight])
                                                    
                                                    Text("Wash hands")
                                                        .foregroundColor(colorTheme)
                                                        .fontWeight(.bold)
                                                        .frame(alignment: .bottom)
                                                        .padding(.all, 0.04 * geometry.size.height * 0.05)
                                                        .padding(.bottom, 0.04 * geometry.size.height * 0.05)
                                                }
                                                .frame(width: geometry.size.height * 0.12 * 1.75, height: geometry.size.height * 0.15)
                                                .background(Color.white.cornerRadius(0.013 * geometry.size.height).shadow(color: .black100Color, radius: 5, x: 0, y: 6))
                                                .padding()
                                            }
                                        }
                                        
                                    }
                                }
                                .padding(.leading)
                                .padding(.vertical)
                            }
                            Button(action: {}, label: {
                                Text("Save Activity")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(colorTheme)
                                    .cornerRadius(15)
                            })
                        }
                        
                        Spacer()
                    }
                    
                    
                    Spacer(minLength: geometry.size.width * 0.05)
                }
            }
            .sheet(isPresented: $isShowingPhotoPicker, content: {
                PhotoPicker(activityImage: $activityImage)
            })
            
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
