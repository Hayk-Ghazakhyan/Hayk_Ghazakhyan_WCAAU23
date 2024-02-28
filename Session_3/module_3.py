import time
from typing import List

Matrix = List[List[int]]


def task_1(exp: int):
    def power(x):
        return x**exp

    return power


def task_2(*args, **kwags):
    for i in args:
        print(i)
    for i in kwags.values():
        print(i)


def helper(func):
    def wrapper(*args, **kwargs):
        print("Hi, friend! What's your name?")
        result = func(*args, **kwargs)
        print("See you soon!")
        return result

    return wrapper


@helper
def task_3(name: str):
    print(f"Hello! My name is {name}.")


def timer(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()
        func(*args, **kwargs)
        end_time = time.time()
        result = end_time - start_time
        return f"Finished {func.__name__} in {result} secs"

    return wrapper


@timer
def task_4():
    return len([1 for _ in range(0, 10**8)])


def task_5(matrix: Matrix) -> Matrix:
    transposed = [list(row) for row in zip(*matrix)]
    return transposed


def task_6(queue: str):
    pass
