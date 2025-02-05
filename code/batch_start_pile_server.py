import subprocess
import os
import threading
from datetime import datetime

def log_stream(stream, data_file, prefix=""):
    """Helper function to continuously read and log output streams"""
    for line in stream:
        timestamp = datetime.now().strftime("%H:%M:%S")
        print(f"[{timestamp}][{data_file}]{prefix} {line.strip()}")

def launch_pile_servers(address_dir, num_servers=6):
    os.makedirs(address_dir, exist_ok=True)
    print(f"Created/verified directory: {address_dir}")
    
    processes = []
    threads = []
    
    for i in range(30):
        data_file = f"{i:02d}.jsonl"
        address_file = os.path.join(address_dir, f"addresses.txt")
        
        cmd = [
            "python3", "code/pile_server.py",
            "--address_path", address_file,
            "--data_file", data_file,
            "--num_servers", str(num_servers)
        ]
        
        print(f"\n[{datetime.now().strftime('%H:%M:%S')}] Launching server for {data_file}")
        print(f"Command: {' '.join(cmd)}")
        
        process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1
        )
        processes.append((data_file, process))
        
        # Create and start threads to monitor output streams
        stdout_thread = threading.Thread(
            target=log_stream, 
            args=(process.stdout, data_file)
        )
        stderr_thread = threading.Thread(
            target=log_stream, 
            args=(process.stderr, data_file, " ERROR:")
        )
        
        stdout_thread.start()
        stderr_thread.start()
        threads.extend([stdout_thread, stderr_thread])

    print(f"\n[{datetime.now().strftime('%H:%M:%S')}] All {len(processes)} servers launched. Monitoring logs...")

    # Wait for all processes to complete
    for data_file, process in processes:
        return_code = process.wait()
        print(f"\n[{datetime.now().strftime('%H:%M:%S')}] Server for {data_file} finished with return code {return_code}")

    # Wait for all logging threads to complete
    for thread in threads:
        thread.join()

    print(f"\n[{datetime.now().strftime('%H:%M:%S')}] All servers have finished execution.")

if __name__ == "__main__":
    ADDRESS_DIR = "servers"
    try:
        launch_pile_servers(ADDRESS_DIR)
    except KeyboardInterrupt:
        print("\nReceived keyboard interrupt, shutting down...")
    except Exception as e:
        print(f"\nError occurred: {str(e)}")