protocol Mapper {
    associatedtype Entity
    associatedtype Model

    static func toEntity(model: Model) -> Entity?
    static func toModel(entity: Entity) -> Model?
}
