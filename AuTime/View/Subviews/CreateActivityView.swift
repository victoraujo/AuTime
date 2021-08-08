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
                ZStack{
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                        .cornerRadius(60, .bottomRight)
                        
                    Text("Criar Atividade")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                }
                HStack(alignment: .center){
                    
                    VStack(alignment: .leading){
                        Text("Imagem:")
                            .fontWeight(.bold)
                            .padding()
                    Image("breakfast")
                        .cornerRadius(21)
                        .padding([.leading, .bottom, .trailing])
                        Text("Nome da Atividade:")
                            .fontWeight(.bold)
                            .padding()
                        TextField("nome da atividade", text: $activityName)
                            .padding()
                            .frame(width: geometry.size.width * 0.4, height: 30, alignment: .center)
                        Text("Categoria da Atividade:")
                            .fontWeight(.bold)
                            .padding()
                        Section{
                            HStack{
                                Picker(selectedColor, selection: $selectedColor) {
                                    ForEach(categories, id: \.self) {
                                        Text($0)
                                    }
                                    .padding()
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: geometry.size.width * 0.38, height: 30, alignment: .leading)
                                .padding(.leading)
                                .cornerRadius(20)
                                .border(Color.gray, width: 1)
                                
                            }
                            HStack{
                                Text("Gerar estrela")
                                    .fontWeight(.bold)
                                    .padding()
                                Toggle("", isOn: $generateStar)
                            }.frame(width: geometry.size.width * 0.4)
                            
                        }
                        
                        
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Dicas:")
                            .fontWeight(.bold)
                            .padding()
                        Text("Horário da atividade")
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
                        Text("Horário da atividade")
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
                            Text("Repetir Semanalmente")
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
                    Text("Etapas:")
                        .fontWeight(.bold)
                ScrollView(.horizontal){
                    HStack{
                        ForEach(0..<subActivities.count + 1){ index in
                            if index == subActivities.count {
                                ZStack(alignment: .center){
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.17)
                                        .cornerRadius(20)
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                }
                            }
                            else{
                                Image("breakfast")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.17)
                                    .cornerRadius(20)
                            }
                        }
                        
                    }
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
