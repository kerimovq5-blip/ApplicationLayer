//
//  AppDiContainer.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 13.08.26.
//
import SilentMoonNetwork
import SilentMoonDomain
import SilentMoonData

final public class AppDiContainer {
    public let networkManager: NetworkManager<ApiErrorEnvelope>
    public let tokenStore: TokenStore
    public let repository: SilentMoonRepository

    public init(
        networkManager: NetworkManager<ApiErrorEnvelope>,
        tokenStore: TokenStore
    ) {
        self.networkManager = networkManager
        self.tokenStore = tokenStore

        self.repository = SilentMoonRepositoryImpl(
            networkManager: networkManager,
            tokenStore: tokenStore
        )
    }

    public static func make() -> AppDiContainer {
        let dependencies = NetworkFactory.make()
        return AppDiContainer(
            networkManager: dependencies.networkManager,
            tokenStore: dependencies.tokenStore
        )
    }
}
