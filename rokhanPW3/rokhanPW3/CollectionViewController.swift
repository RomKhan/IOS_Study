import UIKit

class CollectionViewController: UIViewController, AlarmViewControllerProtocol {
    var alarmMenadger: AlarmMenadger!
    
    private var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layoutFlow.itemSize = CGSize(width: view.frame.width, height: 40)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layoutFlow)
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collection.backgroundColor = .white
        collection.register(AlarmCellCollection.self, forCellWithReuseIdentifier: "alarmCell")
        collection.showsVerticalScrollIndicator = true
        collection.dataSource = self
        collection.delegate = self
        self.collection = collection
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
