from tornado.web import RequestHandler


class HelloWorldController(RequestHandler):
    def get(self):
        self.write("\n\nHello world!\n\n")
