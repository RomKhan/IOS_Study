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
        
        table.backgroundColor = UIColor(white: 1, alpha: 0)
        table.register(AlarmCell.self, forCellReuseIdentifier: "alarmCell")
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.table = table
    }
    
    func alarmAdd() {
        table.beginUpdates()
        table.insertRows(at: [IndexPath.init(row: alarmMenadger.getAlarmsCount()-1, section: 0)], with: .automatic)
        table.endUpdates()
    }
    
    func alarmRemove(index: Int) {
        self.table.beginUpdates()
        let cellOptional = table.cellForRow(at: IndexPath(row: index, section: 0)) as? AlarmCell
        if let cell = cellOptional {
            cell.view.hide()
            table.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
        }
        self.table.endUpdates()
    }
}

extension TableViewController: UITableViewDelegate {
    
    /// Количество ячеек в секции.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmMenadger.getAlarmsCount()
    }
    
    /// Количетсво секций.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension TableViewController: UITableViewDataSource {
    
    /// Выдача ячейки по запросу.
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
    
    /// Высота ячеек.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
