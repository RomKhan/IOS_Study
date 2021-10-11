import Foundation

class AlarmModelObsoled {
    var hours: Int
    var minutes: Int
    var isActive: Bool
    var name: String
    
    init(hours: Int, minutes: Int, name: String, isActive: Bool) {
        self.hours = hours
        self.minutes = minutes
        self.isActive = isActive
        self.name = name
    }
}
