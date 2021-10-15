import Foundation

protocol AlarmViewControllerProtocol : AnyObject, AlarmInterfaceContains {
    var alarmMenadger: AlarmMenadger! {get set}
    func alarmAdd()
    func alarmRemove(index: Int)
}
