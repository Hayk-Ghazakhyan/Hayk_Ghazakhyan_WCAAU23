import os
import re
from collections import Counter
from pathlib import Path
from random import choice, seed
from typing import List, Union

import requests
from requests.exceptions import ConnectionError, RequestException

# from requests.exceptions import ConnectionError, HTTPError,
# from gensim.utils import simple_preprocess


S5_PATH = Path(os.path.realpath(__file__)).parent

PATH_TO_NAMES = S5_PATH / "names.txt"
PATH_TO_SURNAMES = S5_PATH / "last_names.txt"
PATH_TO_OUTPUT = S5_PATH / "sorted_names_and_surnames.txt"
PATH_TO_TEXT = S5_PATH / "random_text.txt"
PATH_TO_STOP_WORDS = S5_PATH / "stop_words.txt"


def task_1():
    seed(1)
    # opened 2 files readed and saved requested info
    with open(PATH_TO_NAMES, "r", encoding="utf-8") as names_file, open(
        PATH_TO_SURNAMES, "r", encoding="utf-8"
    ) as surnames_file:
        names_content = [line.strip().lower() for line in names_file.readlines()]
        surnames_content = [line.strip().lower() for line in surnames_file.readlines()]

    # joining saved info and writing into the new file
    with open(
        "sorted_names_and_surnames.txt", "w", encoding="utf-8"
    ) as sorted_full_names:
        for i in sorted(names_content):
            sorted_full_names.write(i + " " + choice(surnames_content) + "\n")


def task_2(top_k: int):
    pass
    # open files and get list of stop_words and string of random_words
    with open(PATH_TO_STOP_WORDS, "r", encoding="utf-8") as stop_words_file, open(
        PATH_TO_TEXT, "r", encoding="utf-8"
    ) as random_words_file:
        stop_words = [word.strip().lower() for word in stop_words_file.readlines()]
        random_text_words = random_words_file.read().lower()

        # split and removing punctuation marks
        words = re.findall(r"\b\w+\b", random_text_words)

        # creating new list and adding only word which doesn't exists in stop_words
        filtered_words = [word for word in words if word not in stop_words]

        # counting elements and returning their amount using collections lib
        element_counts = Counter(filtered_words)
        result = element_counts.most_common(top_k)
        return result


# def task_3(url: str):
#     try:
#         response = requests.get(url)
#         response.raise_for_status()  # Raises an HTTPError for bad responses
#         return response
#     except


def task_3(url: str):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raises an HTTPError for bad responses
        return response
    except RequestException:
        return ConnectionError("Connection interrupted")


def task_4(data: List[Union[int, str, float]]):
    total_sum = 0
    for num in data:
        try:  # checking if we can change the type of num
            total_sum += float(num)
        except (TypeError, ValueError):  # except if can't change to float
            print("Skipping non-numeric value: {num}")

    return total_sum


def task_5():
    try:
        # Getting input and split into two variables
        num1, num2 = map(float, input("enter a number").split())

        result = num1 / num2
        print(result)
    except ValueError:
        print("Entered value is wrong")
    except ZeroDivisionError:
        print("Can't divide by zero")
