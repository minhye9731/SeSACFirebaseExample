//
//  Todo.swift
//  SeSACFirebaseExample
//
//  Created by 강민혜 on 10/13/22.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted var title : String
    @Persisted var importance : Int
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    @Persisted var detail : List<DetailTodo>
    
    @Persisted var memo : Memo? // EmbeddedObject 는 항상 Optional
    
    convenience init(title: String, importance: Int) {
        self.init()
        self.title = title
        self.importance = importance
    }
}

// realm list 테스트용
class DetailTodo: Object {
    @Persisted var detailTitle : String
    @Persisted var favorite : Bool
    @Persisted var deadline : Date // 옵셔널이 아니라서 빌드하고보면 어떻게든 뭔가 값이 들어가는데, 그 이유는 아래 self.init() 때문임.
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(detailTitle: String, favorite: Bool) {
        self.init()
        self.detailTitle = detailTitle
        self.favorite = favorite
    }
}

// embeddedObject 테스트용
class Memo: EmbeddedObject {
    @Persisted var content: String
    @Persisted var date: Date
    
    // objectId 없어도 됨. 왜냐. table 형태가 아니라서
//    @Persisted(primaryKey: true) var objectId: ObjectId
    
    // 사실 이거는 있어도 없어도 상관없음
//    init(content: String, date: Date) {
//        self.content = content
//        self.date = date
//    }
}














