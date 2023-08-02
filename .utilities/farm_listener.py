import socket
import threading

user_profiles = {}
user_credentials = {}

def display_menu():
    return "Select an option:\n1. Create profile\n2. Login\n3. View profiles\n4. Send connection request\n5. Exit\n\nYour choice: "

def handle_client_connection(client_socket):
    client_socket.send(b"Welcome to Kingdom Singles!\n")
    while True:
        client_socket.send(display_menu().encode())
        choice = client_socket.recv(1024).decode().strip()

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
                client_socket.send(b"Login successful!\n")
            else:
                client_socket.send(b"Invalid credentials. Please try again.\n")

        elif choice == "3":
            if not user_profiles:
                client_socket.send(b"\nNo profiles found.\n")
            else:
                client_socket.send(b"\nUser Profiles:\n")
                for name, description in user_profiles.items():
                    client_socket.send(f"{name}: {description}\n".encode())

        elif choice == "4":
            client_socket.send(b"\nEnter the name of the user you want to connect with: ")
            target_user = client_socket.recv(1024).decode().strip()

            if target_user in user_profiles:
                client_socket.send(f"Connection request sent to {target_user}!\n".encode())
            else:
                client_socket.send(f"User '{target_user}' not found.\n".encode())

        elif choice == "5":
            client_socket.send(b"Thank you for using Kingdom Singles. Goodbye!\n")
            break

        else:
            client_socket.send(b"Invalid choice. Please select a valid option.\n")

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
    host = "localhost"  # Change this to your server's IP address if needed
    port = 12345  # Choose any available port number

    start_server(host, port)
