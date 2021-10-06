import UIKit

class AlarmView : UIView {
    private var alarmTime: UILabel!
    private var toggle: UISwitch!
//    private var menadger: AlarmMenadgerProtocol!
    
    convenience init(_ alarmHour: Int = 19, _ alarmMinutes: Int = 20, _ isActive: Bool = true) {
        self.init()
        alarmTime = UILabel()
        toggle = UISwitch()
        
        setupAlarmTime(alarmHour, alarmMinutes)
        setupToggle(isActive)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        backgroundColor = .white.withAlphaComponent(0.8)
    }
    
    func setupAlarmTime(_ alarmHour: Int, _ alarmMinutes: Int) {
        alarmTime.text = "\(alarmHour):\(alarmMinutes)"
        addSubview(alarmTime)
        alarmTime.translatesAutoresizingMaskIntoConstraints = false
        alarmTime.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        alarmTime.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupToggle(_ isActive: Bool) {
        toggle.isOn = isActive
        addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        toggle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func alarmViewUpdate(hours: Int, minutes: Int, isActive: Bool) {
        alarmTime.text = "\(hours):\(minutes)"
        toggle.isOn = isActive
    }
}
