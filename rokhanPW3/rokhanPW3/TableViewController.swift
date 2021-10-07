import UIKit

class TableViewController: UIViewController, AlarmViewControllerProtocol {
    var alarmMenadger: AlarmMenadger!
    private var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupTableView()
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
        return alarmMenadger.getAlarmsCount()
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
            alarmMenadger.linkViewWithAlarm(view: cell!.view, index: indexPath.row)
        }
        if let alarmCell = cell {
            alarmMenadger.viewRetarget(view: alarmCell.view, index: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
}
