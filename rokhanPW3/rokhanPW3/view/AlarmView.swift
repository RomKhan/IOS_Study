import UIKit

class AlarmView : UIView {
    private let downSeparator = UIView()
    private let content: UIView = UIView()
    private var alarmTime: UILabel!
    private var alarmName: UILabel!
    private var toggle: UISwitch!
    var id = -1
    var updateFunctionId = -1
    var changeFunction: ((Int) -> ())?
    var editfunction: ((Int) -> ())?
    
    convenience init(_ alarmHour: Int = 0, _ alarmMinutes: Int = 0, name: String = "Alarm", _ isActive: Bool = true, _ index: Int = 0) {
        self.init()
        setupAlarmView(alarmHour, alarmMinutes, name, isActive, index)
    }
    
    @objc func selectActionMenuOpen(sender: UITapGestureRecognizer) {
        editfunction?(id)
    }
    
    
    func setupAlarmView(_ alarmHour: Int, _ alarmMinutes: Int, _ name: String, _ isActive: Bool, _ index: Int) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectActionMenuOpen))
        self.addGestureRecognizer(tapGesture)
        
        addSubview(content)
        
        content.addSubview(downSeparator)
        
        downSeparator.translatesAutoresizingMaskIntoConstraints = false
        downSeparator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        downSeparator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        downSeparator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        downSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        downSeparator.backgroundColor = .orange
        
        alarmTime = UILabel()
        alarmTime.font = UIFont.systemFont(ofSize: 60)
        alarmName = UILabel()
        alarmTime.font = UIFont.systemFont(ofSize: 24)
        toggle = UISwitch()
        toggle.onTintColor = .orange
        
        setupAlarmTime(alarmHour, alarmMinutes)
        setupAlarmName(name: name)
        setupToggle(isActive)
        id = index
        toggle.addTarget(_: self, action: #selector(changePush), for: .valueChanged)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        backgroundColor = UIColor(red: CGFloat(15) / 255, green: CGFloat(15) / 255, blue: CGFloat(15) / 255, alpha: 1)
    }
    
    func setupAlarmName(name: String) {
        alarmName.text = name
        alarmName.textColor = .white
        content.addSubview(alarmName)
        alarmName.translatesAutoresizingMaskIntoConstraints = false
        alarmName.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 10).isActive = true
        alarmName.topAnchor.constraint(equalTo: alarmTime.bottomAnchor).isActive = true
    }
    
    func setupAlarmTime(_ alarmHour: Int, _ alarmMinutes: Int) {
        alarmTime.text = String(format: "%02d:%02d", alarmHour, alarmMinutes)
        alarmTime.textColor = .white
        content.addSubview(alarmTime)
        alarmTime.translatesAutoresizingMaskIntoConstraints = false
        alarmTime.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 10).isActive = true
        alarmTime.centerYAnchor.constraint(equalTo: content.centerYAnchor, constant: -12).isActive = true
    }
    
    func setupToggle(_ isActive: Bool) {
        toggle.isOn = isActive
        content.addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -10).isActive = true
        toggle.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
    }
    
    func alarmViewUpdate(_ hours: Int, _ minutes: Int, _ name: String, _ isActive: Bool) {
        setupAlarmName(name: name)
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
