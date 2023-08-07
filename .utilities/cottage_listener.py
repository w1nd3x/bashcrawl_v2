import socket
import time
import random

def send_secret_message(ip, port, secret_message):
    while True:
        try:
            # Create a socket object
            client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

            # Attempt to connect to the server
            client_socket.connect((ip, port))

            # Send the secret message to the server
            client_socket.sendall(secret_message.encode())

            # Close the socket after sending the message
            client_socket.close()

            print("Secret message sent successfully!")

            # Wait for 0.5 seconds before attempting the next connection
            time.sleep(0.5)

        except ConnectionRefusedError:
            print("Connection refused. The server may not be running or is unreachable.")
            # Wait for 0.5 seconds before attempting the next connection
            time.sleep(0.5)

        except OSError:
            print("Network is unreachable.  User may need to fix routes.")
            time.sleep(0.5)

        except KeyboardInterrupt:
            print("Terminating the program.")
            break

if __name__ == "__main__":
    target_ip = "10.0.120.111"  # Replace with the server's IP address
    target_port = 8085  # Replace with the server's port number
    secret_message = [
        "Where are my llamas?",
        "Give me back my Jordans!",
        "You wanted this!",
        "I just can't even with you!",
        "Do you even own a sheep???!?",
        "Count your own sheep!",
        "There can only be one sheep!",
        "One sheep to rule them all!",
        "One does not simply take sheep into Mordor!",
        "You're a sheep Harry!",
        "You're gonna need a bigger sheep.",
        "The sheep's name is Sting, you've seen it before.",
        "Too long have you hunted my sheep!",
        "Too long have you watched my sheep, too long have you haunted their footsteps!",
        "Look to my coming on the first light of the fifth day, at dawn look to the sheep.",
        "In place of a dark lord you would have a sheep! Not dark, but beautiful and fluffy as the dawn!",
        "The day may come when the courage of sheep fails!",
        "My sheep, you get sheared for no one.", 
        "Even the smallest sheep can change the course of the future."
    ]

    send_secret_message(target_ip, target_port, random.choice(secret_message))
