from collections import defaultdict as dd
from itertools import product
from typing import Any, Dict, List, Tuple


def task_1(data_1: Dict[str, int], data_2: Dict[str, int]):
    # New dictionary to store keys and values
    data_result = {}
    # Adding items from first dictionary
    for key in data_1:
        data_result[key] = data_1[key]
    # Iterating into the second dictionary
    for key in data_2:
        # Checking if the key already exists in new dictionary
        if key in data_result:
            data_result[key] += data_2[key]
        else:
            # Adding items from second dictionary
            data_result[key] = data_2[key]
    return data_result


def task_2():
    # Using dictionary comprehension
    d = {i: i**2 for i in range(1, 16)}
    return d


def task_3(data: Dict[Any, List[str]]):
    # unpacking and using product to join all elements
    result = ["".join(i) for i in product(*data.values())]
    return result


def task_4(data: Dict[str, int]):
    # Using items() to get a list of tuples containing key value pairs
    sorted_items = sorted(data.items(), key=lambda x: x[1], reverse=True)
    # using list comprehension to unpack the tuple and add kes in a list
    result = [key for key, _ in sorted_items[:3]]
    return result


def task_5(data: List[Tuple[Any, Any]]) -> Dict[str, List[int]]:
    # creating dictionary which value will be list using defaultdict
    result = dd(list)
    for key, value in data:
        # adding keys and values to the list
        result[key].append(value)
    return dict(result)


def task_6(data: List[Any]):
    pass


def task_7(words: [List[str]]) -> str:
    pass


def task_8(haystack: str, needle: str) -> int:
    pass
