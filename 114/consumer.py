#!/usr/bin/env python
# coding=utf-8
import pika


def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)


def consumer(host='192.168.1.4'):
    # - connection to server + make new queuu
    connection = pika.BlockingConnection(pika.ConnectionParameters(host))
    channel = connection.channel()
    channel.queue_declare(queue='hello')
    # - addine new msg in queue
    channel.basic_consume(queue='hello', on_message_callback=callback,
                          auto_ack=False)
    channel.start_consuming()


if __name__ == '__main__':
    consumer()
