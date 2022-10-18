//
//  SImpleCollectionViewController.swift
//  SeSACFirebaseExample
//
//  Created by 강민혜 on 10/18/22.
//

import UIKit
import RealmSwift

class SimpleCollectionViewController: UICollectionViewController {
    
    var tasks: Results<Todo>!
    let localRealm = try! Realm()
    
    var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, Todo>! // 한 cell에 대한 내용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = localRealm.objects(Todo.self)
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration) // UICollectionViewCompositionalLayout
        collectionView.collectionViewLayout = layout // collectionViewLayout. 두 타입이 다른데 이게 가능한 이유는 UICollectionViewCompositionalLayout 이 collectionViewLayout 기반으로 만들어졌기 때문
        
        cellRegisteration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.image = itemIdentifier.importance < 2 ? UIImage(systemName: "person.fill") : UIImage(systemName: "person.2.fill")
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.detail.count)개의 세부 항목"
            
            cell.contentConfiguration = content // UIContentConfiguration 타입에다가 UIListContentConfiguration타입을 할당하고 있다. 어떻게?
            // UIListContentConfiguration는 UIContentConfiguration 프로토콜을을 채택한 클래스이므로 가능함.
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // cell 재사용을 하되, 데이터들을 위에서 함수 cellRegisteration에 넣어뒀다가 실행은 여기에서 한다.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tasks[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: item)
        
//        var test: fruit = apple() // 타입 자체를 프로토콜로 선언해버리면 class, struct, enum에 대한 제약에서 벗어날 수 있음
//        test = banana()
//        test = strawberry()
//        test = melon()
        
        return cell
    }
    
    
}

// MARK: - 프로토콜 샘플
//class food {
//
//}
//
//protocol fruit {
//
//}
//
//
//class apple: food, fruit {
//
//}
//
//class banana: food, fruit {
//
//}
//
//class strawberry: food, fruit {
//
//}
//
////만약 melon이 struct라면 상속이 안되기 때문에 food타입을 못 줌. 즉 데이터 전달이 어려움.
//struct melon: fruit {
//
//}



