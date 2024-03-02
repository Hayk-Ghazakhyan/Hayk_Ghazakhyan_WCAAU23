import time
from typing import List

Matrix = List[List[int]]


def task_1(exp: int):
    # Added wrapped function
    def power(num):
        return num**exp

    return power


def task_2(*args, **kwargs):
    # looping into multiple values
    for elem_args in args:
        print(elem_args)
    # looping into dictionaries
    for elem_kwargs in kwargs.values():
        print(elem_kwargs)


def helper(func):
    # decorator to add some functionality
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
        start_time = time.perf_counter()
        func(*args, **kwargs)
        end_time = time.perf_counter()
        result = end_time - start_time
        return f"Finished {func.__name__} in {result} secs"

    return wrapper


@timer
def task_4():
    return len([1 for _ in range(0, 10**8)])


def task_5(matrix: Matrix) -> Matrix:
    # * is to unpack
    # origin matrix [[1, 2], [3, 4]
    # unpacked [1, 2] [3, 4]
    # the request is get 2D matrix, and it allows use zip, because both list length are equal
    # zip returns corresponding elements in a tuple
    # (1, 3)
    # (2, 4)
    # list(row) [1, 3] [2, 4]
    # using in list comprehension we get previous row in a list [[1, 3] [2, 4]]
    transposed = [list(row) for row in zip(*matrix)]
    return transposed


def task_6(queue: str):
    pass
