#!/bin/python3

import socket


upgrade_options = {
    1: ("Reinforced Handle", 20),
    2: ("Non-Stick Coating", 15),
    3: ("Spiked Base", 25),
    4: ("Heat-Resistant Grip", 30),
    5: ("Enchanted Coating", 30),
    6: ("Fissible Materials", 1337),
    # Add more upgrade options as needed
}


def display_menu():
    menu = "\n".join([f"{upgrade_id}. {upgrade}: ${price}" for upgrade_id, (upgrade, price) in upgrade_options.items()])
    return f"\nAvailable Frying Pan Upgrades:\n{menu}\n\nSelect an upgrade option (1-{len(upgrade_options)}) or enter '0' to exit: "

def handle_client_connection(client_socket):
    client_socket.send(b"Welcome to the Frying Pan Upgrade Shop!\n")
    while True:
        client_socket.send(display_menu().encode())
        choice = client_socket.recv(1024).decode().strip()

        try:
            choice = int(choice)
            if choice == 0:
                client_socket.send("Thank you for visiting the Frying Pan Upgrade Shop. Goodbye!\n".encode())
                break
            elif choice in upgrade_options:
                upgrade, price = upgrade_options[choice]
                client_socket.send(f"You have chosen '{upgrade}' for ${price}.\n".encode())
            else:
                client_socket.send("Invalid choice. Please select a valid option.\n".encode())
        except ValueError:
            client_socket.send("Invalid input. Please enter a number.\n".encode())

    client_socket.close()



def start_server(host, port):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))
    server_socket.listen(1)
    print(f"Server listening on {host}:{port}")

    while True:
        client_socket, client_address = server_socket.accept()
        print(f"Accepted connection from {client_address[0]}:{client_address[1]}")
        handle_client_connection(client_socket)
        client_socket.close()

if __name__ == "__main__":
    host = "localhost"  # Change this to your server's IP address if needed
    port = 8086

    start_server(host, port)