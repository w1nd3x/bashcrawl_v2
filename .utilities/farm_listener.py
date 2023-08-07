import socket
import threading

user_profiles = {
    "Felix": "Just a city boy. Born and raised in South Detroit.  I took the midnight train and now I live in this Village",
    "Fran": "Just a small town girl.  Living in a lonely world.  I took the midnight train and ended up in this town.  Where I proceeded to end up in jail.... But I'm on the straight and narrow now.",
    "Flem": "flag{farm-friends-forever}"
    }
user_credentials = {
    "felix":"farm-hand",
    "fran":"farm-free"
}
logged_in_users = set()

def display_menu(logged_in):
    menu = "Select an option:\n"
    if logged_in:
        menu += "1. View profiles\n2. Send connection request\n3. Logout\n4. Exit\n\nYour choice: "
    else:
        menu += "1. Create profile\n2. Login\n3. Exit\n\nYour choice: "
    return menu

def handle_client_connection(client_socket):
    logged_in = False
    username = None

    def logout():
        nonlocal logged_in, username
        logged_in_users.discard(username)
        logged_in = False
        username = None

    client_socket.send(b"Welcome to Kingdom Singles!\n")
    try:
        while True:
            client_socket.send(display_menu(logged_in).encode())
            choice = client_socket.recv(1024).decode().strip()

            if not logged_in:
                if choice == "1":
                    client_socket.send(b"\nEnter your username: ")
                    username = client_socket.recv(1024).decode().strip()

                    if username in user_credentials:
                        client_socket.send(b"Username already exists. Please choose a different one.\n")
                        continue

                    client_socket.send(b"Enter your password: ")
                    password = client_socket.recv(1024).decode().strip()

                    client_socket.send(b"\nEnter your name: ")
                    name = client_socket.recv(1024).decode().strip()

                    client_socket.send(b"\nEnter a brief description: ")
                    description = client_socket.recv(1024).decode().strip()

                    user_profiles[name] = description
                    user_credentials[username] = password

                    client_socket.send(b"Profile created successfully!\n")
                elif choice == "2":
                    client_socket.send(b"\nEnter your username: ")
                    username = client_socket.recv(1024).decode().strip()

                    if username not in user_credentials:
                        client_socket.send(b"Username not found. Please create a profile first.\n")
                        continue

                    client_socket.send(b"Enter your password: ")
                    password = client_socket.recv(1024).decode().strip()

                    if user_credentials.get(username) == password:
                        logged_in_users.add(username)
                        logged_in = True
                        client_socket.send(b"Login successful!\n")
                    else:
                        client_socket.send(b"Invalid credentials. Please try again.\n")
                elif choice == "3":
                    client_socket.send(b"Thank you for using Kingdom Singles. Goodbye!\n")
                    break
                else:
                    client_socket.send(b"Invalid choice. Please select a valid option.\n")
            else:
                if choice == "1":
                    if not user_profiles:
                        client_socket.send(b"\nNo profiles found.\n")
                    else:
                        client_socket.send(b"\nUser Profiles:\n")
                        for name, description in user_profiles.items():
                            client_socket.send(f"{name}: \n{description}\n\n".encode())

                elif choice == "2":
                    client_socket.send(b"\nEnter the name of the user you want to connect with: ")
                    target_user = client_socket.recv(1024).decode().strip()

                    if target_user in user_profiles:
                        client_socket.send(f"Connection request sent to {target_user}!\n".encode())
                    else:
                        client_socket.send(f"User '{target_user}' not found.\n".encode())

                elif choice == "3":
                    logout()
                    client_socket.send(b"Logout successful!\n")
                elif choice == "4":
                    logout()
                    client_socket.send(b"Thank you for using Kingdom Singles. Goodbye!\n")
                    break
                else:
                    client_socket.send(b"Invalid choice. Please select a valid option.\n")
    except:
        print("Connection Error")
        if logged_in and username:
            logout()
    client_socket.close()

def start_server(host, port):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))
    server_socket.listen(5)
    print(f"Server listening on {host}:{port}")

    while True:
        client_socket, client_address = server_socket.accept()
        print(f"Accepted connection from {client_address[0]}:{client_address[1]}")
        client_handler = threading.Thread(target=handle_client_connection, args=(client_socket,))
        client_handler.start()

if __name__ == "__main__":
    host = "0.0.0.0"  # Change this to your server's IP address if needed
    port = 8080  # Choose any available port number

    start_server(host, port)