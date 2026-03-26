import sys
import os

# Add the src directory to sys.path so we can run from root
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from proxy import SeerProxy

def main():
    proxy = SeerProxy()
    try:
        proxy.start()
    except KeyboardInterrupt:
        print("\n[Proxy] Shutting down...")
    except Exception as e:
        print(f"\n[Error] {e}")

if __name__ == "__main__":
    main()