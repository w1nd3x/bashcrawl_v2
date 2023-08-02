import os
import socket
import threading

messages = [
    "Did you see? The princess crushed the witch! Now she's CEO of a networking company. Not cool!",
    "I'm fuming! Our wicked plans ruined. And she's thriving now? Unfair!",
    "Totally unfair! We need revenge. Let's devise a new scheme.",
    "Agreed. She won't know what hit her. Let's strike when she least expects it!",
]

def display_menu():
    return "Select an option:\n1. Add a new message\n2. Read old messages\n3. Exit\n\nYour choice: "

def handle_client_connection(client_socket):
    client_socket.send(b"Welcome to Crime Chat!\nKeep it quiet.\n")
    while True:
        client_socket.send(display_menu().encode())
        choice = client_socket.recv(1024).decode().strip()

        if choice == "1":
            client_socket.send(b"\nEnter your message: ")
            message = client_socket.recv(1024).decode().strip()
            messages.append(message)
            client_socket.send(b"Message posted successfully!\n")

        elif choice == "2":
            if not messages:
                client_socket.send(b"\nNo messages found.\n")
            else:
                client_socket.send(b"\nOld Messages:\n\n")
                for idx, message in enumerate(messages, start=1):
                    client_socket.send(f"{idx}. {message}\n\n".encode())

        elif choice == "3":
            client_socket.send(b"Thank you for using Crime Chat. Goodbye!\n")
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
    port_modifier = os.getenv('ID')
    host = "localhost"  # Change this to your server's IP address if needed
    port = 12345  # Choose any available port number

    start_server(host, port)
