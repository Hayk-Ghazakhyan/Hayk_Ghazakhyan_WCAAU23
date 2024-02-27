# from collections import defaultdict as dd
from itertools import product
from typing import Any, Dict, List, Tuple


def task_1(data_1: Dict[str, int], data_2: Dict[str, int]):
    for i in data_2:
        if i in data_1:
            data_1[i] += data_2[i]
        else:
            data_1[i] = data_2[i]
    return data_1


def task_2():
    d = {i: i**2 for i in range(1, 16)}
    return d


def task_3(data: Dict[Any, List[str]]):
    result = []
    for i in product(*data.values()):
        result.append("".join(i))
    return result


def task_4(data: Dict[str, int]):
    sorted_items = sorted(data.items(), key=lambda x: x[1], reverse=True)
    result = []
    for i, j in sorted_items[:3]:
        result.append(i)
    return result


def task_5(data: List[Tuple[Any, Any]]) -> Dict[str, List[int]]:
    d = {}
    for i, j in data:
        if i in d:
            d[i].append(j)
        else:
            d[i] = []
            d[i].append(j)
    return d


def task_6(data: List[Any]):
    pass


def task_7(words: [List[str]]) -> str:
    pass


def task_8(haystack: str, needle: str) -> int:
    pass
