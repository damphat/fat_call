class Router extends StatefullWidget {
    routeInformationProvider
    routeInformationParser
    routerDelegate
    backButtonDispatcher
}

RouterInfomationParser {
    Future<string> paerseRouteInfomation(RouteInfomation)
    RouteInfomation restoreRouteInfomation(String configuration)
}

RouterInfomationProvider {
    reouteReportsnewRouteInfomation
}

RouterDelegate {
    setInitialRoutePath
    setNewRoutePath
    popRoute
    build(context)
}

class BackButtonDispatcher {
    takePriority()
    createChildBackButtonDispatcher()
}

PlatformRouteInfomationProvider {
    reouterReporsNewRouteInfomation
    didPushRoute
    didPushRouteInfomation
}