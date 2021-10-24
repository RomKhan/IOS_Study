import UIKit

class AlarmView : UIView, UIGestureRecognizerDelegate {
    private let deleteButton = UIButton()
    private let downSeparator = UIView()
    private let content: UIView = UIView()
    private var alarmTime: UILabel = UILabel()
    private var alarmName: UILabel = UILabel()
    private var toggle: UISwitch = UISwitch()
    var id = -1
    var updateFunctionId = -1
    var changeFunction: ((Int) -> ())?
    var editfunction: ((Int) -> ())?
    var deleteFunction: ((Int) -> ())?
    
    convenience init(_ alarmHour: Int = 0, _ alarmMinutes: Int = 0, name: String = "Alarm", _ isActive: Bool = true, _ index: Int = 0) {
        self.init()
        setupAlarmView(Int32(alarmHour), Int32(alarmMinutes), name, isActive, index)
    }
    
    
    /// Функция запускает окно редактирования (срабатвает при клике на графическое отображение будильника на экране).
    @objc func selectActionMenuOpen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            editfunction?(id)
        }
    }
    
    /// Отображение кнопки дуаления на экране.
    /// Если отображено больше 2/3 кнопки удаления, то будильник автоматически удалится.
    private var deleteButtonWidth = CGFloat(0)
    @objc func deleteActionMenu(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            deleteButtonWidth = deleteButton.frame.width
        }
        else if sender.state == .changed {
            let translation = sender.translation(in: self)
            
            var value = deleteButtonWidth + translation.x
            if value < 0 {
                value = 0
            }
            else if (value > frame.width) {
                value = self.frame.width
            }
            if deleteButton.frame.width > frame.width / 3 * 2 {
                sender.state = .ended
            }
            
            deleteButton.frame.size = CGSize(width: value, height: 60)
        }
        else if sender.state == .ended {
            if deleteButton.frame.width < 30 {
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.deleteButton.frame.size = CGSize(width: 0, height: 60)
                })
            }
            else if deleteButton.frame.width < 200 {
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.deleteButton.frame.size = CGSize(width: 60, height: 60)
                })
            }
            else {
                hide()
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.deleteButton.frame.size = CGSize(width: self?.frame.width ?? 0, height: 60)
                })
                deleteFunction?(id)
            }
        }
        
    }
    
    
    func setupAlarmView(_ alarmHour: Int32, _ alarmMinutes: Int32, _ name: String?, _ isActive: Bool, _ index: Int) {
        id = index
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        backgroundColor = UIColor(red: CGFloat(15) / 255, green: CGFloat(15) / 255, blue: CGFloat(15) / 255, alpha: 1)
        
        setupRecognazers()
        setupDeleteButton()
        setupContentView()
        setupDownSeparator()
        setupAlarmTime(Int(alarmHour), Int(alarmMinutes))
        setupAlarmName(name: name ?? "Alarm")
        setupToggle(isActive)
        
    }
    
    private func setupDownSeparator() {
        content.addSubview(downSeparator)
        downSeparator.translatesAutoresizingMaskIntoConstraints = false
        downSeparator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        downSeparator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        downSeparator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        downSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        downSeparator.backgroundColor = .orange
    }
    
    private func setupDeleteButton() {
        addSubview(deleteButton)
        deleteButton.center = CGPoint(x: CGFloat(0), y: CGFloat(0))
        deleteButton.frame.size = CGSize(width: 0, height: 60)
        deleteButton.backgroundColor = .orange
        deleteButton.tintColor = .black
        deleteButton.setTitle("Delete", for: .normal)
    }
    private func setupContentView() {
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor).isActive = true
    }
    
    private func setupRecognazers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectActionMenuOpen))
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(deleteActionMenu))
        panGuesture.delegate = self
        self.addGestureRecognizer(panGuesture)
        self.addGestureRecognizer(tapGesture)
    }
    
    /// Функция позволяет рекогнайзеру не перекрывать рекогнайзер более верхнего уровня.
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    private func setupAlarmName(name: String) {
        updateAlarmName(name: name)
        alarmName.textColor = .white
        alarmTime.font = UIFont.systemFont(ofSize: 24)
        content.addSubview(alarmName)
        alarmName.translatesAutoresizingMaskIntoConstraints = false
        alarmName.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 10).isActive = true
        alarmName.topAnchor.constraint(equalTo: alarmTime.bottomAnchor).isActive = true
    }
    
    func updateAlarmName(name: String) {
        alarmName.text = name
    }
    
    private func setupAlarmTime(_ alarmHour: Int, _ alarmMinutes: Int) {
        updateAlarmTime(alarmHour, alarmMinutes)
        alarmTime.font = UIFont.systemFont(ofSize: 60)
        alarmTime.textColor = .white
        content.addSubview(alarmTime)
        alarmTime.translatesAutoresizingMaskIntoConstraints = false
        alarmTime.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 10).isActive = true
        alarmTime.centerYAnchor.constraint(equalTo: content.centerYAnchor, constant: -12).isActive = true
    }
    
    func updateAlarmTime(_ alarmHour: Int, _ alarmMinutes: Int) {
        alarmTime.text = String(format: "%02d:%02d", alarmHour, alarmMinutes)
    }
    
    private func setupToggle(_ isActive: Bool) {
        alarmToggleUpdate(isActive: isActive)
        toggle.addTarget(_: self, action: #selector(changePush), for: .valueChanged)
        toggle.onTintColor = .orange
        content.addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -10).isActive = true
        toggle.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
    }
    
    func alarmToggleUpdate(isActive: Bool) {
        toggle.isOn = isActive
    }
    
    // Полностью аплейтит view.
    func alarmViewUpdate(_ hours: Int32, _ minutes: Int32, _ name: String?, _ isActive: Bool) {
        updateAlarmName(name: name ?? "Alarm")
        updateAlarmTime(Int(hours), Int(minutes))
        alarmToggleUpdate(isActive: isActive)
    }
    
    /// Активирует функцию изменения будильника.
    @objc func changePush() {
        changeFunction?(id)
    }
    
    /// Скрывает видимость окна.
    func hide() {
        UIView.animate(
                    withDuration: 0.35,
                    delay: 0,
                    usingSpringWithDamping: 0.9,
                    initialSpringVelocity: 1,
                    options: [],
                    animations: { [weak self] in
                        self?.isHidden = true
                    },
                    completion: nil
                )
    }
}
