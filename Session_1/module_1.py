from typing import List


def task_1(array: List[int], target: int) -> List[int]:
    """running for loop in array and subtracting target by each element"""
    seen_elements = []
    result = []

    for num in array:
        complement = target - num
        if complement in seen_elements:
            result.append([complement, num])
        seen_elements.append(num)

    if len(result) == 1:
        return result[0]
    else:
        return result


def task_2(number: int) -> int:
    """
    Here we take the last digit using number %10"""
    result = 0
    sign = 1 if number >= 0 else -1
    number = abs(number)
    while number != 0:
        digit = number % 10
        result = result * 10 + digit
        number = number // 10

    return sign * result


print(task_2(-123))


def task_3(array: List[int]) -> int:
    length = len(array)
    result = -1
    for i in range(length):
        for j in range(i + 1, length):
            if array[j] == array[i]:
                if j - i < length:
                    length = j - i
                    result = array[j]
                    inner_result = task_3(array[i:j])
                    if inner_result != -1:
                        return inner_result
                if j - i == 1:
                    return result
                return array[j]
    return result


print(task_3([1, 2, 3, 3, 2]))


def task_4(string: str) -> int:
    """Here we use a dictionary to get arbitrary values that's given as input"""
    roman_dict = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}
    result = 0
    prev_value = 0
    for char in string:
        value = roman_dict[char]
        if value > prev_value:
            result += value - 2 * prev_value
        else:
            result += value
        prev_value = value

    return result


print(task_4("IX"))


def task_5(array: List[int]) -> int:
    """
    Write your code below
    """
    smallest = array[0]
    for num in array:
        if num < smallest:
            smallest = num
    return smallest
