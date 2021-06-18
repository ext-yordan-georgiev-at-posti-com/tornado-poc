import os
from tornado.web import Application
from tornado.ioloop import IOLoop
from tornado.options import parse_command_line
from .controllers.hello_world_controller import HelloWorldController


TORNADO_PORT = os.getenv("TORNADO_PORT", default = 8888)

ROUTES = [
    (r"/", HelloWorldController),
]


def make_app():
    return Application(ROUTES)


def start_server():
    app = make_app()
    app.listen(TORNADO_PORT)
    parse_command_line()
    print(f"Server started at port {TORNADO_PORT}...")
    IOLoop.current().start()
