//
//  ScheduleView.swift
//  AuTime
//
//  Created by Matheus Andrade on 02/08/21.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var activitiesManager = ActivityViewModel()
    @ObservedObject var profileManager = ProfileViewModel.shared
    @ObservedObject var env: AppEnvironment
    
    @State var currentActivity: Int = 0
    @State var visualization: ScheduleViewMode = .today
    
    @State var isShowingAddActivity: Bool = false
    @State var activities: [Activity] = []
    @State var selectedCategory: String = ""
    @State var selectedActivityName: String = ""
    @State var selectedActivity: Activity = Activity()
    @State var activityTime: Date = Date()
    @State var activityRepeatDays: [Int] = []
    
    @State var showAlert: Bool = false
    @State var alertType: AlertType = .none
    
    let weekDays = ["Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"]
    
    public enum ScheduleViewMode: Int {
        case today, week
    }
    
    init(_env: ObservedObject<AppEnvironment>) {
        self._env = _env
        currentActivity = self.activitiesManager.getCurrentActivityIndex(offset: 0)
    }
    
    func checkFields() -> Bool {
        if selectedCategory == "" {
            return false
        }
        if selectedActivity == Activity() {
            return false
        }
        if activityRepeatDays == [] {
            return false
        }
        
        return true
    }
    
    func shortWeekDaysName() -> String {
        var ret = ""
        
        activityRepeatDays.sort()
        
        if activityRepeatDays == [1, 7] {
            return "Fim de Semana"
        }
        
        if activityRepeatDays == [2,3,4,5,6] {
            return "Dias Úteis"
        }
        
        if activityRepeatDays == [1,2,3,4,5,6,7] {
            return "Todos os Dias"
        }
        
        for i in 0...6 {
            if activityRepeatDays.contains(i+1) {
                let day = weekDays[i].prefix(3)
                ret += day + " "
            }
        }
        
        return ret
    }
    
    var body: some View {
        GeometryReader { geometry in
            // Today Schedule
            if visualization == .today {
                DailyScheduleView(env: env)
            }
            // Week Schedule
            else {
                WeekScheduleView(env: env)
            }
            
        }
        .navigationTitle("Cronograma de \(profileManager.getChildName())")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Adicionar Atividade") {
                    isShowingAddActivity = true
                }
            }
            
            ToolbarItem(placement: ToolbarItemPlacement.principal) {
                VStack {
                    Picker("Visualization", selection: $visualization) {
                        Text("Hoje").tag(ScheduleViewMode.today)
                        Text("Semana").tag(ScheduleViewMode.week)
                    }
                    .pickerStyle(.segmented)
                }
                .frame(width: 0.3*UIScreen.main.bounds.width, alignment: .center)
            }
            
        }
        .sheet(isPresented: $isShowingAddActivity, content: {
            GeometryReader { geometry in
                NavigationView {
                    Form {
                        
                        Section(header: Text("Categoria")) {
                            NavigationLink(destination: {
                                Form {
                                    Picker("Selecionar Categoria", selection: $selectedCategory) {
                                        ForEach(env.categories, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(InlinePickerStyle())
                                }
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("Selecionar Categoria")
                                            .font(.title2)
                                            .bold()
                                    }
                                }
                            }, label: {
                                HStack {
                                    Text("Categoria")
                                    Spacer()
                                    Text(selectedCategory)
                                        .foregroundColor(.gray)
                                }
                            })
                        }
                        
                        Section(header: Text("Atividade")) {
                            NavigationLink(destination: {
                                let filtered = activities.filter({$0.category == selectedCategory}).sorted(by: { $0.name.uppercased() < $1.name.uppercased() })
                                
                                if filtered.count == 0 {
                                    Spacer()
                                    
                                    HStack {
                                        Spacer()
                                        VStack (alignment: .center){
                                            Text("Nenhuma Atividade")
                                                .font(.largeTitle)
                                                .bold()
                                                .padding()
                                            
                                            Text("Você ainda não adicionou nenhuma atividade a esta categoria.")
                                                .font(.headline)
                                                .foregroundColor(.black90Color)
                                            
                                        }
                                        .frame(alignment: .center)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                } else {
                                    Form {
                                        Picker("Atividades de \(selectedCategory)", selection: $selectedActivity) {
                                            ForEach(filtered) { activity in
                                                HStack {
                                                    ListActivityView(activity: activity)
                                                        .frame(height: geometry.size.height*0.15, alignment: .center)
                                                        .padding(.top, 10)
                                                }
                                                .padding(.top, 10)
                                                .tag(activity)
                                            }
                                            .frame(alignment: .center)
                                        }
                                        .pickerStyle(InlinePickerStyle())
                                    }
                                    .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                                    .toolbar {
                                        ToolbarItem(placement: .principal) {
                                            Text("Selecionar Atividade")
                                                .font(.title2)
                                                .bold()
                                        }
                                    }
                                }
                            }, label: {
                                Text("Selecionar Atividade")
                                Spacer()
                                Text(selectedActivity.name)
                                    .foregroundColor(.gray)
                            })
                                .disabled(selectedCategory == "")
                            
                        }
                        
                        Section(header: Text("Data e Hora")) {
                            HStack {
                                Text("Selecionar Horário")
                                Spacer()
                                DatePicker("", selection: $activityTime, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                    .environment(\.locale, Locale.init(identifier: "pt-BR"))
                            }
                            
                            NavigationLink(destination: {
                                List {
                                    let _ = print("repeat: \(activityRepeatDays)")
                                    
                                    ForEach(Array(weekDays.enumerated()), id: \.offset) { index, day in
                                        HStack {
                                            Text(day)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                                .opacity(activityRepeatDays.contains(index + 1) ? 1 : 0)
                                                .foregroundColor(env.parentColorTheme)
                                        }
                                        .background(Color.white)
                                        .onTapGesture(perform: {
                                            if activityRepeatDays.contains(index + 1) {
                                                activityRepeatDays.removeAll(where: {$0 == index + 1})
                                            } else {
                                                activityRepeatDays.append(index + 1)
                                            }
                                        })
                                    }
                                }
                                .listStyle(.insetGrouped)
                                
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("Repetição da Atividade")
                                            .font(.title2)
                                            .bold()
                                    }
                                }
                            }, label: {
                                HStack {
                                    Text("Repetição")
                                    Spacer()
                                    Text(shortWeekDaysName())
                                        .foregroundColor(.gray)
                                }
                            })
                            
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Agendar Atividade")
                                .font(.title2)
                                .bold()
                        }
                        
                        ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                            Button(action: {
                                if checkFields() {
                                    var fields: [String: Any] = [:]
                                    if let id = selectedActivity.id {
                                        fields["time"] = DateHelper.getHoursAndMinutes(from: activityTime)
                                        fields["repeatDays"] = activityRepeatDays
                                        activitiesManager.updateActivity(activityId: id, fields: fields) {
                                            isShowingAddActivity = false
                                        }
                                    } else {
                                        showAlert = true
                                        alertType = .activityNotFound
                                    }
                                } else {
                                    showAlert = true
                                    alertType = .emptyField
                                }
                            }, label: {
                                Text("Adicionar")
                                    .bold()
                            })
                        }
                    }
                }
                .onChange(of: selectedCategory, perform: { _ in
                    selectedActivity = Activity()
                })
                .onAppear(perform: {
                    self.activities = activitiesManager.activities
                })
                .onChange(of: activitiesManager.activities, perform: { lista in
                    self.activities = activities
                })
                .onDisappear(perform: {
                    selectedCategory = ""
                    selectedActivity = Activity()
                })
                .alert(isPresented: $showAlert) {
                    if alertType == .emptyField {
                        return Alert(title: Text("Campos Vazios"), message: Text("Você deve preencher todos os campos e adicionar uma foto para criar uma nova atividade ou subatividade."), dismissButton: .default(Text("OK")))
                    } else if alertType == .activityNotFound {
                        return Alert(title: Text("Erro com Atividade"), message: Text("Não foi possível agendar a atividade pois ela apresenta um erro. Tente novamente mais tarde."), dismissButton: .default(Text("OK")))
                    }
                    
                    return Alert(title: Text("Erro"), message: Text("Erro."), dismissButton: .default(Text("OK")))
                    
                }
            }
            
        })
    }
}

struct ListActivityView: View {
    @ObservedObject var imageManager = ImageViewModel()
    @State var activityImage = UIImage(named: "PlaceholderImage.png") ?? UIImage()
    var activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
        
        if let email = UserViewModel.shared.session?.email {
            let filePath = "users/\(email)/Activities/\(activity.name)"
            imageManager.downloadImage(from: filePath) {}
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Image(uiImage: activityImage)
                    .resizable()
                    .frame(width: geometry.size.height*0.6, height: geometry.size.height*0.6)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(5)
                
                Text(activity.name)
                    .font(.subheadline)
            }
        }
        .onAppear(perform: {
            if let email = UserViewModel.shared.session?.email {
                let filePath = "users/\(email)/Activities/\(activity.name)"
                imageManager.downloadImage(from: filePath) {
                    self.activityImage = self.imageManager.imageView.image ?? UIImage(named: "PlaceholderImage.png") ?? UIImage()
                }
            }
        })
        .onChange(of: self.imageManager.imageView.image, perform: { image in
            if let image = image {
                self.activityImage = image
            }
        })
    }
}

//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            ScheduleView()
//                .previewInterfaceOrientation(.landscapeLeft)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
