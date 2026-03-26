from PySide6.QtCore import QThread, Signal
import logging
import sys
import os

# Ensure proxy module can be found
root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(root_dir)

from proxy.proxy import SeerProxy

class ProxyThread(QThread):
    """
    Background thread to run the SeerProxy (WinDivert).
    Requires Administrator privileges.
    """
    error_occurred = Signal(str)

    def __init__(self):
        super().__init__()
        self.proxy = None
        self._is_running = True

    def run(self):
        try:
            # logging.info("Starting Proxy Thread...")
            self.proxy = SeerProxy()
            self.proxy.start() # This is a blocking call (loop)
        except Exception as e:
            error_msg = f"failed to start:"
            logging.error(error_msg)
            self.error_occurred.emit(error_msg)
            
    def stop(self):
        # Note: pydivert is hard to stop gracefully from another thread 
        # because it blocks on driver calls.
        # Usually we just let it die with the process, 
        # or we might implement a stop flag if SeerProxy supports it.
        self._is_running = False
        # If SeerProxy had a stop() method, we'd call it here.
        logging.info("Stopping Proxy Thread (No-op, dependent on process exit)")
