import Foundation

protocol AlarmViewControllerProtocol : AnyObject, AlarmInterfaceContains {
    var alarmMenadger: AlarmMenadger! {get set}
    func update()
    func alarmRemove(index: Int)
}
