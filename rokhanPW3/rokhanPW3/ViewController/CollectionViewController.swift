import UIKit

class CollectionViewController: UIViewController, AlarmViewControllerProtocol {
    var alarmMenadger: AlarmMenadger!
    var layoutFlow: UICollectionViewFlowLayout!
    private var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    override func viewDidAppear(_ animated: Bool) {
        collection.reloadData()
    }
    
    private func setupCollectionView() {
        layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutFlow.itemSize = CGSize(width: view.frame.width, height: 60)
        layoutFlow.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layoutFlow)
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collection.register(AlarmCellCollection.self, forCellWithReuseIdentifier: "alarmCell")
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor(white: 1, alpha: 0)
        self.collection = collection
    }
    
    func alarmAdd() {
        self.collection.reloadData()
    }
    
    func alarmRemove(index: Int) {
        let cellOptional = self.collection.cellForItem(at: IndexPath(row: index, section: 0)) as? AlarmCellCollection
        if let cell = cellOptional {
            cell.view.hide()
            collection.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
}

extension CollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "alarmCell", for: indexPath) as? AlarmCellCollection
        if (cell?.view == nil) {
            cell?.setupAlarm()
            alarmMenadger.linkViewWithAlarm(view: cell!.view, index: indexPath.row)
        }
        if let alarmCell = cell {
            alarmMenadger.viewRetarget(view: alarmCell.view, index: indexPath.row)
        }
        return cell ?? UICollectionViewCell()
    }
}

extension CollectionViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alarmMenadger.getAlarmsCount()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
