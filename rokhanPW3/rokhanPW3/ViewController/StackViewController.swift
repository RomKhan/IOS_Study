import UIKit

class StackViewController: UIViewController, AlarmViewControllerProtocol {
    private var collection: UICollectionView?
    let stackView = UIStackView()
    let scroll = UIScrollView()
    var alarmMenadger: AlarmMenadger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scroll.contentSize = CGSize(
            width: self.view.frame.width,
            height: stackView.frame.height
        )
    }
    
    func update() {
        for subview in stackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        generateAlarms();
        scroll.contentSize = CGSize(
            width: self.view.frame.width,
            height: stackView.frame.height + 60
        )
    }
    
    func alarmRemove(index: Int) {
        (stackView.arrangedSubviews[index] as? AlarmViewWithDelete)?.hide()
        (stackView.arrangedSubviews[index] as? AlarmViewWithDelete)?.isHidden = true
        stackView.removeArrangedSubview(stackView.arrangedSubviews[index])
        viewDidAppear(true)
    }
    
    private func setupScroll() {
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setupStackView() {
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0
        
        scroll.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        generateAlarms()
    }
    
    /// Генерация и добавление AlarmViewWithDelete в стек.
    private func generateAlarms() {
        for i in 0..<(alarmMenadger?.getAlarmsCount() ?? 0) {
            let view = AlarmViewWithDelete()
            alarmMenadger.linkViewWithAlarm(view: view, index: i)
            stackView.addArrangedSubview(view)
        }
    }
}
