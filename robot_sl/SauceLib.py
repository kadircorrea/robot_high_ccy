import socket
import time
import random
from appium import webdriver
from appium.options.common import AppiumOptions
from appium.webdriver.client_config import AppiumClientConfig
from urllib3.util import Retry
from robot.libraries.BuiltIn import BuiltIn

class SauceLib:
    def open_session_with_custom_config(self, sauce_url, caps):
        time.sleep(random.uniform(0, 12))

        custom_retries = Retry(
            total=20,
            connect=10,
            read=10,
            redirect=0,
            status=10,
            backoff_factor=3,
            status_forcelist=[429, 500, 502, 503, 504],
            raise_on_redirect=False
        )

        sauce_config = AppiumClientConfig(
            remote_server_addr=sauce_url,
            timeout=900,
            init_args_for_pool_manager={
                "retries": custom_retries,
                "num_pools": 2,
                "maxsize": 5,
                "block": False,
                "socket_options": [
                    (socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1),
                    (socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                ]
            }
        )

        options = AppiumOptions()
        options.load_capabilities(caps)

        driver = webdriver.Remote(
            command_executor=sauce_url,
            options=options,
            client_config=sauce_config
        )

        appium_lib = BuiltIn().get_library_instance('AppiumLibrary')
        appium_lib._cache.register(driver, alias=None)

        return driver.session_id