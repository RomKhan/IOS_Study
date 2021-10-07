import UIKit

class StackViewController: UIViewController, AlarmViewControllerProtocol {
    let stackView = UIStackView()
    let scroll = UIScrollView()
    var alarmMenadger: AlarmMenadger!
    
    private var collection: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scroll.contentSize = CGSize(
            width: self.view.frame.width,
            height: stackView.frame.height
        )
    }
    
    private func setupScroll() {
        scroll.alwaysBounceVertical = true
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
        stackView.spacing = 5
        
        scroll.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        generateAlarms()
    }
    
    private func generateAlarms() {
        for i in 0..<(alarmMenadger?.getAlarmsCount() ?? 0) {
            let view = AlarmView()
            alarmMenadger.linkViewWithAlarm(view: view, index: i)
            stackView.addArrangedSubview(view)
        }
    }
}
