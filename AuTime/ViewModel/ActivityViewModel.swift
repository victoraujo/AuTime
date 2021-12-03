//
//  ActivityViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 15/07/21.
//

import SwiftUI
import Firebase

class ActivityViewModel: ObservableObject {
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    
    @Published var activities = [Activity]()
    @Published var todayActivities = [Activity]()
    @Published var weekActivities: [[Activity]] = [[], [], [], [], [], [], []]
    
    static var shared = ActivityViewModel()
    
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser
    
    init() {
        self.fetchData()
    }
    
    /// Create an activity in Firestore Database
    /// - Parameters:
    ///   - category: Activity's category
    ///   - complete: The last time this activity was completed
    ///   - star: Indicates if this activity will generate a star
    ///   - name: Activity's name
    ///   - days: Activity repeat days
    ///   - time: The time the activity is scheduled
    ///   - handler: Function to execute after create procedure
    func createActivity(category: String, completions: [Completion], star: Bool, name: String, days: [Int], steps: Int, time: Date, image: UIImage, handler: @escaping () -> Void?) {
                
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(name)") else {
            return
        }
        
        if let docId = userManager.session?.email {
            do {
                try image.pngData()?.write(to: imageURL)
                self.imageManager.uploadImage(urlFile: imageURL, filePath: "users/\(docId)/Activities/\(name.unaccent())", completion: {
                    let activityCompletions: [[String:String]] = completions.map{ ["date": DateHelper.dateToString(from: $0.date), "feedback": $0.feedback]}
                    
                    _ = self.db.collection("users").document(docId).collection("activities").addDocument(data: [
                        "category": category,
                        "completions": activityCompletions,
                        "generateStar": star,
                        "name": name,
                        "repeatDays": days,
                        "steps": steps,
                        "time": DateHelper.getHoursAndMinutes(from: time)
                    ]) { err in
                        if let err = err {
                            print("Error adding document on createActivity: \(err)")
                            
                        }
                        else {
                            handler()
                        }
                    }
                    
                })
                
            } catch let error {
                print("Can't upload the image \(name) to Activities folder. Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fecth activities data from Firestore Database
    func fetchData() {
        if let docId = userManager.session?.email {
            db.collection("users").document(docId).collection("activities").addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No docs returned")
                    return
                }
                self.activities = documents.map({ docSnapshot -> Activity in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let activityCategory = data["category"] as? String ?? ""
                    let activityStar = data["generateStar"] as? Bool ?? false
                    let activityName = data["name"] as? String ?? ""
                    let activityDays = data["repeatDays"] as? [Int] ?? []
                    let activitySteps = data["steps"] as? Int ?? 0
                    
                    let completions = data["completions"] as? [[String:String]] ?? []
                    var activityCompletions: [Completion] = []
                    do {
                        let json = try JSONSerialization.data(withJSONObject: completions)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        activityCompletions = try decoder.decode([Completion].self, from: json)
                    } catch {
                        print(error)
                    }
                    
                    let activityTimeString = data["time"] as? String ?? "00:00"
                    let hourFormatter = DateFormatter()
                    hourFormatter.dateFormat = "HH:mm"
                    let activityTime = hourFormatter.date(from: activityTimeString) ?? Date()
                    
                    return Activity(id: docId, category: activityCategory, completions: activityCompletions, generateStar: activityStar, name: activityName, repeatDays: activityDays, time: activityTime, stepsCount: activitySteps)//, image: activityImage)
                })
                
                self.activities.sort(by: {$0.time < $1.time})
                self.filterActivitiesPerDay()
                self.objectWillChange.send()
                
            })
        }
        
    }
    
    
    func completeActivity(activity: Activity, time: Date, feedback: String) {
        
        if let activityId = activity.id {
            let completedTime = DateHelper.dateToString(from: time)
            var newCompletions: [[String:String]] = activity.completions.map{["date": DateHelper.dateToString(from: $0.date), "feedback": $0.feedback]}
            let newElement = ["date": completedTime, "feedback": feedback]
            newCompletions.append(newElement)
            
            updateActivity(activityId: activityId, fields: ["completions": newCompletions])
            return
        }
        print("Error on get activityId of \(activity.name) on update activity.")
        
        
    }
    
    func updateActivity(activityId: String, fields: [String: Any]) {
        if let docId = self.userManager.session?.email {
            self.db.collection("users").document(docId).collection("activities").document(activityId).updateData(fields, completion: {_ in
                print("Activity \(activityId) was updated!")
            })
            return
        }
        
        print("Error on get docId of user on update activity.")
    }
    
    /// Separate activities on weekdays
    func filterActivitiesPerDay() {
        self.weekActivities = [[], [], [], [], [], [], []]
        
        for activity in self.activities {
            for day in activity.repeatDays {
                self.weekActivities[day - 1].append(activity)
            }
        }
        let todayIndex = getDayOfWeek(Date()) - 1
        self.todayActivities = self.weekActivities[todayIndex]
    }
    
    /// Clear activities from local class
    func clearActivities() {
        self.activities = []
        self.todayActivities = []
    }
    
    /// Indicates the integer number as week day (starts in 1 - Sunday)
    /// - Parameter day: Date which seeks to discover the day of the week
    /// - Returns: The integer number which represents the day of the week
    func getDayOfWeek(_ day: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: day)
        return weekDay
    }
    
    /// Indicates the index of the first incomplete activity in a list
    /// - Parameter offset: Indicates if there is any offset in the list, as  in ChildView
    /// - Returns: List Index (Activity Index + Offset)
    func getCurrentActivityIndex(offset: Int) -> Int {
        let index = self.todayActivities.firstIndex(where: {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let activityDate = dateFormatter.string(from: $0.lastCompletionDate())
            let todayDate  = dateFormatter.string(from: Date())
            
            return activityDate != todayDate
            
        })
        
        return (index ?? 0) + offset
    }
    
    /// Indicates if there are any premium activity today
    /// - Returns: A boolean indicating the presence of this activity
    func hasPremiumActivity() -> Activity? {
        if let firstPremium = self.todayActivities.first(where: { $0.category == "Prêmio" && !DateHelper.datesMatch($0.lastCompletionDate(), Date()) }) {
            return firstPremium
        }
        
        return nil
    }
    
    func getImage(from activityName: String) -> UIImage {
        guard let email = self.userManager.session?.email else {
            print("Email was nil when call download image on ActivityViewModel.")
            return UIImage()
        }
        let filePath = "users/\(String(describing: email))/Activities/\(activityName)"
        self.imageManager.downloadImage(from: filePath){}
        
        var photo: UIImage!
        if let data = self.imageManager.imageView.image?.pngData() {
            photo = UIImage(data: data)
        } else {
            photo = UIImage()
        }
        
        return photo
    }
    
    func getActivitiesByCategory(category: String) -> [Activity] {
        return self.activities.filter({$0.category == category})
    }
    
}
