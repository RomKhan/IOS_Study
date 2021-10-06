import UIKit

class TableViewController: UIViewController {
    
    private var table: UITableView!
    private var alarms: [AlarmModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupTableView()
        
        for _ in 0...200 {
            alarms.append(AlarmModel(
                            hours: Int.random(in: 0...23),
                            minutes: Int.random(in: 0...59),
                            isActive: Bool.random()))
        }
    }
    
    private func setupTableView() {
        let table = UITableView()
        view.addSubview(table)
        
        table.register(AlarmCell.self, forCellReuseIdentifier: "alarmCell")
        table.delegate = self
        table.dataSource = self
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.table = table
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? AlarmCell
        if (cell?.view == nil) {
            cell?.setupAlarm()
        }
        let model = alarms[indexPath.row]
        cell?.view.alarmViewUpdate(hours: model.hours, minutes: model.minutes, isActive: model.isActive)
        return cell ?? UITableViewCell()
    }
}
