#!/usr/bin/env python
# coding=utf-8
import pika

def producer(host='192.168.1.12'):
    connection = pika.BlockingConnection(pika.ConnectionParameters(host))
    channel = connection.channel()
    channel.queue_declare(queue='hello')
    channel.basic_publish(exchange='', routing_key='hello', body='Hello Netology!')
    connection.close()

if __name__ == '__main__':
    producer()
