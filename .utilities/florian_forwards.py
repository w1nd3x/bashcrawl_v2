import socket
import random
import string

def generate_secret_message():
    # Generate a random secret message
    secret_message = [
        "Felix Loves Fran",
        "Felix is making googly eyes at you! ;)",
        "I think Felix likes you!",
        "Felix x Fran",
        "Felix has a crush on you!!!"
    ]
    return random.choice(secret_message)

def start_server():
    # Generate a random port number
    port = random.randint(20000, 30000)

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(("0.0.0.0", port))
    server_socket.listen(1)
    print(f"Server listening on 0.0.0.0:{port}")

    while True:
        try:
            client_socket, client_address = server_socket.accept()
            print(f"Accepted connection from {client_address[0]}:{client_address[1]}")

            # Generate the secret message
            secret_message = generate_secret_message()

            # Send the secret message to the client
            client_socket.sendall(secret_message.encode())

            # Close the client socket
            client_socket.close()
        except:
            print("Just keep swimming")

if __name__ == "__main__":
    start_server()
