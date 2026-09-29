import http.server
import socketserver
import webbrowser
import os
import sys

PORT = 8080
DIRECTORY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "build", "web")

if not os.path.exists(DIRECTORY):
    print(f"[!] Error: Web build directory not found: {DIRECTORY}")
    print("[*] Please run 'flutter build web' first.")
    sys.exit(1)

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def log_message(self, format, *args):
        # Silence verbose request logs
        pass

# Find available port
for p in [8080, 8085, 8090, 8888, 3005]:
    try:
        httpd = socketserver.TCPServer(("", p), CustomHandler)
        PORT = p
        break
    except OSError:
        continue
else:
    httpd = socketserver.TCPServer(("", 0), CustomHandler)
    PORT = httpd.server_address[1]

url = f"http://localhost:{PORT}/"
print("=" * 65)
print("             SPECS APP - INSTANT WEB SERVER")
print("=" * 65)
print(f"[+] Serving AppSpecs from: {DIRECTORY}")
print(f"[+] Server is running at: {url}")
print("[+] Opening your web browser now...")
print("=" * 65)
print("[*] Press Ctrl+C in this window at any time to stop the server.")
print("=" * 65)

webbrowser.open(url)

try:
    httpd.serve_forever()
except KeyboardInterrupt:
    print("\n[+] Server stopped.")
    httpd.server_close()
