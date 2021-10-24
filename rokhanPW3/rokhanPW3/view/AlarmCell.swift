import UIKit

class AlarmCell : UITableViewCell {

    var view: AlarmViewWithDelete!
    
    override func prepareForReuse() {
        if view.isHidden == true {
            view = nil
        }
    }
    
    func setupAlarm() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        translatesAutoresizingMaskIntoConstraints = true
        setupView()
    }
    
    private func setupView() {
        view = AlarmViewWithDelete()
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
