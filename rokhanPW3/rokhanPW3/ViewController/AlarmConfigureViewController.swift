import UIKit

/// Окно настройки будильника (всплывает поверху таб бара).
class AlarmConfigureViewController : UIViewController, AlarmInterfaceContains {
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    private var timePicker: UIDatePicker!
    private var textField: UITextField!
    private var stackView: UIStackView!
    var alarmMenadger: AlarmMenadger!
    var flagMode = false
    var alarmIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        setupNotificationObservers()
        setupBackgroundView()
        setupStackView()
        setupLabelOfView()
        setupDatePicker()
        setupTextFieldForm()
        setupSuccesButton()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    deinit {
        // Отписка от рекогнайзера, когда окно закрыто.
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupNotificationObservers() {
        // Подключение рекогнайзера, который позволяет двигать окно.
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardIsAppeared),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardIsAppeared),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func setupBackgroundView() {
        let container = UIView()
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        container.layer.cornerRadius = 15
        container.backgroundColor = .black
    }
    
    func setupStackView() {
        stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 4
        stackView.backgroundColor = .black
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.layer.cornerRadius = 10
    }
    
    func setupLabelOfView() {
        let lable = UILabel()
        lable.text = "ALARM MENU"
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 26)
        lable.textAlignment = .center
        stackView.addArrangedSubview(lable)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        lable.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        lable.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        lable.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 20).isActive = true
    }
    
    func setupDatePicker() {
        timePicker = UIDatePicker()
        timePicker.timeZone = NSTimeZone.local
        timePicker.backgroundColor = .orange
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        timePicker.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        timePicker.locale = Locale(identifier: "en_GB")
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        timePicker.setValue(false, forKeyPath: "highlightsToday")
        stackView.addArrangedSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
    
    func setupTextFieldForm() {
        textField = UITextField()
        textField.placeholder = "Название"
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textAlignment = .left
        stackView.addArrangedSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        textField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
    }
    
    func setupSuccesButton() {
        let succsessButton = UIButton()
        succsessButton.setTitle("Готово", for: .normal)
        succsessButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        succsessButton.backgroundColor = .orange
        succsessButton.layer.cornerRadius = 15
        succsessButton.addTarget(self, action: #selector(successButtonPressed), for: .touchDown)
        view.addSubview(succsessButton)
        succsessButton.translatesAutoresizingMaskIntoConstraints = false
        succsessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        succsessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        succsessButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        succsessButton.topAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -80).isActive = true
    }
    
    /// Событие появления клавиатуры.
    /// В этот момент весь интерфейс сдвигается вверх на размер клавиатуры.
    @objc func keyBoardIsAppeared(_ notification: Notification) {
        let keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y - (keyBoardHeight ?? 0))
        }
    }
    
    /// Событие нажатия на кнопку "готово".
    /// Здесь в зависимости от режима вызываются методы менаджера.
    @objc func successButtonPressed(_ sende: Any?) {
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: timePicker.date)
        if !flagMode {
            let hour = components.hour!
            let minute = components.minute!
            alarmMenadger.alarmAddAndReloadContollers(hour, minute, textField.text! == "" ? "Alarm" : textField.text!, true)
        }
        else {
            alarmMenadger.alarmChange(index: alarmIndex, data: components, name: textField.text!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Обработчик рекогнайзера,
    /// Меняет положение окна на экране.
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if self.pointOrigin!.y + translation.y <= UIScreen.main.bounds.height - 500 {
            view.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height - 500)
        }
        else {
            view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        }
     
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }

}
