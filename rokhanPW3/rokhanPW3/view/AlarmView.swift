import UIKit

class AlarmView : UIView, UIGestureRecognizerDelegate {
    private let deleteButton = UIButton()
    private let downSeparator = UIView()
    private let content: UIView = UIView()
    private var alarmTime: UILabel!
    private var alarmName: UILabel!
    private var toggle: UISwitch!
    var isHided = false
    var id = -1
    var updateFunctionId = -1
    var changeFunction: ((Int) -> ())?
    var editfunction: ((Int) -> ())?
    var deleteFunction: ((Int) -> ())?
    
    convenience init(_ alarmHour: Int = 0, _ alarmMinutes: Int = 0, name: String = "Alarm", _ isActive: Bool = true, _ index: Int = 0) {
        self.init()
        setupAlarmView(Int32(alarmHour), Int32(alarmMinutes), name, isActive, index)
    }
    
    @objc func selectActionMenuOpen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            editfunction?(id)
        }
    }
    
    @objc func miniDeleteButtoShow(sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            UIView.animate(withDuration: 0.2, animations: {
                self.deleteButton.frame.size = CGSize(width: 60, height: 60)
            })
        }
        else if (sender.direction == .left) {
            UIView.animate(withDuration: 0.2, animations: {
                self.deleteButton.frame.size = CGSize(width: 0, height: 60)
            })
        }
    }
    
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
            if deleteButton.frame.width > frame.width / 2 {
                sender.state = .ended
            }
            
            deleteButton.frame.size = CGSize(width: value, height: 60)
        }
        else if sender.state == .ended {
            if deleteButton.frame.width < 30 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.deleteButton.frame.size = CGSize(width: 0, height: 60)
                })
            }
            else if deleteButton.frame.width < 100 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.deleteButton.frame.size = CGSize(width: 60, height: 60)
                })
            }
            else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.deleteButton.frame.size = CGSize(width: self.frame.width, height: 60)
                })
                deleteFunction?(id)
            }
        }
        
    }
    
    
    func setupAlarmView(_ alarmHour: Int32, _ alarmMinutes: Int32, _ name: String?, _ isActive: Bool, _ index: Int) {
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectActionMenuOpen))
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(deleteActionMenu))
        panGuesture.delegate = self
        self.addGestureRecognizer(panGuesture)
        self.addGestureRecognizer(tapGesture)
        
        
        addSubview(content)
        addSubview(deleteButton)
        
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
        
        setupAlarmTime(Int(alarmHour), Int(alarmMinutes))
        setupAlarmName(name: name ?? "Alarm")
        setupToggle(isActive)
        id = index
        toggle.addTarget(_: self, action: #selector(changePush), for: .valueChanged)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        backgroundColor = UIColor(red: CGFloat(15) / 255, green: CGFloat(15) / 255, blue: CGFloat(15) / 255, alpha: 1)
        
        deleteButton.center = CGPoint(x: CGFloat(0), y: CGFloat(0))
        deleteButton.frame.size = CGSize(width: 0, height: 60)
        deleteButton.backgroundColor = .orange
        deleteButton.tintColor = .black
        deleteButton.setTitle("Delete", for: .normal)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
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
    
    func alarmViewUpdate(_ hours: Int32, _ minutes: Int32, _ name: String?, _ isActive: Bool) {
        setupAlarmName(name: name ?? "Alarm")
        setupAlarmTime(Int(hours), Int(minutes))
        toggle.isOn = isActive
    }
    
    func alarmToggleUpdate(isActive: Bool) {
        toggle.isOn = isActive
    }
    
    @objc func changePush() {
        changeFunction?(id)
    }
    func hide() {
        UIView.animate(
                    withDuration: 0.35,
                    delay: 0,
                    usingSpringWithDamping: 0.9,
                    initialSpringVelocity: 1,
                    options: [],
                    animations: {
                        self.isHidden = true
                    },
                    completion: nil
                )
        isHidden = true
    }
}
