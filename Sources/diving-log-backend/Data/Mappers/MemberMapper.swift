import Foundation

struct MemberMapper: Mapper {
    typealias Entity = MemberEntity
    typealias Model = Member

    static func toEntity(model: Member) -> MemberEntity? {
        return MemberEntity(
            id: model.id,
            appleOAuthId: model.appleOAuthId,
            nickname: model.nickname,
            isDeleted: model.isDeleted,
            memberLevel: model.memberLevel,
            createdAt: model.createdAt ?? Date(),
            updatedAt: model.updatedAt ?? Date(),
            hasEmailVerified: model.emailVerification != nil,
            email: model.emailVerification?.email
        )
    }
    
    static func toModel(entity: MemberEntity) -> Member? {
        return Member(
            id: entity.id,
            appleOAuthId: entity.appleOAuthId,
            nickname: entity.nickname,
            isDeleted: entity.isDeleted,
            memberLevel: entity.memberLevel,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
