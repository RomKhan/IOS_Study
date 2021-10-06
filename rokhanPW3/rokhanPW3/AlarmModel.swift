import Foundation

class AlarmModel {
    var hours: Int
    var minutes: Int
    var isActive: Bool
    
    init(hours: Int, minutes: Int, isActive: Bool) {
        self.hours = hours
        self.minutes = minutes
        self.isActive = isActive
    }
}
