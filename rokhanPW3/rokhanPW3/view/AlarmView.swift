import UIKit

class AlarmView : UIView {
    private var alarmTime: UILabel!
    private var toggle: UISwitch!
    var id = -1
    var updateFunctionId = -1
    var changeFunction: ((Int) -> ())?
    
    convenience init(_ alarmHour: Int = 0, _ alarmMinutes: Int = 0, _ isActive: Bool = true, _ index: Int = 0) {
        self.init()
        setupAlarmView(alarmHour, alarmMinutes, isActive, index)
    }
    
    func setupAlarmView(_ alarmHour: Int, _ alarmMinutes: Int, _ isActive: Bool, _ index: Int) {
        
        alarmTime = UILabel()
        toggle = UISwitch()
        
        setupAlarmTime(alarmHour, alarmMinutes)
        setupToggle(isActive)
        id = index
        toggle.addTarget(_: self, action: #selector(changePush), for: .valueChanged)
        
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
        setupAlarmTime(hours, minutes)
        toggle.isOn = isActive
    }
    
    func alarmToggleUpdate(isActive: Bool) {
        toggle.isOn = isActive
    }
    
    @objc func changePush() {
        changeFunction?(id)
    }

}
