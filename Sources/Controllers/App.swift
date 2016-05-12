import Kitura
import KituraNet

import LoggerAPI
import SwiftyJSON

/**
 Custom middleware that allows Cross Origin HTTP requests
 This will allow wwww.todobackend.com to communicate with your server
*/
class AllRemoteOriginMiddleware: RouterMiddleware {
	func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

		response.setHeader("Access-Control-Allow-Origin", value: "*")

		next()
	}
}

/**
 Sets up all the routes for the Todo List application
*/
func setupRoutes(router: Router, todos: TodoCollection) {
	
	router.all("/*", middleware: BodyParser())

	router.all("/*", middleware: AllRemoteOriginMiddleware())
}